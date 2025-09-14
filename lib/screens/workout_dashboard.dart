import 'package:flutter/material.dart';
import 'camera_screen.dart'; // Import the camera screen

// We'll access the AppTheme from the main context or pass it as a parameter
// For now, let's create a way to access the dynamic colors

class WorkoutDashboard extends StatefulWidget {
  final Color? primaryColor;
  final Color? backgroundColor;
  final Color? cardColor;
  final Color? textColor;
  final Color? subtextColor;
  final int initialTabIndex;

  const WorkoutDashboard({
    Key? key,
    this.primaryColor,
    this.backgroundColor,
    this.cardColor,
    this.textColor,
    this.subtextColor,
    this.initialTabIndex = 0,
  }) : super(key: key);

  @override
  _WorkoutDashboardState createState() => _WorkoutDashboardState();
}

class _WorkoutDashboardState extends State<WorkoutDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Color getters with fallbacks
  Color get primaryColor => widget.primaryColor ?? Colors.blue[600]!;
  Color get backgroundColor => widget.backgroundColor ?? Colors.black;
  Color get cardColor => widget.cardColor ?? Colors.grey[800]!;
  Color get textColor => widget.textColor ?? Colors.white;
  Color get subtextColor => widget.subtextColor ?? Colors.grey[400]!;

  // Static data for calories balance
  final int dailyCaloriesGoal = 2000;
  final int consumedCalories = 1650;
  final int burnedCalories = 320;

  // Static workout history data
  final List<WorkoutSession> workoutHistory = [
    WorkoutSession(
      name: 'Upper Body Strength',
      date: 'Yesterday',
      duration: '45 min',
      calories: 280,
      exercises: [
        Exercise('Push-ups', '3 sets x 12 reps', Icons.sports_gymnastics),
        Exercise('Shoulder Tap', '3 sets x 20 reps', Icons.back_hand),
        Exercise('Plank', '3 sets x 30 sec', Icons.accessibility_new),
      ],
      isCompleted: true,
    ),
    WorkoutSession(
      name: 'Cardio Blast',
      date: '2 days ago',
      duration: '30 min',
      calories: 320,
      exercises: [
        Exercise('Jumping Jacks', '4 sets x 30 sec', Icons.directions_run),
        Exercise('Squats', '3 sets x 15 reps', Icons.fitness_center),
      ],
      isCompleted: true,
    ),
    WorkoutSession(
      name: 'Yoga Flow',
      date: '3 days ago',
      duration: '60 min',
      calories: 180,
      exercises: [
        Exercise('Plank', '5 sets x 45 sec', Icons.accessibility_new),
      ],
      isCompleted: true,
    ),
  ];

  // Static upcoming workout data
  final List<WorkoutSession> upcomingWorkouts = [
    WorkoutSession(
      name: 'Full Body HIIT',
      date: 'Today',
      duration: '35 min',
      calories: 350,
      exercises: [
        Exercise('Squats', '4 sets x 20 reps', Icons.fitness_center),
        Exercise('Push-ups', '3 sets x 15 reps', Icons.sports_gymnastics),
        Exercise('Jumping Jacks', '5 sets x 30 sec', Icons.directions_run),
        Exercise('Plank', '3 sets x 60 sec', Icons.accessibility_new),
      ],
      isCompleted: false,
    ),
    WorkoutSession(
      name: 'Core & Flexibility',
      date: 'Tomorrow',
      duration: '40 min',
      calories: 200,
      exercises: [
        Exercise('Plank', '4 sets x 45 sec', Icons.accessibility_new),
        Exercise('Shoulder Tap', '3 sets x 24 reps', Icons.back_hand),
      ],
      isCompleted: false,
    ),
    WorkoutSession(
      name: 'Strength Training',
      date: 'Day after tomorrow',
      duration: '50 min',
      calories: 400,
      exercises: [
        Exercise('Squats', '4 sets x 18 reps', Icons.fitness_center),
        Exercise('Push-ups', '4 sets x 12 reps', Icons.sports_gymnastics),
      ],
      isCompleted: false,
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
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Workout Dashboard',
          style: TextStyle(
            color: textColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: primaryColor,
          labelColor: primaryColor,
          unselectedLabelColor: subtextColor,
          tabs: const [
            Tab(
              icon: Icon(Icons.local_fire_department, size: 20),
              text: 'Calories',
            ),
            Tab(icon: Icon(Icons.calendar_today, size: 20), text: 'Sessions'),
            Tab(icon: Icon(Icons.sports, size: 20), text: 'Assistant'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCaloriesTab(),
          _buildSessionsTab(),
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
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  'Daily Calories Goal',
                  style: TextStyle(
                    color: subtextColor,
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
                          remaining > 0 ? primaryColor : Colors.red[400]!,
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              remaining > 0 ? remaining.toString() : '0',
                              style: TextStyle(
                                color: textColor,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'calories remaining',
                              style: TextStyle(
                                color: subtextColor,
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

  Widget _buildSessionsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Upcoming Workouts Section
          Row(
            children: [
              Icon(Icons.schedule, color: primaryColor, size: 24),
              const SizedBox(width: 8),
              Text(
                'Upcoming Workouts',
                style: TextStyle(
                  color: textColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          ...upcomingWorkouts.map(
            (session) => _buildSessionCard(session, true),
          ),

          const SizedBox(height: 32),

          // Workout History Section
          Row(
            children: [
              Icon(Icons.history, color: primaryColor, size: 24),
              const SizedBox(width: 8),
              Text(
                'Workout History',
                style: TextStyle(
                  color: textColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          ...workoutHistory.map((session) => _buildSessionCard(session, false)),

          const SizedBox(height: 20),

          // Weekly Summary Card (from first version)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Icon(Icons.insights, color: primaryColor, size: 48),
                const SizedBox(height: 16),
                Text(
                  'Weekly Summary',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '3 workouts completed\n780 calories burned',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: subtextColor, fontSize: 14),
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
              color: textColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select an exercise to start with camera assistance:',
            style: TextStyle(color: subtextColor, fontSize: 14),
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

  Widget _buildSessionCard(WorkoutSession session, bool isUpcoming) {
    return GestureDetector(
      onTap: () => _openWorkoutDetail(session),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: isUpcoming && !session.isCompleted
              ? Border.all(color: primaryColor.withOpacity(0.5), width: 1)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: session.isCompleted
                        ? Colors.green.withOpacity(0.2)
                        : primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    session.isCompleted ? Icons.check_circle : Icons.schedule,
                    color: session.isCompleted ? Colors.green : primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        session.name,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${session.duration} • ${session.calories} cal • ${session.date}',
                        style: TextStyle(color: subtextColor, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: subtextColor, size: 20),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '${session.exercises.length} exercises',
              style: TextStyle(color: subtextColor, fontSize: 12),
            ),
          ],
        ),
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
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label, style: TextStyle(color: subtextColor, fontSize: 12)),
      ],
    );
  }

  Widget _buildExerciseCard(ExerciseType exercise) {
    return GestureDetector(
      onTap: () => _openCameraForExercise(exercise.name),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: primaryColor.withOpacity(0.3), width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(exercise.icon, color: primaryColor, size: 40),
            const SizedBox(height: 12),
            Text(
              exercise.name,
              style: TextStyle(
                color: textColor,
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

  void _openWorkoutDetail(WorkoutSession session) {
    showModalBottomSheet(
      context: context,
      backgroundColor: backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildWorkoutDetailSheet(session),
    );
  }

  Widget _buildWorkoutDetailSheet(WorkoutSession session) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: session.isCompleted
                      ? Colors.green.withOpacity(0.2)
                      : primaryColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  session.isCompleted ? Icons.check_circle : Icons.schedule,
                  color: session.isCompleted ? Colors.green : primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.name,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${session.duration} • ${session.calories} cal • ${session.date}',
                      style: TextStyle(color: subtextColor, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Exercises',
            style: TextStyle(
              color: textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...session.exercises.map((exercise) => _buildExerciseItem(exercise)),
          const SizedBox(height: 20),
          if (!session.isCompleted)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Starting ${session.name}...'),
                      backgroundColor: primaryColor,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Start Workout',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildExerciseItem(Exercise exercise) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context); // Close the bottom sheet first
        _openCameraForExercise(exercise.name);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(exercise.icon, color: primaryColor, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.name,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    exercise.details,
                    style: TextStyle(color: subtextColor, fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(Icons.camera_alt, color: subtextColor, size: 20),
          ],
        ),
      ),
    );
  }
}

// Data models
class WorkoutSession {
  final String name;
  final String date;
  final String duration;
  final int calories;
  final List<Exercise> exercises;
  final bool isCompleted;

  WorkoutSession({
    required this.name,
    required this.date,
    required this.duration,
    required this.calories,
    required this.exercises,
    required this.isCompleted,
  });
}

class Exercise {
  final String name;
  final String details;
  final IconData icon;

  Exercise(this.name, this.details, this.icon);
}

class ExerciseType {
  final String name;
  final IconData icon;

  ExerciseType({required this.name, required this.icon});
}
