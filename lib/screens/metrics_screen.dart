import 'package:flutter/material.dart';
import '/main.dart';

class MetricsScreen extends StatefulWidget {
  const MetricsScreen({Key? key}) : super(key: key);

  @override
  _MetricsScreenState createState() => _MetricsScreenState();
}

class _MetricsScreenState extends State<MetricsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  String selectedTimeFrame = '30D';

  // Données pour différentes périodes de temps
  final Map<String, Map<String, List<ChartData>>> allTimeFrameData = {
    '7D': {
      'weight': [
        ChartData('Mon', 149.2),
        ChartData('Tue', 149.5),
        ChartData('Wed', 149.1),
        ChartData('Thu', 149.8),
        ChartData('Fri', 150.0),
        ChartData('Sat', 149.7),
        ChartData('Sun', 150.2),
      ],
      'rm': [
        ChartData('Mon', 198),
        ChartData('Tue', 200),
        ChartData('Wed', 199),
        ChartData('Thu', 201),
        ChartData('Fri', 202),
        ChartData('Sat', 200),
        ChartData('Sun', 203),
      ],
      'volume': [
        ChartData('Mon', 4800),
        ChartData('Tue', 5200),
        ChartData('Wed', 4600),
        ChartData('Thu', 5400),
        ChartData('Fri', 5000),
        ChartData('Sat', 4900),
        ChartData('Sun', 5300),
      ],
    },
    '30D': {
      'weight': [
        ChartData('Jan', 145),
        ChartData('Feb', 147),
        ChartData('Mar', 148),
        ChartData('Apr', 146),
        ChartData('May', 149),
        ChartData('Jun', 150),
      ],
      'rm': [
        ChartData('Jan', 180),
        ChartData('Feb', 185),
        ChartData('Mar', 190),
        ChartData('Apr', 195),
        ChartData('May', 198),
        ChartData('Jun', 200),
      ],
      'volume': [
        ChartData('Jan', 3500),
        ChartData('Feb', 3800),
        ChartData('Mar', 4200),
        ChartData('Apr', 4500),
        ChartData('May', 4800),
        ChartData('Jun', 5000),
      ],
    },
    '90D': {
      'weight': [
        ChartData('Q1 2023', 142),
        ChartData('Q2 2023', 145),
        ChartData('Q3 2023', 148),
        ChartData('Q4 2023', 150),
      ],
      'rm': [
        ChartData('Q1 2023', 170),
        ChartData('Q2 2023', 185),
        ChartData('Q3 2023', 195),
        ChartData('Q4 2023', 203),
      ],
      'volume': [
        ChartData('Q1 2023', 3200),
        ChartData('Q2 2023', 4100),
        ChartData('Q3 2023', 4700),
        ChartData('Q4 2023', 5300),
      ],
    },
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return _buildMetricCard(
                          title: 'Weight Trend',
                          value: _getCurrentValue('weight'),
                          unit: 'lbs',
                          percentage: _getPercentageChange('weight'),
                          data: allTimeFrameData[selectedTimeFrame]!['weight']!,
                          gradient: [
                            const Color(0xFFFF6B35).withOpacity(0.8),
                            const Color(0xFFFF8E53).withOpacity(0.6),
                          ],
                          lineColor: const Color(0xFFFF6B35),
                          delay: 0.0,
                          metricKey: 'weight',
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return _buildMetricCard(
                          title: '1RM Estimate',
                          value: _getCurrentValue('rm'),
                          unit: 'lbs',
                          percentage: _getPercentageChange('rm'),
                          data: allTimeFrameData[selectedTimeFrame]!['rm']!,
                          gradient: [
                            const Color(0xFF4ECDC4).withOpacity(0.8),
                            const Color(0xFF6EE7B7).withOpacity(0.6),
                          ],
                          lineColor: const Color(0xFF4ECDC4),
                          delay: 0.2,
                          metricKey: 'rm',
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return _buildMetricCard(
                          title: 'Total Volume',
                          value: _getCurrentValue('volume'),
                          unit: 'lbs',
                          percentage: _getPercentageChange('volume'),
                          data: allTimeFrameData[selectedTimeFrame]!['volume']!,
                          gradient: [
                            const Color(0xFF8B5CF6).withOpacity(0.8),
                            const Color(0xFFA78BFA).withOpacity(0.6),
                          ],
                          lineColor: const Color(0xFF8B5CF6),
                          delay: 0.4,
                          metricKey: 'volume',
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    _buildExportButton(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: AppTheme.textColor,
              size: 24,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              'Metrics',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.textColor,
                fontSize: 24,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
          ),
          const SizedBox(width: 48), // Balance pour centrer le titre
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String unit,
    required String percentage,
    required List<ChartData> data,
    required List<Color> gradient,
    required Color lineColor,
    required double delay,
    required String metricKey,
  }) {
    return Transform.translate(
      offset: Offset(0, 50 * (1 - _animation.value)),
      child: Opacity(
        opacity: _animation.value,
        child: Container(
          height: 280,
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.cardColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 8),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header avec titre et période
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: AppTheme.textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.3,
                    ),
                  ),
                  _buildTimeFilters(metricKey),
                ],
              ),
              const SizedBox(height: 16),

              // Valeur principale et pourcentage
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      color: AppTheme.textColor,
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      unit,
                      style: TextStyle(
                        color: AppTheme.subtextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: lineColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.trending_up_rounded,
                          color: lineColor,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          percentage,
                          style: TextStyle(
                            color: lineColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Graphique
              Expanded(child: _buildSmoothChart(data, gradient, lineColor)),

              const SizedBox(height: 16),

              // Timeline des mois
              _buildTimelineLabels(data),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeFilters(String metricKey) {
    final timeFrames = ['7D', '30D', '90D'];

    return Wrap(
      spacing: 8, // espace horizontal
      children: timeFrames.map((timeFrame) {
        final isSelected = selectedTimeFrame == timeFrame;
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedTimeFrame = timeFrame;
              _animationController.reset();
              _animationController.forward();
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.primaryColor.withOpacity(0.2)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? AppTheme.primaryColor
                    : AppTheme.subtextColor.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Text(
              timeFrame,
              style: TextStyle(
                color: isSelected
                    ? AppTheme.primaryColor
                    : AppTheme.subtextColor,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSmoothChart(
    List<ChartData> data,
    List<Color> gradientColors,
    Color lineColor,
  ) {
    return CustomPaint(
      size: const Size(double.infinity, 120),
      painter: _ModernChartPainter(
        data: data,
        gradientColors: gradientColors,
        lineColor: lineColor,
        animation: _animation.value,
      ),
    );
  }

  Widget _buildTimelineLabels(List<ChartData> data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: data.map((item) {
        return Flexible(
          // Ajout de Flexible pour éviter l'overflow
          child: Text(
            item.month,
            style: TextStyle(
              color: AppTheme.subtextColor,
              fontSize: 12, // Réduction légère de la taille
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis, // Gestion du débordement
            textAlign: TextAlign.center,
          ),
        );
      }).toList(),
    );
  }

  // Méthodes pour obtenir les valeurs actuelles selon la période sélectionnée
  String _getCurrentValue(String metricKey) {
    final data = allTimeFrameData[selectedTimeFrame]![metricKey]!;
    final lastValue = data.last.value;

    if (metricKey == 'volume') {
      return lastValue.toStringAsFixed(0);
    } else {
      return lastValue.toStringAsFixed(0);
    }
  }

  String _getPercentageChange(String metricKey) {
    final data = allTimeFrameData[selectedTimeFrame]![metricKey]!;
    if (data.length < 2) return '+0%';

    final firstValue = data.first.value;
    final lastValue = data.last.value;
    final percentageChange = ((lastValue - firstValue) / firstValue * 100);

    final sign = percentageChange >= 0 ? '+' : '';
    return '$sign${percentageChange.toStringAsFixed(0)}%';
  }

  Widget _buildExportButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor,
            AppTheme.primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: _exportCSV,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        icon: const Icon(
          Icons.file_download_outlined,
          color: Colors.white,
          size: 22,
        ),
        label: const Text(
          'Export CSV',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  void _exportCSV() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Export Successful',
            style: TextStyle(
              color: AppTheme.textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Your training metrics have been exported as CSV.',
            style: TextStyle(color: AppTheme.subtextColor),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'OK',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ChartData {
  final String month;
  final double value;

  ChartData(this.month, this.value);
}

class _ModernChartPainter extends CustomPainter {
  final List<ChartData> data;
  final List<Color> gradientColors;
  final Color lineColor;
  final double animation;

  _ModernChartPainter({
    required this.data,
    required this.gradientColors,
    required this.lineColor,
    required this.animation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    // Configuration des peintures
    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          gradientColors[0],
          gradientColors[1],
          gradientColors[1].withOpacity(0.1),
          Colors.transparent,
        ],
        stops: const [0.0, 0.3, 0.7, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final dotPaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;

    final dotBorderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Calculer les valeurs min/max avec padding
    final values = data.map((e) => e.value).toList();
    final minValue = values.reduce((a, b) => a < b ? a : b);
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    final range = maxValue - minValue;
    final padding = range * 0.1; // 10% de padding en haut et en bas

    // Générer les points
    final points = <Offset>[];
    for (int i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * size.width;
      final normalizedValue =
          (data[i].value - minValue + padding) / (range + 2 * padding);
      final y = size.height - (normalizedValue * size.height);
      points.add(Offset(x, y));
    }

    // Créer le chemin pour la courbe lisse
    final path = Path();
    final fillPath = Path();

    if (points.isNotEmpty) {
      // Commencer le chemin
      path.moveTo(points[0].dx, points[0].dy);
      fillPath.moveTo(0, size.height);
      fillPath.lineTo(points[0].dx, points[0].dy);

      // Créer une courbe de Bézier cubique lisse
      for (int i = 1; i < points.length; i++) {
        final p0 = i > 1 ? points[i - 2] : points[0];
        final p1 = points[i - 1];
        final p2 = points[i];
        final p3 = i < points.length - 1 ? points[i + 1] : points[i];

        // Calculer les points de contrôle pour une courbe lisse
        final cp1x = p1.dx + (p2.dx - p0.dx) / 6;
        final cp1y = p1.dy + (p2.dy - p0.dy) / 6;
        final cp2x = p2.dx - (p3.dx - p1.dx) / 6;
        final cp2y = p2.dy - (p3.dy - p1.dy) / 6;

        path.cubicTo(cp1x, cp1y, cp2x, cp2y, p2.dx, p2.dy);
        fillPath.cubicTo(cp1x, cp1y, cp2x, cp2y, p2.dx, p2.dy);
      }

      // Compléter le remplissage
      fillPath.lineTo(size.width, size.height);
      fillPath.close();

      // Dessiner avec animation
      final animatedPath = _createAnimatedPath(path, animation);
      final animatedFillPath = _createAnimatedPath(fillPath, animation);

      // Dessiner le remplissage
      canvas.drawPath(animatedFillPath, fillPaint);

      // Dessiner la ligne
      canvas.drawPath(animatedPath, linePaint);

      // Dessiner les points de données animés
      for (int i = 0; i < points.length; i++) {
        final progress = (animation * data.length - i).clamp(0.0, 1.0);
        if (progress > 0) {
          final point = points[i];

          // Point externe (blanc)
          canvas.drawCircle(point, 6 * progress, dotBorderPaint);

          // Point interne (coloré)
          canvas.drawCircle(point, 4 * progress, dotPaint);
        }
      }
    }
  }

  Path _createAnimatedPath(Path originalPath, double progress) {
    final pathMetrics = originalPath.computeMetrics();
    final animatedPath = Path();

    for (final metric in pathMetrics) {
      final extractPath = metric.extractPath(0, metric.length * progress);
      animatedPath.addPath(extractPath, Offset.zero);
    }

    return animatedPath;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Redessiner pour l'animation
  }
}
