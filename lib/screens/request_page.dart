import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../config/app_colors.dart';
import '../services/database.dart';
import '../services/auth_service.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({Key? key}) : super(key: key);

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  String? selectedRequest;

  @override
  Widget build(BuildContext context) {
    if (selectedRequest != null) {
      return _buildRequestForm(selectedRequest!);
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryOrange,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: AppColors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        'Submit a Request',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Choose type',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Request type',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.85,
                        children: [
                          _RequestTypeCard(
                            title: 'Barangay Clearance',
                            description: 'For employment, travel, etc.',
                            icon: Icons.description,
                            iconColor: Colors.lightBlue,
                            onTap: () => setState(() => selectedRequest = 'Barangay Clearance'),
                          ),
                          _RequestTypeCard(
                            title: 'Certification',
                            description: 'Residency, indigency and more.',
                            icon: Icons.verified,
                            iconColor: Colors.lightGreen,
                            onTap: () => setState(() => selectedRequest = 'Certification'),
                          ),
                          _RequestTypeCard(
                            title: 'Barangay ID',
                            description: 'Local identification card.',
                            icon: Icons.badge,
                            iconColor: Colors.purple,
                            onTap: () => setState(() => selectedRequest = 'Barangay ID'),
                          ),
                          _RequestTypeCard(
                            title: 'Permit',
                            description: 'Business, events & others.',
                            icon: Icons.assignment_turned_in,
                            iconColor: Colors.orange,
                            onTap: () => setState(() => selectedRequest = 'Permit Request'),
                          ),
                          _RequestTypeCard(
                            title: 'Assistance',
                            description: 'Medical, financial, calamity.',
                            icon: Icons.medical_services,
                            iconColor: Colors.red,
                            onTap: () => setState(() => selectedRequest = 'Request for Assistance'),
                          ),
                          _RequestTypeCard(
                            title: 'Others',
                            description: 'Not listed above.',
                            icon: Icons.more_horiz,
                            iconColor: Colors.grey,
                            onTap: () => setState(() => selectedRequest = 'Other Request'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRequestForm(String requestType) {
    switch (requestType) {
      case 'Barangay Clearance':
        return BarangayClearanceForm(onBack: () => setState(() => selectedRequest = null));
      case 'Certification':
        return CertificationForm(onBack: () => setState(() => selectedRequest = null));
      case 'Barangay ID':
        return BarangayIDForm(onBack: () => setState(() => selectedRequest = null));
      case 'Permit Request':
        return PermitRequestForm(onBack: () => setState(() => selectedRequest = null));
      case 'Request for Assistance':
        return AssistanceRequestForm(onBack: () => setState(() => selectedRequest = null));
      case 'Other Request':
        return OtherRequestForm(onBack: () => setState(() => selectedRequest = null));
      default:
        return Container();
    }
  }
}

class _RequestTypeCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const _RequestTypeCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 32),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// Form: Barangay Clearance
class BarangayClearanceForm extends StatefulWidget {
  final VoidCallback onBack;
  const BarangayClearanceForm({required this.onBack});

  @override
  State<BarangayClearanceForm> createState() => _BarangayClearanceFormState();
}

class _BarangayClearanceFormState extends State<BarangayClearanceForm> {
  final fullNameController = TextEditingController();
  final purposeController = TextEditingController();
  File? uploadedFile;
  final ImagePicker _imagePicker = ImagePicker();
  bool isSubmitting = false;

  @override
  void dispose() {
    fullNameController.dispose();
    purposeController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          uploadedFile = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: $e'), backgroundColor: AppColors.accentRed),
      );
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          uploadedFile = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error taking photo: $e'), backgroundColor: AppColors.accentRed),
      );
    }
  }

  Future<void> _submit() async {
    if (fullNameController.text.isEmpty || purposeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Please fill all required fields'), backgroundColor: AppColors.accentRed),
      );
      return;
    }

    final currentUid = AuthService.instance.currentUid;
    if (currentUid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Please login first'), backgroundColor: AppColors.accentRed),
      );
      return;
    }

    setState(() => isSubmitting = true);

    try {
      final db = DatabaseService.instance;
      
      // Create request first to get requestId
      final requestId = await db.createRequest(
        type: 'Barangay Clearance',
        purpose: purposeController.text,
        fullName: fullNameController.text,
        proofUrl: '', // Will update after upload
        createdBy: currentUid,
      );

      // Upload proof image if any
      if (uploadedFile != null) {
        try {
          final proofUrl = await db.uploadProofImage(
            imageFile: uploadedFile!,
            requestId: requestId,
          );
          
          // Update request with proof URL
          await FirebaseFirestore.instance.collection('requests').doc(requestId).update({
            'proofUrl': proofUrl,
          });
        } catch (e) {
          // If upload fails, still keep the request but without proof
          print('Warning: Failed to upload proof image: $e');
        }
      }
    
      if (mounted) {
        setState(() => isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Request submitted successfully!'), backgroundColor: AppColors.brightGreen),
        );
        
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            widget.onBack();
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting request: $e'), backgroundColor: AppColors.accentRed),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryOrange,
        title: const Text('Barangay Clearance'),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: widget.onBack),
      ),
      body: Container(
        color: AppColors.paleOrange,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Complete the details below', style: TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Full Name'),
                      _buildTextField(fullNameController, 'Juan Dela Cruz', Icons.person),
                      const SizedBox(height: 16),
                      _buildLabel('Purpose of Request'),
                      _buildTextField(purposeController, 'For employment application', Icons.description, maxLines: 3),
                      const SizedBox(height: 16),
                      _buildLabel('Upload supporting document'),
                      Row(
                        children: [
                          Expanded(
                            child: _buildFileUpload(_pickFile, 'Gallery'),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildFileUpload(_takePhoto, 'Camera'),
                          ),
                        ],
                      ),
                      if (uploadedFile != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.brightGreen.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.check_circle, color: AppColors.brightGreen, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'File selected: ${uploadedFile!.path.split('/').last}',
                                  style: TextStyle(color: AppColors.primaryOrange, fontSize: 12),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => setState(() => uploadedFile = null),
                                child: Icon(Icons.close, color: AppColors.accentRed, size: 20),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: isSubmitting ? null : _submit,
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B4513)),
                          child: isSubmitting
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                                  ),
                                )
                              : const Text('Submit Request', style: TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Form: Certification
class CertificationForm extends StatefulWidget {
  final VoidCallback onBack;
  const CertificationForm({required this.onBack});

  @override
  State<CertificationForm> createState() => _CertificationFormState();
}

class _CertificationFormState extends State<CertificationForm> {
  final fullNameController = TextEditingController();
  final purposeController = TextEditingController();
  String certificationType = 'Residency';
  File? uploadedFile;
  final ImagePicker _imagePicker = ImagePicker();
  bool isSubmitting = false;

  @override
  void dispose() {
    fullNameController.dispose();
    purposeController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    try {
      final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery, imageQuality: 85);
      if (image != null) setState(() => uploadedFile = File(image.path));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: $e'), backgroundColor: AppColors.accentRed),
      );
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? image = await _imagePicker.pickImage(source: ImageSource.camera, imageQuality: 85);
      if (image != null) setState(() => uploadedFile = File(image.path));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error taking photo: $e'), backgroundColor: AppColors.accentRed),
      );
    }
  }

  Future<void> _submit() async {
    if (fullNameController.text.isEmpty || purposeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Please fill all required fields'), backgroundColor: AppColors.accentRed),
      );
      return;
    }

    final currentUid = AuthService.instance.currentUid;
    if (currentUid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Please login first'), backgroundColor: AppColors.accentRed),
      );
      return;
    }

    setState(() => isSubmitting = true);

    try {
      final db = DatabaseService.instance;
      final requestId = await db.createRequest(
        type: 'Certification - $certificationType',
        purpose: purposeController.text,
        fullName: fullNameController.text,
        proofUrl: '',
        createdBy: currentUid,
      );

      String proofUrl = '';
      if (uploadedFile != null) {
        proofUrl = await db.uploadProofImage(imageFile: uploadedFile!, requestId: requestId);
        await FirebaseFirestore.instance.collection('requests').doc(requestId).update({'proofUrl': proofUrl});
      }
    
      if (mounted) {
        setState(() => isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Request submitted successfully!'), backgroundColor: AppColors.brightGreen),
        );
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) widget.onBack();
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting request: $e'), backgroundColor: AppColors.accentRed),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryOrange,
        title: const Text('Certification'),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: widget.onBack),
      ),
      body: Container(
        color: AppColors.paleOrange,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Complete the details below', style: TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Full Name'),
                      _buildTextField(fullNameController, 'Juan Dela Cruz', Icons.person),
                      const SizedBox(height: 16),
                      _buildLabel('Type of Certification'),
                      _buildDropdown(
                        value: certificationType,
                        items: ['Residency', 'Good Moral', 'Solo Parent', 'Others'],
                        onChanged: (val) => setState(() => certificationType = val),
                      ),
                      const SizedBox(height: 16),
                      _buildLabel('Purpose of Request'),
                      _buildTextField(purposeController, 'Describe the purpose', Icons.description, maxLines: 3),
                      const SizedBox(height: 16),
                      _buildLabel('Upload supporting document'),
                      Row(
                        children: [
                          Expanded(child: _buildFileUpload(_pickFile, 'Gallery')),
                          const SizedBox(width: 12),
                          Expanded(child: _buildFileUpload(_takePhoto, 'Camera')),
                        ],
                      ),
                      if (uploadedFile != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: AppColors.brightGreen.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            children: [
                              Icon(Icons.check_circle, color: AppColors.brightGreen, size: 20),
                              const SizedBox(width: 8),
                              Expanded(child: Text('File selected: ${uploadedFile!.path.split('/').last}', style: TextStyle(color: AppColors.primaryOrange, fontSize: 12))),
                              GestureDetector(onTap: () => setState(() => uploadedFile = null), child: Icon(Icons.close, color: AppColors.accentRed, size: 20)),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: isSubmitting ? null : _submit,
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B4513)),
                          child: isSubmitting
                              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(AppColors.white)))
                              : const Text('Submit Request', style: TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Form: Barangay ID
class BarangayIDForm extends StatefulWidget {
  final VoidCallback onBack;
  const BarangayIDForm({required this.onBack});

  @override
  State<BarangayIDForm> createState() => _BarangayIDFormState();
}

class _BarangayIDFormState extends State<BarangayIDForm> {
  final fullNameController = TextEditingController();
  final addressController = TextEditingController();
  final contactController = TextEditingController();
  String? dob;
  File? uploadedPhoto;
  File? uploadedDoc;
  final ImagePicker _imagePicker = ImagePicker();
  bool isSubmitting = false;

  @override
  void dispose() {
    fullNameController.dispose();
    addressController.dispose();
    contactController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    try {
      final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery, imageQuality: 85);
      if (image != null) setState(() => uploadedPhoto = File(image.path));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking photo: $e'), backgroundColor: AppColors.accentRed),
      );
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? image = await _imagePicker.pickImage(source: ImageSource.camera, imageQuality: 85);
      if (image != null) setState(() => uploadedPhoto = File(image.path));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error taking photo: $e'), backgroundColor: AppColors.accentRed),
      );
    }
  }

  Future<void> _pickDoc() async {
    try {
      final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery, imageQuality: 85);
      if (image != null) setState(() => uploadedDoc = File(image.path));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking document: $e'), backgroundColor: AppColors.accentRed),
      );
    }
  }

  Future<void> _takeDoc() async {
    try {
      final XFile? image = await _imagePicker.pickImage(source: ImageSource.camera, imageQuality: 85);
      if (image != null) setState(() => uploadedDoc = File(image.path));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error taking document: $e'), backgroundColor: AppColors.accentRed),
      );
    }
  }

  Future<void> _submit() async {
    if (fullNameController.text.isEmpty || addressController.text.isEmpty || contactController.text.isEmpty || dob == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Please fill all required fields'), backgroundColor: AppColors.accentRed),
      );
      return;
    }

    final currentUid = AuthService.instance.currentUid;
    if (currentUid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Please login first'), backgroundColor: AppColors.accentRed),
      );
      return;
    }

    setState(() => isSubmitting = true);

    try {
      final db = DatabaseService.instance;
      final requestId = await db.createRequest(
        type: 'Barangay ID',
        purpose: 'DOB: $dob, Address: ${addressController.text}',
        fullName: fullNameController.text,
        proofUrl: '',
        createdBy: currentUid,
      );

      String proofUrl = '';
      if (uploadedPhoto != null) {
        proofUrl = await db.uploadProofImage(imageFile: uploadedPhoto!, requestId: requestId);
        await FirebaseFirestore.instance.collection('requests').doc(requestId).update({'proofUrl': proofUrl});
      } else if (uploadedDoc != null) {
        proofUrl = await db.uploadProofImage(imageFile: uploadedDoc!, requestId: requestId);
        await FirebaseFirestore.instance.collection('requests').doc(requestId).update({'proofUrl': proofUrl});
      }
    
      if (mounted) {
        setState(() => isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Request submitted successfully!'), backgroundColor: AppColors.brightGreen),
        );
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) widget.onBack();
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting request: $e'), backgroundColor: AppColors.accentRed),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryOrange,
        title: const Text('Barangay ID'),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: widget.onBack),
      ),
      body: Container(
        color: AppColors.paleOrange,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Fill in the information below', style: TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Full Name'),
                      _buildTextField(fullNameController, 'Juan Dela Cruz', Icons.person),
                      const SizedBox(height: 16),
                      _buildLabel('Date of Birth'),
                      GestureDetector(
                        onTap: () async {
                          final picked = await showDatePicker(context: context, initialDate: DateTime(2000), firstDate: DateTime(1950), lastDate: DateTime.now());
                          if (picked != null) setState(() => dob = "${picked.year}-${picked.month}-${picked.day}");
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(color: AppColors.lightGrey, borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today, color: AppColors.primaryOrange),
                              const SizedBox(width: 12),
                              Text(dob ?? 'Select your date of birth', style: const TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildLabel('Complete Address'),
                      _buildTextField(addressController, 'House No., Street, Barangay, City', Icons.location_on),
                      const SizedBox(height: 16),
                      _buildLabel('Contact Number'),
                      _buildTextField(contactController, '09XX XXX XXXX', Icons.phone),
                      const SizedBox(height: 16),
                      _buildLabel('Upload 1x1 or 2x2 photo'),
                      Row(
                        children: [
                          Expanded(child: _buildFileUpload(_pickPhoto, 'Gallery')),
                          const SizedBox(width: 12),
                          Expanded(child: _buildFileUpload(_takePhoto, 'Camera')),
                        ],
                      ),
                      if (uploadedPhoto != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: AppColors.brightGreen.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            children: [
                              Icon(Icons.check_circle, color: AppColors.brightGreen, size: 20),
                              const SizedBox(width: 8),
                              Expanded(child: Text('Photo: ${uploadedPhoto!.path.split('/').last}', style: TextStyle(color: AppColors.primaryOrange, fontSize: 12))),
                              GestureDetector(onTap: () => setState(() => uploadedPhoto = null), child: Icon(Icons.close, color: AppColors.accentRed, size: 20)),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      _buildLabel('Upload supporting documents'),
                      Row(
                        children: [
                          Expanded(child: _buildFileUpload(_pickDoc, 'Gallery')),
                          const SizedBox(width: 12),
                          Expanded(child: _buildFileUpload(_takeDoc, 'Camera')),
                        ],
                      ),
                      if (uploadedDoc != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: AppColors.brightGreen.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            children: [
                              Icon(Icons.check_circle, color: AppColors.brightGreen, size: 20),
                              const SizedBox(width: 8),
                              Expanded(child: Text('Document: ${uploadedDoc!.path.split('/').last}', style: TextStyle(color: AppColors.primaryOrange, fontSize: 12))),
                              GestureDetector(onTap: () => setState(() => uploadedDoc = null), child: Icon(Icons.close, color: AppColors.accentRed, size: 20)),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: isSubmitting ? null : _submit,
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B4513)),
                          child: isSubmitting
                              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(AppColors.white)))
                              : const Text('Submit Request', style: TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Form: Permit Request
class PermitRequestForm extends StatefulWidget {
  final VoidCallback onBack;
  const PermitRequestForm({required this.onBack});

  @override
  State<PermitRequestForm> createState() => _PermitRequestFormState();
}

class _PermitRequestFormState extends State<PermitRequestForm> {
  final fullNameController = TextEditingController();
  final businessNameController = TextEditingController();
  final purposeController = TextEditingController();
  String permitType = 'Business';
  File? uploadedFile;
  final ImagePicker _imagePicker = ImagePicker();
  bool isSubmitting = false;

  @override
  void dispose() {
    fullNameController.dispose();
    businessNameController.dispose();
    purposeController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    try {
      final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery, imageQuality: 85);
      if (image != null) setState(() => uploadedFile = File(image.path));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: $e'), backgroundColor: AppColors.accentRed),
      );
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? image = await _imagePicker.pickImage(source: ImageSource.camera, imageQuality: 85);
      if (image != null) setState(() => uploadedFile = File(image.path));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error taking photo: $e'), backgroundColor: AppColors.accentRed),
      );
    }
  }

  Future<void> _submit() async {
    if (fullNameController.text.isEmpty || businessNameController.text.isEmpty || purposeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Please fill all required fields'), backgroundColor: AppColors.accentRed),
      );
      return;
    }

    final currentUid = AuthService.instance.currentUid;
    if (currentUid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Please login first'), backgroundColor: AppColors.accentRed),
      );
      return;
    }

    setState(() => isSubmitting = true);

    try {
      final db = DatabaseService.instance;
      final requestId = await db.createRequest(
        type: 'Permit Request - $permitType',
        purpose: purposeController.text,
        fullName: businessNameController.text,
        proofUrl: '',
        createdBy: currentUid,
      );

      String proofUrl = '';
      if (uploadedFile != null) {
        proofUrl = await db.uploadProofImage(imageFile: uploadedFile!, requestId: requestId);
        await FirebaseFirestore.instance.collection('requests').doc(requestId).update({'proofUrl': proofUrl});
      }
    
      if (mounted) {
        setState(() => isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Request submitted successfully!'), backgroundColor: AppColors.brightGreen),
        );
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) widget.onBack();
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting request: $e'), backgroundColor: AppColors.accentRed),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryOrange,
        title: const Text('Permit Request'),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: widget.onBack),
      ),
      body: Container(
        color: AppColors.paleOrange,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Complete the details below', style: TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Full Name'),
                      _buildTextField(fullNameController, 'Juan Dela Cruz', Icons.person),
                      const SizedBox(height: 16),
                      _buildLabel('Type of Permit'),
                      _buildDropdown(
                        value: permitType,
                        items: ['Business', 'Event', 'Construction', 'Others'],
                        onChanged: (val) => setState(() => permitType = val),
                      ),
                      const SizedBox(height: 16),
                      _buildLabel('Name of Business or Event'),
                      _buildTextField(businessNameController, 'Enter business or event name', Icons.business),
                      const SizedBox(height: 16),
                      _buildLabel('Purpose of Permit'),
                      _buildTextField(purposeController, 'Describe the purpose', Icons.description, maxLines: 3),
                      const SizedBox(height: 16),
                      _buildLabel('Upload required documents'),
                      Row(
                        children: [
                          Expanded(child: _buildFileUpload(_pickFile, 'Gallery')),
                          const SizedBox(width: 12),
                          Expanded(child: _buildFileUpload(_takePhoto, 'Camera')),
                        ],
                      ),
                      if (uploadedFile != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: AppColors.brightGreen.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            children: [
                              Icon(Icons.check_circle, color: AppColors.brightGreen, size: 20),
                              const SizedBox(width: 8),
                              Expanded(child: Text('File: ${uploadedFile!.path.split('/').last}', style: TextStyle(color: AppColors.primaryOrange, fontSize: 12))),
                              GestureDetector(onTap: () => setState(() => uploadedFile = null), child: Icon(Icons.close, color: AppColors.accentRed, size: 20)),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: isSubmitting ? null : _submit,
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B4513)),
                          child: isSubmitting
                              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(AppColors.white)))
                              : const Text('Submit Request', style: TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Form: Assistance Request
class AssistanceRequestForm extends StatefulWidget {
  final VoidCallback onBack;
  const AssistanceRequestForm({required this.onBack});

  @override
  State<AssistanceRequestForm> createState() => _AssistanceRequestFormState();
}

class _AssistanceRequestFormState extends State<AssistanceRequestForm> {
  final fullNameController = TextEditingController();
  final reasonController = TextEditingController();
  String assistanceType = 'Medical';
  File? uploadedFile;
  final ImagePicker _imagePicker = ImagePicker();
  bool isSubmitting = false;

  @override
  void dispose() {
    fullNameController.dispose();
    reasonController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    try {
      final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery, imageQuality: 85);
      if (image != null) setState(() => uploadedFile = File(image.path));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: $e'), backgroundColor: AppColors.accentRed),
      );
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? image = await _imagePicker.pickImage(source: ImageSource.camera, imageQuality: 85);
      if (image != null) setState(() => uploadedFile = File(image.path));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error taking photo: $e'), backgroundColor: AppColors.accentRed),
      );
    }
  }

  Future<void> _submit() async {
    if (fullNameController.text.isEmpty || reasonController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Please fill all required fields'), backgroundColor: AppColors.accentRed),
      );
      return;
    }

    final currentUid = AuthService.instance.currentUid;
    if (currentUid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Please login first'), backgroundColor: AppColors.accentRed),
      );
      return;
    }

    setState(() => isSubmitting = true);

    try {
      final db = DatabaseService.instance;
      final requestId = await db.createRequest(
        type: 'Request for Assistance - $assistanceType',
        purpose: reasonController.text,
        fullName: fullNameController.text,
        proofUrl: '',
        createdBy: currentUid,
      );

      String proofUrl = '';
      if (uploadedFile != null) {
        proofUrl = await db.uploadProofImage(imageFile: uploadedFile!, requestId: requestId);
        await FirebaseFirestore.instance.collection('requests').doc(requestId).update({'proofUrl': proofUrl});
      }
    
      if (mounted) {
        setState(() => isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Request submitted successfully!'), backgroundColor: AppColors.brightGreen),
        );
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) widget.onBack();
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting request: $e'), backgroundColor: AppColors.accentRed),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryOrange,
        title: const Text('Request for Assistance'),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: widget.onBack),
      ),
      body: Container(
        color: AppColors.paleOrange,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Enter your details below', style: TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Full Name'),
                      _buildTextField(fullNameController, 'Juan Dela Cruz', Icons.person),
                      const SizedBox(height: 16),
                      _buildLabel('Type of Assistance'),
                      _buildDropdown(
                        value: assistanceType,
                        items: ['Medical', 'Financial', 'Funeral', 'Others'],
                        onChanged: (val) => setState(() => assistanceType = val),
                      ),
                      const SizedBox(height: 16),
                      _buildLabel('Reason for Assistance'),
                      _buildTextField(reasonController, 'Explain why you are requesting assistance', Icons.description, maxLines: 3),
                      const SizedBox(height: 16),
                      _buildLabel('Upload proof or supporting document'),
                      Row(
                        children: [
                          Expanded(child: _buildFileUpload(_pickFile, 'Gallery')),
                          const SizedBox(width: 12),
                          Expanded(child: _buildFileUpload(_takePhoto, 'Camera')),
                        ],
                      ),
                      if (uploadedFile != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: AppColors.brightGreen.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            children: [
                              Icon(Icons.check_circle, color: AppColors.brightGreen, size: 20),
                              const SizedBox(width: 8),
                              Expanded(child: Text('File: ${uploadedFile!.path.split('/').last}', style: TextStyle(color: AppColors.primaryOrange, fontSize: 12))),
                              GestureDetector(onTap: () => setState(() => uploadedFile = null), child: Icon(Icons.close, color: AppColors.accentRed, size: 20)),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: isSubmitting ? null : _submit,
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B4513)),
                          child: isSubmitting
                              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(AppColors.white)))
                              : const Text('Submit Request', style: TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Form: Other Request
class OtherRequestForm extends StatefulWidget {
  final VoidCallback onBack;
  const OtherRequestForm({required this.onBack});

  @override
  State<OtherRequestForm> createState() => _OtherRequestFormState();
}

class _OtherRequestFormState extends State<OtherRequestForm> {
  final fullNameController = TextEditingController();
  final requestTypeController = TextEditingController();
  final detailsController = TextEditingController();
  File? uploadedFile;
  final ImagePicker _imagePicker = ImagePicker();
  bool isSubmitting = false;

  @override
  void dispose() {
    fullNameController.dispose();
    requestTypeController.dispose();
    detailsController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    try {
      final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery, imageQuality: 85);
      if (image != null) setState(() => uploadedFile = File(image.path));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: $e'), backgroundColor: AppColors.accentRed),
      );
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? image = await _imagePicker.pickImage(source: ImageSource.camera, imageQuality: 85);
      if (image != null) setState(() => uploadedFile = File(image.path));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error taking photo: $e'), backgroundColor: AppColors.accentRed),
      );
    }
  }

  Future<void> _submit() async {
    if (fullNameController.text.isEmpty || requestTypeController.text.isEmpty || detailsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Please fill all required fields'), backgroundColor: AppColors.accentRed),
      );
      return;
    }

    final currentUid = AuthService.instance.currentUid;
    if (currentUid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Please login first'), backgroundColor: AppColors.accentRed),
      );
      return;
    }

    setState(() => isSubmitting = true);

    try {
      final db = DatabaseService.instance;
      final requestId = await db.createRequest(
        type: 'Other Request - ${requestTypeController.text}',
        purpose: detailsController.text,
        fullName: fullNameController.text,
        proofUrl: '',
        createdBy: currentUid,
      );

      String proofUrl = '';
      if (uploadedFile != null) {
        proofUrl = await db.uploadProofImage(imageFile: uploadedFile!, requestId: requestId);
        await FirebaseFirestore.instance.collection('requests').doc(requestId).update({'proofUrl': proofUrl});
      }
    
      if (mounted) {
        setState(() => isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Request submitted successfully!'), backgroundColor: AppColors.brightGreen),
        );
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) widget.onBack();
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting request: $e'), backgroundColor: AppColors.accentRed),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryOrange,
        title: const Text('Other Request'),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: widget.onBack),
      ),
      body: Container(
        color: AppColors.paleOrange,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Specify your request below', style: TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Full Name'),
                      _buildTextField(fullNameController, 'Juan Dela Cruz', Icons.person),
                      const SizedBox(height: 16),
                      _buildLabel('Type of Request'),
                      _buildTextField(requestTypeController, 'Enter the type of request', Icons.label),
                      const SizedBox(height: 16),
                      _buildLabel('Details or Description'),
                      _buildTextField(detailsController, 'Provide details or description', Icons.description, maxLines: 3),
                      const SizedBox(height: 16),
                      _buildLabel('Upload proof or supporting document'),
                      Row(
                        children: [
                          Expanded(child: _buildFileUpload(_pickFile, 'Gallery')),
                          const SizedBox(width: 12),
                          Expanded(child: _buildFileUpload(_takePhoto, 'Camera')),
                        ],
                      ),
                      if (uploadedFile != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: AppColors.brightGreen.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            children: [
                              Icon(Icons.check_circle, color: AppColors.brightGreen, size: 20),
                              const SizedBox(width: 8),
                              Expanded(child: Text('File: ${uploadedFile!.path.split('/').last}', style: TextStyle(color: AppColors.primaryOrange, fontSize: 12))),
                              GestureDetector(onTap: () => setState(() => uploadedFile = null), child: Icon(Icons.close, color: AppColors.accentRed, size: 20)),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: isSubmitting ? null : _submit,
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B4513)),
                          child: isSubmitting
                              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(AppColors.white)))
                              : const Text('Submit Request', style: TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Helper widgets
Widget _buildLabel(String label) {
  return Text(
    label,
    style: TextStyle(
      color: AppColors.primaryOrange,
      fontSize: 13,
      fontWeight: FontWeight.w600,
    ),
  );
}

Widget _buildTextField(TextEditingController controller, String hint, IconData icon, {int maxLines = 1}) {
  return TextField(
    controller: controller,
    maxLines: maxLines,
    decoration: InputDecoration(
      filled: true,
      fillColor: AppColors.lightGrey,
      prefixIcon: Icon(icon, color: AppColors.primaryOrange),
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    ),
  );
}

Widget _buildDropdown({
  required String value,
  required List<String> items,
  required Function(String) onChanged,
}) {
  return Container(
    decoration: BoxDecoration(
      color: AppColors.lightGrey,
      borderRadius: BorderRadius.circular(10),
    ),
    child: DropdownButton<String>(
      value: value,
      isExpanded: true,
      underline: const SizedBox(),
      onChanged: (newVal) => onChanged(newVal ?? value),
      items: items
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Padding(
                  padding: const EdgeInsets.only(left: 14),
                  child: Text(item),
                ),
              ))
          .toList(),
    ),
  );
}

Widget _buildFileUpload(VoidCallback onTap, String label) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryOrange, width: 2),
        borderRadius: BorderRadius.circular(10),
        color: AppColors.lightGrey,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            label == 'Camera' ? Icons.camera_alt : Icons.photo_library,
            color: AppColors.primaryOrange,
            size: 28,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(color: AppColors.primaryOrange, fontWeight: FontWeight.w500, fontSize: 12),
          ),
        ],
      ),
    ),
  );
}
