import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../services/data_service.dart';
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
  String? uploadedFile;

  @override
  void dispose() {
    fullNameController.dispose();
    purposeController.dispose();
    super.dispose();
  }

  void _submit() {
    if (fullNameController.text.isEmpty || purposeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Please fill all required fields'), backgroundColor: AppColors.accentRed),
      );
      return;
    }
    
    final userName = AuthService.instance.currentUser?['name'] ?? 'Unknown';
    DataService.instance.submitRequest(
      'Barangay Clearance',
      userName,
      fullNameController.text,
      purposeController.text,
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: const Text('Request submitted successfully!'), backgroundColor: AppColors.brightGreen),
    );
    
    Future.delayed(const Duration(milliseconds: 500), () {
      widget.onBack();
    });
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
                      _buildFileUpload(() => setState(() => uploadedFile = 'barangay_clearance.pdf')),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B4513)),
                          child: const Text('Submit Request', style: TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w600)),
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
  String? uploadedFile;

  @override
  void dispose() {
    fullNameController.dispose();
    purposeController.dispose();
    super.dispose();
  }

  void _submit() {
    if (fullNameController.text.isEmpty || purposeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Please fill all required fields'), backgroundColor: AppColors.accentRed),
      );
      return;
    }
    
    final userName = AuthService.instance.currentUser?['name'] ?? 'Unknown';
    DataService.instance.submitRequest(
      'Certification',
      userName,
      fullNameController.text,
      purposeController.text,
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: const Text('Request submitted successfully!'), backgroundColor: AppColors.brightGreen),
    );
    
    Future.delayed(const Duration(milliseconds: 500), () {
      widget.onBack();
    });
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
                      _buildFileUpload(() => setState(() => uploadedFile = 'certification_doc.pdf')),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B4513)),
                          child: const Text('Submit Request', style: TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w600)),
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
  String? uploadedPhoto;
  String? uploadedDoc;

  @override
  void dispose() {
    fullNameController.dispose();
    addressController.dispose();
    contactController.dispose();
    super.dispose();
  }

  void _submit() {
    if (fullNameController.text.isEmpty || addressController.text.isEmpty || contactController.text.isEmpty || dob == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Please fill all required fields'), backgroundColor: AppColors.accentRed),
      );
      return;
    }
    
    final userName = AuthService.instance.currentUser?['name'] ?? 'Unknown';
    DataService.instance.submitRequest(
      'Barangay ID',
      userName,
      fullNameController.text,
      'DOB: $dob, Address: ${addressController.text}',
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: const Text('Request submitted successfully!'), backgroundColor: AppColors.brightGreen),
    );
    
    Future.delayed(const Duration(milliseconds: 500), () {
      widget.onBack();
    });
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
                      _buildFileUpload(() => setState(() => uploadedPhoto = 'photo_id.jpg')),
                      const SizedBox(height: 16),
                      _buildLabel('Upload supporting documents'),
                      _buildFileUpload(() => setState(() => uploadedDoc = 'supporting_docs.pdf')),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B4513)),
                          child: const Text('Submit Request', style: TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w600)),
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
  String? uploadedFile;

  @override
  void dispose() {
    fullNameController.dispose();
    businessNameController.dispose();
    purposeController.dispose();
    super.dispose();
  }

  void _submit() {
    if (fullNameController.text.isEmpty || businessNameController.text.isEmpty || purposeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Please fill all required fields'), backgroundColor: AppColors.accentRed),
      );
      return;
    }
    
    final userName = AuthService.instance.currentUser?['name'] ?? 'Unknown';
    DataService.instance.submitRequest(
      'Permit Request',
      userName,
      businessNameController.text,
      purposeController.text,
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: const Text('Request submitted successfully!'), backgroundColor: AppColors.brightGreen),
    );
    
    Future.delayed(const Duration(milliseconds: 500), () {
      widget.onBack();
    });
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
                      _buildFileUpload(() => setState(() => uploadedFile = 'permit_docs.pdf')),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B4513)),
                          child: const Text('Submit Request', style: TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w600)),
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
  String? uploadedFile;

  @override
  void dispose() {
    fullNameController.dispose();
    reasonController.dispose();
    super.dispose();
  }

  void _submit() {
    if (fullNameController.text.isEmpty || reasonController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Please fill all required fields'), backgroundColor: AppColors.accentRed),
      );
      return;
    }
    
    final userName = AuthService.instance.currentUser?['name'] ?? 'Unknown';
    DataService.instance.submitRequest(
      'Request for Assistance',
      userName,
      fullNameController.text,
      reasonController.text,
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: const Text('Request submitted successfully!'), backgroundColor: AppColors.brightGreen),
    );
    
    Future.delayed(const Duration(milliseconds: 500), () {
      widget.onBack();
    });
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
                      _buildFileUpload(() => setState(() => uploadedFile = 'proof_doc.pdf')),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B4513)),
                          child: const Text('Submit Request', style: TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w600)),
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
  String? uploadedFile;

  @override
  void dispose() {
    fullNameController.dispose();
    requestTypeController.dispose();
    detailsController.dispose();
    super.dispose();
  }

  void _submit() {
    if (fullNameController.text.isEmpty || requestTypeController.text.isEmpty || detailsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('Please fill all required fields'), backgroundColor: AppColors.accentRed),
      );
      return;
    }
    
    final userName = AuthService.instance.currentUser?['name'] ?? 'Unknown';
    DataService.instance.submitRequest(
      'Other Request',
      userName,
      requestTypeController.text,
      detailsController.text,
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: const Text('Request submitted successfully!'), backgroundColor: AppColors.brightGreen),
    );
    
    Future.delayed(const Duration(milliseconds: 500), () {
      widget.onBack();
    });
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
                      _buildFileUpload(() => setState(() => uploadedFile = 'supporting_doc.pdf')),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B4513)),
                          child: const Text('Submit Request', style: TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w600)),
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

Widget _buildFileUpload(VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryOrange, width: 2),
        borderRadius: BorderRadius.circular(10),
        color: AppColors.lightGrey,
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Icon(Icons.cloud_upload, color: AppColors.primaryOrange, size: 32),
          const SizedBox(height: 8),
          Text(
            'Attach file (PDF, JPG)',
            style: TextStyle(color: AppColors.primaryOrange, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    ),
  );
}
