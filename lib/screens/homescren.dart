// home_screen.dart
import 'package:flutter/material.dart';

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
        height != null &&
        weight != null &&
        fitnessLevel != null &&
        goal != null;
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  UserProfile userProfile =
      UserProfile(); // This would typically come from storage

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
        return _buildHomeContent();
      case 1:
        return _buildSearchContent();
      case 2:
        return _buildAddContent();
      case 3:
        return _buildProfileContent();
      default:
        return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),

            // Logo
            Text(
              'FitTrack',
              style: TextStyle(
                color: AppTheme.textColor,
                fontSize: 48,
                fontWeight: FontWeight.bold,
                letterSpacing: -1,
              ),
            ),

            const SizedBox(height: 40),

            // Description
            Text(
              'Your journey to a\nhealthier you starts now.\nTrack your progress, set\ngoals, and achieve your\nfitness aspirations.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.subtextColor,
                fontSize: 18,
                height: 1.5,
                fontWeight: FontWeight.w400,
              ),
            ),

            const Spacer(flex: 2),

            // Color picker button
            GestureDetector(
              onTap: _showColorPicker,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.palette, color: Colors.white, size: 32),
              ),
            ),

            const SizedBox(height: 16),

            Text(
              'Tap to customize your theme',
              style: TextStyle(color: AppTheme.subtextColor, fontSize: 14),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchContent() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Text(
              'Search',
              style: TextStyle(
                color: AppTheme.textColor,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                style: TextStyle(color: AppTheme.textColor),
                decoration: InputDecoration(
                  hintText: 'Search workouts, exercises...',
                  hintStyle: TextStyle(color: AppTheme.subtextColor),
                  prefixIcon: Icon(Icons.search, color: AppTheme.subtextColor),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddContent() {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle_outline,
              size: 64,
              color: AppTheme.primaryColor,
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
          ],
        ),
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
    return Column(
      children: [
        _buildProfileItem('Age', userProfile.age ?? 'Not set'),
        _buildProfileItem(
          'Height',
          userProfile.height != null ? '${userProfile.height} cm' : 'Not set',
        ),
        _buildProfileItem(
          'Weight',
          userProfile.weight != null ? '${userProfile.weight} kg' : 'Not set',
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
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Search',
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
    final colors = [
      Colors.blue[600]!,
      Colors.red[600]!,
      Colors.green[600]!,
      Colors.purple[600]!,
      Colors.orange[600]!,
      Colors.teal[600]!,
      Colors.pink[600]!,
      Colors.indigo[600]!,
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.cardColor,
          title: Text(
            'Choose Theme Color',
            style: TextStyle(color: AppTheme.textColor),
          ),
          content: Wrap(
            spacing: 16,
            runSpacing: 16,
            children: colors.map((color) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    AppTheme.primaryColor = color;
                  });
                  Navigator.pop(context);
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: AppTheme.primaryColor == color
                        ? Border.all(color: Colors.white, width: 3)
                        : null,
                  ),
                ),
              );
            }).toList(),
          ),
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

// Updated ProfileSetupScreen to work with the new system
class ProfileSetupScreen extends StatefulWidget {
  final UserProfile? existingProfile;
  final Function(UserProfile) onProfileUpdated;

  const ProfileSetupScreen({
    super.key,
    this.existingProfile,
    required this.onProfileUpdated,
  });

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  late TextEditingController ageController;
  late TextEditingController heightController;
  late TextEditingController weightController;

  String selectedGender = '';
  String selectedFitnessLevel = '';
  String selectedGoal = '';
  bool hasEquipment = false;

  @override
  void initState() {
    super.initState();

    // Initialize with existing data if available
    final existing = widget.existingProfile;
    ageController = TextEditingController(text: existing?.age ?? '');
    heightController = TextEditingController(text: existing?.height ?? '');
    weightController = TextEditingController(text: existing?.weight ?? '');
    selectedGender = existing?.gender ?? '';
    selectedFitnessLevel = existing?.fitnessLevel ?? '';
    selectedGoal = existing?.goal ?? '';
    hasEquipment = existing?.hasEquipment ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
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
                color: AppTheme.subtextColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),

            // Age and Gender Row
            Row(
              children: [
                Expanded(child: _buildTextField('Age', ageController)),
                const SizedBox(width: 16),
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
            const SizedBox(height: 16),

            // Height and Weight Row
            Row(
              children: [
                Expanded(
                  child: _buildTextField('Height (cm)', heightController),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField('Weight (kg)', weightController),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Fitness Profile Section
            Text(
              'Fitness Profile',
              style: TextStyle(
                color: AppTheme.subtextColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),

            _buildDropdown(
              'Fitness Level',
              selectedFitnessLevel,
              ['Beginner', 'Intermediate', 'Advanced'],
              (value) => setState(() => selectedFitnessLevel = value!),
            ),
            const SizedBox(height: 32),

            // Goals Section
            Text(
              'Your Goals',
              style: TextStyle(
                color: AppTheme.subtextColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),

            _buildDropdown('Goals', selectedGoal, [
              'Weight Loss',
              'Muscle Gain',
              'Strength',
              'Endurance',
              'General Fitness',
            ], (value) => setState(() => selectedGoal = value!)),
            const SizedBox(height: 16),

            // Equipment Toggle
            _buildEquipmentToggle(),

            const Spacer(),

            // Continue Button
            Container(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _handleContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
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
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(color: AppTheme.textColor, fontSize: 16),
        keyboardType:
            label.contains('Age') ||
                label.contains('Height') ||
                label.contains('Weight')
            ? TextInputType.number
            : TextInputType.text,
        decoration: InputDecoration(
          hintText: label,
          hintStyle: TextStyle(color: AppTheme.subtextColor, fontSize: 16),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
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
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonFormField<String>(
        value: value.isEmpty ? null : value,
        style: TextStyle(color: AppTheme.textColor, fontSize: 16),
        dropdownColor: AppTheme.cardColor,
        decoration: InputDecoration(
          hintText: label,
          hintStyle: TextStyle(color: AppTheme.subtextColor, fontSize: 16),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        icon: Icon(Icons.keyboard_arrow_down, color: AppTheme.subtextColor),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item, style: TextStyle(color: AppTheme.textColor)),
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
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Equipment',
              style: TextStyle(color: AppTheme.textColor, fontSize: 16),
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

    widget.onProfileUpdated(updatedProfile);
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Profile updated successfully!'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
  }
}
