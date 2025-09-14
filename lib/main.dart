import 'package:flutter/material.dart';
import 'screens/workout_dashboard.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'screens/metrics_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/dashboard_home_screen.dart'; // Add this import

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitTrack',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        primarySwatch: Colors.blue,
      ),
      home: WelcomeScreen(),
    );
  }
}

// Color theme data class
class AppTheme {
  static Color primaryColor = Colors.blue[600]!;
  static Color backgroundColor = Colors.black;
  static Color cardColor = Colors.grey[800]!;
  static Color textColor = Colors.white;
  static Color subtextColor = Colors.grey[400]!;
}

// User profile data model
class UserProfile {
  String? age;
  String? gender;
  String? height;
  String? weight;
  String? fitnessLevel;
  String? goal;
  bool hasEquipment;

  UserProfile({
    this.age,
    this.gender,
    this.height,
    this.weight,
    this.fitnessLevel,
    this.goal,
    this.hasEquipment = false,
  });

  bool get isComplete {
    return age != null &&
        age!.isNotEmpty &&
        height != null &&
        height!.isNotEmpty &&
        weight != null &&
        weight!.isNotEmpty &&
        fitnessLevel != null &&
        fitnessLevel!.isNotEmpty &&
        goal != null &&
        goal!.isNotEmpty;
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  UserProfile userProfile = UserProfile();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: _buildCurrentPage(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildCurrentPage() {
    switch (_currentIndex) {
      case 0:
        return const DashboardHomeScreen(); // Changed to use the new dashboard
      case 1:
        return _buildSearchContent();
      case 2:
        return _buildAddContent();
      case 3:
        return _buildProfileContent();
      default:
        return const DashboardHomeScreen();
    }
  }

  Widget _buildSearchContent() {
    return MetricsScreen();
  }

  Widget _buildAddContent() {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WorkoutDashboard(),
                  ),
                );
              },
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add_circle_outline,
                  size: 64,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Add Workout',
              style: TextStyle(
                color: AppTheme.textColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap to open workout dashboard',
              style: TextStyle(color: AppTheme.subtextColor, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileContent() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile',
              style: TextStyle(
                color: AppTheme.textColor,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),

            if (!userProfile.isComplete)
              _buildSetupProfileCard()
            else
              _buildProfileSummary(),

            // Add theme customization section
            const SizedBox(height: 24),
            _buildThemeCustomization(),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeCustomization() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.palette, size: 24, color: AppTheme.primaryColor),
              const SizedBox(width: 12),
              Text(
                'Theme Customization',
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
            'Personalize your app experience with custom colors.',
            style: TextStyle(color: AppTheme.subtextColor, fontSize: 14),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              GestureDetector(
                onTap: _showColorPicker,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryColor.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.color_lens,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Primary Color',
                      style: TextStyle(
                        color: AppTheme.textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tap to change theme color',
                      style: TextStyle(
                        color: AppTheme.subtextColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: AppTheme.subtextColor,
                size: 16,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSetupProfileCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.person_outline, size: 48, color: AppTheme.primaryColor),
          const SizedBox(height: 16),
          Text(
            'Complete Your Profile',
            style: TextStyle(
              color: AppTheme.textColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tell us about yourself to get personalized workout recommendations.',
            style: TextStyle(color: AppTheme.subtextColor, fontSize: 14),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _navigateToProfileSetup(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Setup Profile'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSummary() {
    return Expanded(
      child: Column(
        children: [
          _buildProfileItem('Age', userProfile.age ?? 'Not set'),
          _buildProfileItem(
            'Height',
            userProfile.height != null && userProfile.height!.isNotEmpty
                ? '${userProfile.height} cm'
                : 'Not set',
          ),
          _buildProfileItem(
            'Weight',
            userProfile.weight != null && userProfile.weight!.isNotEmpty
                ? '${userProfile.weight} kg'
                : 'Not set',
          ),
          _buildProfileItem(
            'Fitness Level',
            userProfile.fitnessLevel ?? 'Not set',
          ),
          _buildProfileItem('Goal', userProfile.goal ?? 'Not set'),
          _buildProfileItem(
            'Equipment',
            userProfile.hasEquipment ? 'Available' : 'Not available',
          ),

          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: () => _navigateToProfileSetup(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Update Profile'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: AppTheme.textColor, fontSize: 16),
          ),
          Text(
            value,
            style: TextStyle(color: AppTheme.subtextColor, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: AppTheme.subtextColor,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart),
            label: 'Metrics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            activeIcon: Icon(Icons.add_circle),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void _showColorPicker() {
    Color pickerColor = AppTheme.primaryColor;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Choose Theme Color',
            style: TextStyle(
              color: AppTheme.textColor,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: (color) {
                setState(() {
                  pickerColor = color;
                });
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                "Cancel",
                style: TextStyle(color: AppTheme.subtextColor),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  AppTheme.primaryColor = pickerColor;
                });
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: pickerColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Apply",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _navigateToProfileSetup() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileSetupScreen(
          existingProfile: userProfile,
          onProfileUpdated: (updatedProfile) {
            setState(() {
              userProfile = updatedProfile;
            });
          },
        ),
      ),
    );
  }
}

// ProfileSetupScreen remains the same as in your original code
class ProfileSetupScreen extends StatefulWidget {
  final UserProfile? existingProfile;
  final Function(UserProfile)? onProfileUpdated;

  const ProfileSetupScreen({
    Key? key,
    this.existingProfile,
    this.onProfileUpdated,
  }) : super(key: key);

  @override
  _ProfileSetupScreenState createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final TextEditingController ageController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  String selectedGender = '';
  String selectedFitnessLevel = '';
  String selectedGoal = '';
  bool hasEquipment = false;

  @override
  void initState() {
    super.initState();

    final existing = widget.existingProfile;
    if (existing != null) {
      ageController.text = existing.age ?? '';
      heightController.text = existing.height ?? '';
      weightController.text = existing.weight ?? '';
      selectedGender = existing.gender ?? '';
      selectedFitnessLevel = existing.fitnessLevel ?? '';
      selectedGoal = existing.goal ?? '';
      hasEquipment = existing.hasEquipment;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'About You',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your details',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(child: _buildTextField('Age', ageController)),
                SizedBox(width: 16),
                Expanded(
                  child: _buildDropdown(
                    'Gender (Opt.)',
                    selectedGender,
                    ['Male', 'Female', 'Other', 'Prefer not to say'],
                    (value) => setState(() => selectedGender = value!),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildTextField('Height (cm)', heightController),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildTextField('Weight (kg)', weightController),
                ),
              ],
            ),
            SizedBox(height: 32),

            Text(
              'Fitness Profile',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 16),

            _buildDropdown(
              'Fitness Level',
              selectedFitnessLevel,
              ['Beginner', 'Intermediate', 'Advanced'],
              (value) => setState(() => selectedFitnessLevel = value!),
            ),
            SizedBox(height: 32),

            Text(
              'Your Goals',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 16),

            _buildDropdown('Goals', selectedGoal, [
              'Weight Loss',
              'Muscle Gain',
              'Strength',
              'Endurance',
              'General Fitness',
            ], (value) => setState(() => selectedGoal = value!)),
            SizedBox(height: 16),

            _buildEquipmentToggle(),

            Spacer(),

            Container(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  _handleContinue();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Continue',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(color: Colors.white, fontSize: 16),
        keyboardType:
            label.contains('Age') ||
                label.contains('Height') ||
                label.contains('Weight')
            ? TextInputType.number
            : TextInputType.text,
        decoration: InputDecoration(
          hintText: label,
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonFormField<String>(
        value: value.isEmpty ? null : value,
        style: TextStyle(color: Colors.white, fontSize: 16),
        dropdownColor: Colors.grey[800],
        decoration: InputDecoration(
          hintText: label,
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[500]),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item, style: TextStyle(color: Colors.white)),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildEquipmentToggle() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Equipment',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            Switch(
              value: hasEquipment,
              onChanged: (value) {
                setState(() {
                  hasEquipment = value;
                });
              },
              activeColor: AppTheme.primaryColor,
              activeTrackColor: AppTheme.primaryColor.withOpacity(0.3),
              inactiveThumbColor: Colors.grey[400],
              inactiveTrackColor: Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }

  void _handleContinue() {
    final updatedProfile = UserProfile(
      age: ageController.text.isNotEmpty ? ageController.text : null,
      gender: selectedGender.isNotEmpty ? selectedGender : null,
      height: heightController.text.isNotEmpty ? heightController.text : null,
      weight: weightController.text.isNotEmpty ? weightController.text : null,
      fitnessLevel: selectedFitnessLevel.isNotEmpty
          ? selectedFitnessLevel
          : null,
      goal: selectedGoal.isNotEmpty ? selectedGoal : null,
      hasEquipment: hasEquipment,
    );

    if (widget.onProfileUpdated != null) {
      widget.onProfileUpdated!(updatedProfile);
    }

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Profile setup complete!'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }
}
