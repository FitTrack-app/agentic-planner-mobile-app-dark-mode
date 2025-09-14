import 'package:flutter/material.dart';

// Color theme data class
class AppTheme {
  static Color primaryColor = Colors.blue[600]!;
  static Color backgroundColor = Colors.black;
  static Color cardColor = Colors.grey[800]!;
  static Color textColor = Colors.white;
  static Color subtextColor = Colors.grey[400]!;

  static void updatePrimaryColor(Color newColor) {
    primaryColor = newColor;
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _redValue = 33.0; // Default blue color values
  double _greenValue = 150.0;
  double _blueValue = 243.0;

  @override
  void initState() {
    super.initState();
    // Initialize sliders with current primary color values
    _redValue = AppTheme.primaryColor.red.toDouble();
    _greenValue = AppTheme.primaryColor.green.toDouble();
    _blueValue = AppTheme.primaryColor.blue.toDouble();
  }

  void _updatePrimaryColor() {
    setState(() {
      AppTheme.updatePrimaryColor(
        Color.fromRGBO(
          _redValue.round(),
          _greenValue.round(),
          _blueValue.round(),
          1.0,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          // Fitness-themed background with gradient overlay
          image: DecorationImage(
            image: NetworkImage(
              'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80',
            ),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.7),
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(flex: 2),

                // App Logo/Title
                Text(
                  'FitTrack',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppTheme.textColor,
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -2,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 2),
                        blurRadius: 4,
                        color: Colors.black.withOpacity(0.8),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Animated accent line
                Container(
                  height: 4,
                  width: 80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primaryColor,
                        AppTheme.primaryColor.withOpacity(0.3),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                const SizedBox(height: 32),

                // Description
                Text(
                  'Your journey to a healthier you starts now.\n\nTrack your progress, set goals, and achieve\nyour fitness aspirations with personalized\nworkouts and nutrition guidance.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppTheme.textColor.withOpacity(0.9),
                    fontSize: 18,
                    height: 1.6,
                    fontWeight: FontWeight.w400,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 1),
                        blurRadius: 2,
                        color: Colors.black.withOpacity(0.6),
                      ),
                    ],
                  ),
                ),

                const Spacer(flex: 2),

                // RGB Color Customization Panel
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppTheme.cardColor.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppTheme.primaryColor.withOpacity(0.3),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.palette,
                            color: AppTheme.primaryColor,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Customize Theme Color',
                            style: TextStyle(
                              color: AppTheme.textColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Color Preview
                      Center(
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryColor.withOpacity(0.4),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.fitness_center,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Red Slider
                      _buildColorSlider('Red', _redValue, Colors.red, (value) {
                        setState(() {
                          _redValue = value;
                          _updatePrimaryColor();
                        });
                      }),

                      const SizedBox(height: 16),

                      // Green Slider
                      _buildColorSlider('Green', _greenValue, Colors.green, (
                        value,
                      ) {
                        setState(() {
                          _greenValue = value;
                          _updatePrimaryColor();
                        });
                      }),

                      const SizedBox(height: 16),

                      // Blue Slider
                      _buildColorSlider('Blue', _blueValue, Colors.blue, (
                        value,
                      ) {
                        setState(() {
                          _blueValue = value;
                          _updatePrimaryColor();
                        });
                      }),

                      const SizedBox(height: 20),

                      // RGB Values Display
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.backgroundColor.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'RGB(${_redValue.round()}, ${_greenValue.round()}, ${_blueValue.round()})',
                              style: TextStyle(
                                color: AppTheme.textColor,
                                fontSize: 14,
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Quick Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildQuickActionButton(
                      icon: Icons.play_arrow,
                      label: 'Start Workout',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Starting workout...'),
                            backgroundColor: AppTheme.primaryColor,
                          ),
                        );
                      },
                    ),
                    _buildQuickActionButton(
                      icon: Icons.analytics,
                      label: 'View Progress',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Opening progress...'),
                            backgroundColor: AppTheme.primaryColor,
                          ),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildColorSlider(
    String label,
    double value,
    Color color,
    Function(double) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: AppTheme.textColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.backgroundColor.withOpacity(0.5),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                value.round().toString(),
                style: TextStyle(
                  color: AppTheme.textColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: color,
            inactiveTrackColor: color.withOpacity(0.3),
            thumbColor: color,
            overlayColor: color.withOpacity(0.2),
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
            trackHeight: 4,
          ),
          child: Slider(
            value: value,
            min: 0,
            max: 255,
            divisions: 255,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppTheme.primaryColor,
              AppTheme.primaryColor.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withOpacity(0.3),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
