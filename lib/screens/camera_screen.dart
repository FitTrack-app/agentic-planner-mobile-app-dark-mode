// lib/camera_screen.dart
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:permission_handler/permission_handler.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

// Theme (same palette you used)
class AppTheme {
  static Color primaryColor = Colors.blue[600]!;
  static Color backgroundColor = Colors.black;
  static Color cardColor = Colors.grey[800]!;
  static Color textColor = Colors.white;
  static Color subtextColor = Colors.grey[400]!;
}

class CameraScreen extends StatefulWidget {
  final String exerciseName; // e.g. "Plank", "Squats", etc.
  const CameraScreen({Key? key, required this.exerciseName}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  // ⇩⇩ PUT YOUR PC'S IP HERE (the one running python server.py) ⇩⇩
  static const String serverUrl = 'ws://172.20.10.3:8000/ws';

  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _permissionGranted = false;
  bool _isInitialized = false;

  bool _isRecording = false;

  WebSocketChannel? _ws;

  // Throttle & encoding control
  bool _processing = false;
  int _lastSendMs = 0;

  // Data from backend
  int _percent = 0; // 0..100
  int _holdSeconds = 0; // seconds of "good form" (only when percent==100)

  // Exercise name -> server key
  String get _serverKey {
    switch (widget.exerciseName.toLowerCase()) {
      case 'plank':
        return 'plank';
      // add more once backend analyzers return {"percent","hold"} for them
      default:
        return 'plank';
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _stopStreaming();
    _closeWs();
    _controller?.dispose();
    super.dispose();
  }

  // ———————————  CAMERA  ———————————

  Future<void> _initializeCamera() async {
    // Request camera permission
    final permission = await Permission.camera.request();

    if (permission == PermissionStatus.granted) {
      setState(() => _permissionGranted = true);
      try {
        _cameras = await availableCameras();
        if (_cameras != null && _cameras!.isNotEmpty) {
          // Prefer FRONT camera (self coaching), else fallback to first
          final selected = _cameras!.firstWhere(
            (c) => c.lensDirection == CameraLensDirection.front,
            orElse: () => _cameras!.first,
          );

          _controller = CameraController(
            selected,
            ResolutionPreset.low, // lower = smoother over WS
            enableAudio: false,
            imageFormatGroup: ImageFormatGroup.yuv420,
          );

          await _controller!.initialize();
          if (mounted) setState(() => _isInitialized = true);
        }
      } catch (e) {
        debugPrint('Error initializing camera: $e');
      }
    } else {
      setState(() => _permissionGranted = false);
    }
  }

  Future<void> _startStreaming() async {
    if (_controller == null) return;
    if (!_controller!.value.isInitialized) return;
    if (_controller!.value.isStreamingImages) return;
    await _controller!.startImageStream(_onFrame);
  }

  Future<void> _stopStreaming() async {
    if (_controller == null) return;
    if (_controller!.value.isStreamingImages) {
      await _controller!.stopImageStream();
    }
  }

  void _onFrame(CameraImage imgYuv) async {
    // Limit to ~5 fps to keep UI smooth and avoid crashes
    final now = DateTime.now().millisecondsSinceEpoch;
    if (_processing || now - _lastSendMs < 200) return;
    _lastSendMs = now;
    _processing = true;

    try {
      final jpg = _yuv420ToJpeg(imgYuv, quality: 40); // lighter payload
      _ws?.sink.add(jsonEncode({"frame": base64Encode(jpg)}));
    } catch (_) {
      // swallow encoding errors
    } finally {
      _processing = false;
    }
  }

  // YUV420 -> JPEG (works on Android/iOS)
  Uint8List _yuv420ToJpeg(CameraImage imgYuv, {int quality = 40}) {
    final w = imgYuv.width, h = imgYuv.height;
    final yPlane = imgYuv.planes[0];
    final uPlane = imgYuv.planes[1];
    final vPlane = imgYuv.planes[2];

    final yBytes = yPlane.bytes;
    final uBytes = uPlane.bytes;
    final vBytes = vPlane.bytes;

    final yStride = yPlane.bytesPerRow;
    final uStride = uPlane.bytesPerRow;
    final uvPixStride = uPlane.bytesPerPixel ?? 1;

    final out = img.Image(width: w, height: h);

    for (int ry = 0; ry < h; ry++) {
      final yRow = ry * yStride;
      final uvRow = (ry ~/ 2) * uStride;
      for (int rx = 0; rx < w; rx++) {
        final yIndex = yRow + rx;
        final uvIndex = uvRow + (rx ~/ 2) * uvPixStride;

        final Y = yBytes[yIndex];
        final U = uBytes[uvIndex] - 128;
        final V = vBytes[uvIndex] - 128;

        // YUV -> RGB
        int r = (Y + 1.370705 * V).round().clamp(0, 255);
        int g = (Y - 0.337633 * U - 0.698001 * V).round().clamp(0, 255);
        int b = (Y + 1.732446 * U).round().clamp(0, 255);

        out.setPixelRgba(rx, ry, r, g, b, 255);
      }
    }
    return Uint8List.fromList(img.encodeJpg(out, quality: quality));
  }

  // ———————————  WEBSOCKET  ———————————

  void _openWs() {
    _ws = WebSocketChannel.connect(Uri.parse(serverUrl));

    // Announce the selected exercise once
    _ws!.sink.add(jsonEncode({"type": _serverKey}));

    // Listen for {"percent": int, "hold": int}
    _ws!.stream.listen(
      (event) {
        try {
          final m = jsonDecode(event as String) as Map<String, dynamic>;
          final p = (m['percent'] as num?)?.toInt() ?? _percent;
          final h = (m['hold'] as num?)?.toInt() ?? _holdSeconds;

          bool changed = false;
          if (p != _percent) {
            _percent = p;
            changed = true;
          }
          if (h != _holdSeconds) {
            _holdSeconds = h;
            changed = true;
          }
          if (changed && mounted) setState(() {});
        } catch (e) {
          debugPrint('WS parse error: $e');
        }
      },
      onError: (e) => debugPrint('WS error: $e'),
      onDone: () => debugPrint('WS closed'),
    );
  }

  void _closeWs() {
    try {
      _ws?.sink.close();
    } catch (_) {}
    _ws = null;
  }

  // ———————————  WORKOUT FLOW  ———————————

  void _startWorkout() async {
    setState(() {
      _isRecording = true;
      _percent = 0;
      _holdSeconds = 0;
    });
    _openWs();
    await _startStreaming();
  }

  Future<void> _stopWorkout() async {
    setState(() => _isRecording = false);
    await _stopStreaming();
    _closeWs();

    _showWorkoutCompletedDialog();
  }

  void _showWorkoutCompletedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardColor,
        title: Text(
          'Workout Completed!',
          style: TextStyle(color: AppTheme.textColor),
        ),
        content: Text(
          'Great job on your ${widget.exerciseName} workout!\n\n'
          'Hold (good form): ${_formatTime(_holdSeconds)}\n'
          'Estimated calories: ${(_holdSeconds * 0.1).round()}',
          style: TextStyle(color: AppTheme.subtextColor),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              Navigator.pop(context); // back to dashboard
            },
            child: Text('Done', style: TextStyle(color: AppTheme.primaryColor)),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  // ———————————  UI  ———————————

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppTheme.textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.exerciseName,
          style: TextStyle(
            color: AppTheme.textColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (!_permissionGranted) return _buildPermissionDeniedView();
    if (!_isInitialized)
      return const Center(child: CircularProgressIndicator());

    return Column(
      children: [
        // Camera preview
        Expanded(
          flex: 3,
          child: Container(
            margin: const EdgeInsets.all(16),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
            child: CameraPreview(_controller!),
          ),
        ),

        // Metrics + Controls
        Expanded(
          flex: 1,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _metric('Percent', '$_percent %'),
                    _metric('Hold (good form)', _formatTime(_holdSeconds)),
                  ],
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!_isRecording)
                      ElevatedButton(
                        onPressed: _startWorkout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: const Text(
                          'Start Workout',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    else
                      ElevatedButton(
                        onPressed: _stopWorkout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[600],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: const Text(
                          'Stop Workout',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _metric(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: AppTheme.textColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: AppTheme.subtextColor, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildPermissionDeniedView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.camera_alt_outlined,
              color: AppTheme.subtextColor,
              size: 80,
            ),
            const SizedBox(height: 24),
            Text(
              'Camera Permission Required',
              style: TextStyle(
                color: AppTheme.textColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'This app needs camera access to provide workout guidance and form correction during exercises.',
              style: TextStyle(color: AppTheme.subtextColor, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => openAppSettings(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text(
                'Open Settings',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
