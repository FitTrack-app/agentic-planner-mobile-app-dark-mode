import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

// Using the same AppTheme from your existing code
class AppTheme {
  static Color primaryColor = Colors.blue[600]!;
  static Color backgroundColor = Colors.black;
  static Color cardColor = Colors.grey[800]!;
  static Color textColor = Colors.white;
  static Color subtextColor = Colors.grey[400]!;
}

class CameraScreen extends StatefulWidget {
  final String exerciseName;

  const CameraScreen({Key? key, required this.exerciseName}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;
  bool _isRecording = false;
  bool _permissionGranted = false;
  Timer? _workoutTimer;
  int _secondsElapsed = 0;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    // Request camera permission
    final permission = await Permission.camera.request();

    if (permission == PermissionStatus.granted) {
      setState(() {
        _permissionGranted = true;
      });

      try {
        // Get available cameras
        _cameras = await availableCameras();

        if (_cameras != null && _cameras!.isNotEmpty) {
          // Use front camera if available, otherwise use first camera
          CameraDescription selectedCamera = _cameras!.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front,
            orElse: () => _cameras!.first,
          );

          _controller = CameraController(
            selectedCamera,
            ResolutionPreset.medium,
            enableAudio: false,
          );

          await _controller!.initialize();

          if (mounted) {
            setState(() {
              _isInitialized = true;
            });
          }
        }
      } catch (e) {
        print('Error initializing camera: $e');
      }
    } else {
      setState(() {
        _permissionGranted = false;
      });
    }
  }

  void _startWorkout() {
    setState(() {
      _isRecording = true;
      _secondsElapsed = 0;
    });

    _workoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsElapsed++;
      });
    });
  }

  void _stopWorkout() {
    setState(() {
      _isRecording = false;
    });

    _workoutTimer?.cancel();

    // Show workout completion dialog
    _showWorkoutCompletedDialog();
  }

  void _showWorkoutCompletedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.cardColor,
          title: Text(
            'Workout Completed!',
            style: TextStyle(color: AppTheme.textColor),
          ),
          content: Text(
            'Great job on your ${widget.exerciseName} workout!\n\nTime: ${_formatTime(_secondsElapsed)}\nEstimated calories burned: ${(_secondsElapsed * 0.1).round()}',
            style: TextStyle(color: AppTheme.subtextColor),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Return to workout dashboard
              },
              child: Text(
                'Done',
                style: TextStyle(color: AppTheme.primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _controller?.dispose();
    _workoutTimer?.cancel();
    super.dispose();
  }

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
    if (!_permissionGranted) {
      return _buildPermissionDeniedView();
    }

    if (!_isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

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

        // Workout info and controls
        Expanded(
          flex: 1,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Timer display
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.cardColor,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    _formatTime(_secondsElapsed),
                    style: TextStyle(
                      color: AppTheme.textColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Exercise instructions
                if (!_isRecording)
                  Text(
                    'Position yourself in front of the camera and start your ${widget.exerciseName} workout',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppTheme.subtextColor,
                      fontSize: 14,
                    ),
                  ),

                if (_isRecording)
                  Text(
                    'Keep going! The camera is tracking your form.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                const Spacer(),

                // Control buttons
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
                      ),

                    if (_isRecording)
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
              onPressed: () {
                openAppSettings();
              },
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
