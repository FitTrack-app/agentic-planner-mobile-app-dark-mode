import 'package:flutter/material.dart';
import 'camera_screen.dart'; // Import the camera screen

// Using the same AppTheme from your existing code
class AppTheme {
  static Color primaryColor = Colors.blue[600]!;
  static Color backgroundColor = Colors.black;
  static Color cardColor = Colors.grey[800]!;
  static Color textColor = Colors.white;
  static Color subtextColor = Colors.grey[400]!;
}

class WorkoutDashboard extends StatefulWidget {
  const WorkoutDashboard({Key? key}) : super(key: key);

  @override
  _WorkoutDashboardState createState() => _WorkoutDashboardState();
}

class _WorkoutDashboardState extends State<WorkoutDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Static data for calories balance
  final int dailyCaloriesGoal = 2000;
  final int consumedCalories = 1650;
  final int burnedCalories = 320;

  // Static training history data
  final List<TrainingSession> trainingHistory = [
    TrainingSession(
      type: 'Strength Training',
      duration: '45 min',
      date: 'Today',
      calories: 280,
      icon: Icons.fitness_center,
    ),
    TrainingSession(
      type: 'Cardio',
      duration: '30 min',
      date: 'Yesterday',
      calories: 320,
      icon: Icons.directions_run,
    ),
    TrainingSession(
      type: 'Yoga',
      duration: '60 min',
      date: '2 days ago',
      calories: 180,
      icon: Icons.self_improvement,
    ),
  ];

  // Exercise types for assistant
  final List<ExerciseType> exercises = [
    ExerciseType(name: 'Plank', icon: Icons.accessibility_new),
    ExerciseType(name: 'Squats', icon: Icons.fitness_center),
    ExerciseType(name: 'Push-ups', icon: Icons.sports_gymnastics),
    ExerciseType(name: 'Shoulder Tap', icon: Icons.back_hand),
    ExerciseType(name: 'Jumping Jacks', icon: Icons.directions_run),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
          'Workout Dashboard',
          style: TextStyle(
            color: AppTheme.textColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.primaryColor,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: AppTheme.subtextColor,
          tabs: const [
            Tab(
              icon: Icon(Icons.local_fire_department, size: 20),
              text: 'Calories',
            ),
            Tab(icon: Icon(Icons.history, size: 20), text: 'History'),
            Tab(icon: Icon(Icons.sports, size: 20), text: 'Assistant'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCaloriesTab(),
          _buildHistoryTab(),
          _buildAssistantTab(),
        ],
      ),
    );
  }

  Widget _buildCaloriesTab() {
    int netCalories = consumedCalories - burnedCalories;
    int remaining = dailyCaloriesGoal - netCalories;
    double progress = netCalories / dailyCaloriesGoal;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  'Daily Calories Goal',
                  style: TextStyle(
                    color: AppTheme.subtextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),

                // Progress circle
                SizedBox(
                  width: 160,
                  height: 160,
                  child: Stack(
                    children: [
                      CircularProgressIndicator(
                        value: progress.clamp(0.0, 1.0),
                        strokeWidth: 12,
                        backgroundColor: Colors.grey[700],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          remaining > 0
                              ? AppTheme.primaryColor
                              : Colors.red[400]!,
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              remaining > 0 ? remaining.toString() : '0',
                              style: TextStyle(
                                color: AppTheme.textColor,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'calories remaining',
                              style: TextStyle(
                                color: AppTheme.subtextColor,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Calories breakdown
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildCalorieItem(
                      'Goal',
                      dailyCaloriesGoal,
                      Colors.blue[300]!,
                    ),
                    _buildCalorieItem(
                      'Consumed',
                      consumedCalories,
                      Colors.orange[300]!,
                    ),
                    _buildCalorieItem(
                      'Burned',
                      burnedCalories,
                      Colors.green[300]!,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Workouts',
            style: TextStyle(
              color: AppTheme.textColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          ...trainingHistory.map((session) => _buildHistoryItem(session)),

          const SizedBox(height: 20),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Icon(Icons.insights, color: AppTheme.primaryColor, size: 48),
                const SizedBox(height: 16),
                Text(
                  'Weekly Summary',
                  style: TextStyle(
                    color: AppTheme.textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '3 workouts completed\n780 calories burned',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppTheme.subtextColor, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssistantTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Exercise Assistant',
            style: TextStyle(
              color: AppTheme.textColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select an exercise to start with camera assistance:',
            style: TextStyle(color: AppTheme.subtextColor, fontSize: 14),
          ),
          const SizedBox(height: 24),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
            ),
            itemCount: exercises.length,
            itemBuilder: (context, index) {
              return _buildExerciseCard(exercises[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCalorieItem(String label, int value, Color color) {
    return Column(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(height: 8),
        Text(
          value.toString(),
          style: TextStyle(
            color: AppTheme.textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: AppTheme.subtextColor, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildHistoryItem(TrainingSession session) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(session.icon, color: AppTheme.primaryColor, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.type,
                  style: TextStyle(
                    color: AppTheme.textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${session.duration} • ${session.calories} cal',
                  style: TextStyle(color: AppTheme.subtextColor, fontSize: 14),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                session.date,
                style: TextStyle(color: AppTheme.subtextColor, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Icon(Icons.chevron_right, color: AppTheme.subtextColor, size: 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseCard(ExerciseType exercise) {
    return GestureDetector(
      onTap: () => _openCameraForExercise(exercise.name),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.primaryColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(exercise.icon, color: AppTheme.primaryColor, size: 40),
            const SizedBox(height: 12),
            Text(
              exercise.name,
              style: TextStyle(
                color: AppTheme.textColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _openCameraForExercise(String exerciseName) {
    // Navigate to camera screen for the selected exercise
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraScreen(exerciseName: exerciseName),
      ),
    );
  }
}

// Data models
class TrainingSession {
  final String type;
  final String duration;
  final String date;
  final int calories;
  final IconData icon;

  TrainingSession({
    required this.type,
    required this.duration,
    required this.date,
    required this.calories,
    required this.icon,
  });
}

class ExerciseType {
  final String name;
  final IconData icon;

  ExerciseType({required this.name, required this.icon});
}
