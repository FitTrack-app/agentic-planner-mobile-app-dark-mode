import 'package:flutter/material.dart';

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

class _WorkoutDashboardState extends State<WorkoutDashboard> {
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCaloriesBalance(),
            const SizedBox(height: 24),
            _buildTrainingHistory(),
            const SizedBox(height: 24),
            _buildExerciseAssistant(),
          ],
        ),
      ),
    );
  }

  Widget _buildCaloriesBalance() {
    int netCalories = consumedCalories - burnedCalories;
    int remaining = dailyCaloriesGoal - netCalories;
    double progress = netCalories / dailyCaloriesGoal;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.local_fire_department,
                color: AppTheme.primaryColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Calories Balance',
                style: TextStyle(
                  color: AppTheme.textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Progress circle
          Center(
            child: SizedBox(
              width: 120,
              height: 120,
              child: Stack(
                children: [
                  CircularProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    strokeWidth: 8,
                    backgroundColor: Colors.grey[700],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      remaining > 0 ? AppTheme.primaryColor : Colors.red[400]!,
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
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'remaining',
                          style: TextStyle(
                            color: AppTheme.subtextColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Calories breakdown
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCalorieItem('Goal', dailyCaloriesGoal, Colors.blue[300]!),
              _buildCalorieItem(
                'Consumed',
                consumedCalories,
                Colors.orange[300]!,
              ),
              _buildCalorieItem('Burned', burnedCalories, Colors.green[300]!),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalorieItem(String label, int value, Color color) {
    return Column(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(height: 4),
        Text(
          value.toString(),
          style: TextStyle(
            color: AppTheme.textColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: AppTheme.subtextColor, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildTrainingHistory() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.history, color: AppTheme.primaryColor, size: 24),
              const SizedBox(width: 8),
              Text(
                'Training History',
                style: TextStyle(
                  color: AppTheme.textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          ...trainingHistory.map((session) => _buildHistoryItem(session)),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(TrainingSession session) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(session.icon, color: AppTheme.primaryColor, size: 24),
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
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${session.duration} • ${session.calories} cal',
                  style: TextStyle(color: AppTheme.subtextColor, fontSize: 14),
                ),
              ],
            ),
          ),
          Text(
            session.date,
            style: TextStyle(color: AppTheme.subtextColor, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseAssistant() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.sports, color: AppTheme.primaryColor, size: 24),
              const SizedBox(width: 8),
              Text(
                'Exercise Assistant',
                style: TextStyle(
                  color: AppTheme.textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Text(
            'Select an exercise to start with camera assistance:',
            style: TextStyle(color: AppTheme.subtextColor, fontSize: 14),
          ),

          const SizedBox(height: 16),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
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

  Widget _buildExerciseCard(ExerciseType exercise) {
    return GestureDetector(
      onTap: () => _openCameraForExercise(exercise.name),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.primaryColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(exercise.icon, color: AppTheme.primaryColor, size: 32),
            const SizedBox(height: 8),
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
    // This will open the camera for the selected exercise
    // For now, we'll show a placeholder dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.cardColor,
          title: Text(
            'Camera Assistant',
            style: TextStyle(color: AppTheme.textColor),
          ),
          content: Text(
            'Opening camera for $exerciseName exercise...\n\nThis will be connected to your computer vision Python code.',
            style: TextStyle(color: AppTheme.subtextColor),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK', style: TextStyle(color: AppTheme.primaryColor)),
            ),
          ],
        );
      },
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
