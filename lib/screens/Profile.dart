import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Setup',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        primarySwatch: Colors.blue,
      ),
      home: ProfileSetupScreen(),
    );
  }
}

class ProfileSetupScreen extends StatefulWidget {
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
        padding: EdgeInsets.all(20),
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
            SizedBox(height: 16),

            // Age and Gender Row
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

            // Height and Weight Row
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

            // Fitness Profile Section
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

            // Goals Section
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

            // Equipment Toggle
            _buildEquipmentToggle(),

            Spacer(),

            // Continue Button
            Container(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // Handle continue action
                  _handleContinue();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
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
              activeColor: Colors.blue[600],
              activeTrackColor: Colors.blue[600]!.withOpacity(0.3),
              inactiveThumbColor: Colors.grey[400],
              inactiveTrackColor: Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }

  void _handleContinue() {
    // Collect all the data
    Map<String, dynamic> profileData = {
      'age': ageController.text,
      'gender': selectedGender,
      'height': heightController.text,
      'weight': weightController.text,
      'fitnessLevel': selectedFitnessLevel,
      'goal': selectedGoal,
      'hasEquipment': hasEquipment,
    };

    // Print or handle the data as needed
    print('Profile Data: $profileData');

    // Navigate to next screen or show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Profile setup complete!'),
        backgroundColor: Colors.blue[600],
      ),
    );
  }
}
