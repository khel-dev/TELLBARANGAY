import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import 'login_page.dart';
import '../services/auth_service.dart';

class RegistrationSelectionPage extends StatefulWidget {
  const RegistrationSelectionPage({Key? key}) : super(key: key);

  @override
  State<RegistrationSelectionPage> createState() =>
      _RegistrationSelectionPageState();
}

class _RegistrationSelectionPageState extends State<RegistrationSelectionPage> {
  int selectedType = 0; // 0: Citizen, 1: Official

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.paleOrange,
                  AppColors.primaryOrange,
                ],
              ),
            ),
          ),

          Positioned(
            bottom: -100,
            left: -60,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.darkOrange.withOpacity(0.5),
              ),
            ),
          ),

          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 24),

                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TellBarangay',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Create your account to register and track barangay concerns.',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                // Tab selector
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedType = 0;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: selectedType == 0
                                    ? AppColors.white
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  'Citizen',
                                  style: TextStyle(
                                    color: selectedType == 0
                                        ? AppColors.primaryOrange
                                        : AppColors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedType = 1;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: selectedType == 1
                                    ? AppColors.white
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  'Barangay Official',
                                  style: TextStyle(
                                    color: selectedType == 1
                                        ? AppColors.primaryOrange
                                        : AppColors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 24),

                // Content based on selection
                if (selectedType == 0)
                  CitizenRegistrationForm()
                else
                  OfficialRegistrationForm(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CitizenRegistrationForm extends StatefulWidget {
  const CitizenRegistrationForm({Key? key}) : super(key: key);

  @override
  State<CitizenRegistrationForm> createState() => _CitizenRegistrationFormState();
}

class _CitizenRegistrationFormState extends State<CitizenRegistrationForm> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  String age = '';
  String contact = '';
  String address = '';
  String selectedBarangay = 'Select your barangay';
  bool agreeTerms = false;
  String? uploadedFileName;

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Citizen Registration',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 20),

          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Full Name
                Text(
                  'Full Name',
                  style: TextStyle(
                    color: AppColors.primaryOrange,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                TextField(
                  controller: fullNameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.lightGrey,
                    prefixIcon: Icon(Icons.person, color: AppColors.primaryOrange),
                    hintText: 'Juan Dela Cruz',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Email
                Text(
                  'Email',
                  style: TextStyle(
                    color: AppColors.primaryOrange,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.lightGrey,
                    prefixIcon: Icon(Icons.email, color: AppColors.primaryOrange),
                    hintText: 'you@example.com',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Username
                Text(
                  'Create a Username',
                  style: TextStyle(
                    color: AppColors.primaryOrange,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.lightGrey,
                    prefixIcon: Icon(Icons.account_circle, color: AppColors.primaryOrange),
                    hintText: 'choose a username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Password
                Text(
                  'Password',
                  style: TextStyle(
                    color: AppColors.primaryOrange,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.lightGrey,
                    prefixIcon: Icon(Icons.lock, color: AppColors.primaryOrange),
                    hintText: 'Create a password (min 6 chars)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Confirm Password
                TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.lightGrey,
                    prefixIcon: Icon(Icons.lock_outline, color: AppColors.primaryOrange),
                    hintText: 'Confirm password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                  ),
                ),

                SizedBox(height: 16),

                // Age and Contact
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Age',
                            style: TextStyle(
                              color: AppColors.primaryOrange,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8),
                          TextField(
                            onChanged: (value) => age = value,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.lightGrey,
                              prefixIcon: Icon(Icons.calendar_today,
                                  color: AppColors.primaryOrange),
                              hintText: 'Enter age',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Contact Number',
                            style: TextStyle(
                              color: AppColors.primaryOrange,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8),
                          TextField(
                            onChanged: (value) => contact = value,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.lightGrey,
                              prefixIcon: Icon(Icons.phone,
                                  color: AppColors.primaryOrange),
                              hintText: '09XX XXX XXXX',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16),

                // Address
                Text(
                  'Address',
                  style: TextStyle(
                    color: AppColors.primaryOrange,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: 8),

                TextField(
                  onChanged: (value) => address = value,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.lightGrey,
                    prefixIcon: Icon(Icons.location_on,
                        color: AppColors.primaryOrange),
                    hintText: 'House No., Street, Purok, Barangay, City',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                  ),
                ),

                SizedBox(height: 16),

                // Barangay Dropdown
                Text(
                  'Barangay',
                  style: TextStyle(
                    color: AppColors.primaryOrange,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: 8),

                Container(
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButton<String>(
                    value: selectedBarangay,
                    isExpanded: true,
                    underline: SizedBox(),
                    onChanged: (value) {
                      setState(() {
                        selectedBarangay = value ?? 'Select your barangay';
                      });
                    },
                    items: [
                      'Select your barangay',
                      'Barangay 1',
                      'Barangay 2',
                      'Barangay 3',
                    ]
                        .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 14),
                              child: Text(value),
                            ),
                          );
                        })
                        .toList(),
                  ),
                ),

                SizedBox(height: 8),

                Text(
                  'We use this to route your reports to the correct barangay office.',
                  style: TextStyle(
                    color: AppColors.primaryOrange.withOpacity(0.7),
                    fontSize: 11,
                  ),
                ),

                SizedBox(height: 16),

                // File upload
                Text(
                  'Upload Proof of Residency',
                  style: TextStyle(
                    color: AppColors.primaryOrange,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: 8),

                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.primaryOrange,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.lightGrey,
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Icon(Icons.file_upload,
                          color: AppColors.primaryOrange, size: 32),
                      SizedBox(height: 8),
                      Text(
                        'ID, Barangay Card, or Bill of Lading',
                        style: TextStyle(
                          color: AppColors.primaryOrange,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  uploadedFileName = 'barangay_id_front.jpg';
                                });
                              },
                              icon: Icon(Icons.folder_open, size: 18),
                              label: Text('Browse files', style: TextStyle(fontSize: 12)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.brightBlue,
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  uploadedFileName = 'photo_from_camera.jpg';
                                });
                              },
                              icon: Icon(Icons.camera_alt, size: 18),
                              label: Text('Open camera', style: TextStyle(fontSize: 12)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.brightGreen,
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (uploadedFileName != null) ...[
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.insert_drive_file,
                                color: AppColors.primaryOrange),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                uploadedFileName!,
                                style: TextStyle(
                                  color: AppColors.primaryOrange,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Text(
                              'Uploaded',
                              style: TextStyle(
                                color: AppColors.brightGreen,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                SizedBox(height: 16),

                // Terms checkbox
                Row(
                  children: [
                    Checkbox(
                      value: agreeTerms,
                      onChanged: (value) {
                        setState(() {
                          agreeTerms = value ?? false;
                        });
                      },
                      activeColor: AppColors.primaryOrange,
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: AppColors.primaryOrange,
                            fontSize: 12,
                          ),
                          children: [
                            TextSpan(text: 'I agree to the '),
                            TextSpan(
                              text: 'Terms of Service',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),

                // Register button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                      final fullName = fullNameController.text.trim();
                      final email = emailController.text.trim();
                      final username = usernameController.text.trim();
                      final password = passwordController.text;
                      final confirm = confirmPasswordController.text;

                      if (!agreeTerms) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please agree to terms'), backgroundColor: AppColors.accentRed),
                        );
                        return;
                      }
                      if (fullName.isEmpty || email.isEmpty || username.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please fill required fields'), backgroundColor: AppColors.accentRed),
                        );
                        return;
                      }
                      if (password.length < 6) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Password must be at least 6 characters'), backgroundColor: AppColors.accentRed),
                        );
                        return;
                      }
                      if (password != confirm) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Passwords do not match'), backgroundColor: AppColors.accentRed),
                        );
                        return;
                      }

                      final errorMessage = await AuthService.instance.register(
                        email,
                        username,
                        password,
                        fullName,
                        role: 'citizen',
                        address: address,
                        contact: contact,
                        barangay: selectedBarangay != 'Select your barangay' ? selectedBarangay : null,
                        age: age,
                      );
                      if (!mounted) return;
                      if (errorMessage == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Registration successful — please login'), backgroundColor: AppColors.brightGreen),
                        );
                        Navigator.pushReplacementNamed(context, '/login');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(errorMessage), backgroundColor: AppColors.accentRed),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B4513),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Register as Citizen',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 12),

                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: Text(
                      'Already have an account? Login',
                      style: TextStyle(
                        color: AppColors.primaryOrange,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OfficialRegistrationForm extends StatefulWidget {
  const OfficialRegistrationForm({Key? key}) : super(key: key);

  @override
  State<OfficialRegistrationForm> createState() =>
      _OfficialRegistrationFormState();
}

class _OfficialRegistrationFormState extends State<OfficialRegistrationForm> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  String position = '';
  String contact = '';
  String selectedBarangay = 'Select barangay office';
  bool agreeTerms = false;
  String? uploadedFileName;

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Official Registration',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 20),

          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Full Name
                Text(
                  'Full Name',
                  style: TextStyle(
                    color: AppColors.primaryOrange,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                TextField(
                  controller: fullNameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.lightGrey,
                    prefixIcon: Icon(Icons.person, color: AppColors.primaryOrange),
                    hintText: 'Kap. Juan Dela Cruz',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Email
                Text(
                  'Email',
                  style: TextStyle(
                    color: AppColors.primaryOrange,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.lightGrey,
                    prefixIcon: Icon(Icons.email, color: AppColors.primaryOrange),
                    hintText: 'you@office.gov',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Username
                Text(
                  'Create a Username',
                  style: TextStyle(
                    color: AppColors.primaryOrange,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.lightGrey,
                    prefixIcon: Icon(Icons.account_circle, color: AppColors.primaryOrange),
                    hintText: 'choose a username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Password
                Text(
                  'Password',
                  style: TextStyle(
                    color: AppColors.primaryOrange,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.lightGrey,
                    prefixIcon: Icon(Icons.lock, color: AppColors.primaryOrange),
                    hintText: 'Create a password (min 6 chars)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Confirm Password
                TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.lightGrey,
                    prefixIcon: Icon(Icons.lock_outline, color: AppColors.primaryOrange),
                    hintText: 'Confirm password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                  ),
                ),

                SizedBox(height: 16),

                // Position
                Text(
                  'Position',
                  style: TextStyle(
                    color: AppColors.primaryOrange,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: 8),

                TextField(
                  onChanged: (value) => position = value,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.lightGrey,
                    prefixIcon:
                        Icon(Icons.badge, color: AppColors.primaryOrange),
                    hintText: 'Barangay Captain, Secretary, etc.',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                  ),
                ),

                SizedBox(height: 16),

                // Contact Number
                Text(
                  'Contact Number',
                  style: TextStyle(
                    color: AppColors.primaryOrange,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: 8),

                TextField(
                  onChanged: (value) => contact = value,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.lightGrey,
                    prefixIcon:
                        Icon(Icons.phone, color: AppColors.primaryOrange),
                    hintText: '09XX XXX XXXX',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                  ),
                ),

                SizedBox(height: 16),

                // Barangay Office Dropdown
                Text(
                  'Barangay Office',
                  style: TextStyle(
                    color: AppColors.primaryOrange,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: 8),

                Container(
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButton<String>(
                    value: selectedBarangay,
                    isExpanded: true,
                    underline: SizedBox(),
                    onChanged: (value) {
                      setState(() {
                        selectedBarangay = value ?? 'Select barangay office';
                      });
                    },
                    items: [
                      'Select barangay office',
                      'Barangay 1 Office',
                      'Barangay 2 Office',
                      'Barangay 3 Office',
                    ]
                        .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 14),
                              child: Text(value),
                            ),
                          );
                        })
                        .toList(),
                  ),
                ),

                SizedBox(height: 8),

                Text(
                  'Only registered officials can approve official accounts.',
                  style: TextStyle(
                    color: AppColors.primaryOrange.withOpacity(0.7),
                    fontSize: 11,
                  ),
                ),

                SizedBox(height: 16),

                // File upload - Official ID
                Text(
                  'Upload Official ID / Appointment Paper',
                  style: TextStyle(
                    color: AppColors.primaryOrange,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: 8),

                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.primaryOrange,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.lightGrey,
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Icon(Icons.file_upload,
                          color: AppColors.primaryOrange, size: 32),
                      SizedBox(height: 8),
                      Text(
                        'Upload official document',
                        style: TextStyle(
                          color: AppColors.primaryOrange,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Attach your government-issued ID or appointment paper for verification.',
                        style: TextStyle(
                          color: AppColors.primaryOrange.withOpacity(0.7),
                          fontSize: 11,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  uploadedFileName = 'official_id.pdf';
                                });
                              },
                              icon: Icon(Icons.folder_open, size: 18),
                              label: Text('Browse files', style: TextStyle(fontSize: 12)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.brightBlue,
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  uploadedFileName = 'appointment_photo.jpg';
                                });
                              },
                              icon: Icon(Icons.camera_alt, size: 18),
                              label: Text('Open camera', style: TextStyle(fontSize: 12)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.brightGreen,
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (uploadedFileName != null) ...[
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.insert_drive_file,
                                color: AppColors.primaryOrange),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                uploadedFileName!,
                                style: TextStyle(
                                  color: AppColors.primaryOrange,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Text(
                              'Uploaded',
                              style: TextStyle(
                                color: AppColors.brightGreen,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                SizedBox(height: 16),

                // Verified Badge
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.primaryOrange,
                      width: 1,
                    ),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(Icons.verified_user, color: AppColors.primaryOrange),
                      SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Verified Badge Preview',
                              style: TextStyle(
                                color: AppColors.primaryOrange,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              'This badge appears on your profile once approved.',
                              style: TextStyle(
                                color: AppColors.primaryOrange.withOpacity(0.7),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16),

                // Terms checkbox
                Row(
                  children: [
                    Checkbox(
                      value: agreeTerms,
                      onChanged: (value) {
                        setState(() {
                          agreeTerms = value ?? false;
                        });
                      },
                      activeColor: AppColors.primaryOrange,
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: AppColors.primaryOrange,
                            fontSize: 12,
                          ),
                          children: [
                            TextSpan(text: 'I agree to the '),
                            TextSpan(
                              text: 'Terms of Service',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),

                // Register button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                      final fullName = fullNameController.text.trim();
                      final email = emailController.text.trim();
                      final username = usernameController.text.trim();
                      final password = passwordController.text;
                      final confirm = confirmPasswordController.text;

                      if (!agreeTerms) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please agree to terms'), backgroundColor: AppColors.accentRed),
                        );
                        return;
                      }
                      if (fullName.isEmpty || email.isEmpty || username.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please fill required fields'), backgroundColor: AppColors.accentRed),
                        );
                        return;
                      }
                      if (password.length < 6) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Password must be at least 6 characters'), backgroundColor: AppColors.accentRed),
                        );
                        return;
                      }
                      if (password != confirm) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Passwords do not match'), backgroundColor: AppColors.accentRed),
                        );
                        return;
                      }

                      final errorMessage = await AuthService.instance.register(
                        email,
                        username,
                        password,
                        fullName,
                        role: 'official',
                        contact: contact,
                        barangay: selectedBarangay != 'Select barangay office' ? selectedBarangay : null,
                        position: position,
                      );
                      if (!mounted) return;
                      if (errorMessage == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Registration successful — please login'), backgroundColor: AppColors.brightGreen),
                        );
                        Navigator.pushReplacementNamed(context, '/login');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(errorMessage), backgroundColor: AppColors.accentRed),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B4513),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Register as Official',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 12),

                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: Text(
                      'Already verified? Login',
                      style: TextStyle(
                        color: AppColors.primaryOrange,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
