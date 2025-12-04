import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import '../services/auth_service.dart';
import '../services/data_service.dart';

class ReportAnIssuePage extends StatefulWidget {
  const ReportAnIssuePage({Key? key}) : super(key: key);

  @override
  State<ReportAnIssuePage> createState() => _ReportAnIssuePageState();
}

class _ReportAnIssuePageState extends State<ReportAnIssuePage> {
  final TextEditingController descriptionController = TextEditingController();
  String selectedCategory = 'Garbage';
  bool isSubmitting = false;

  final List<Map<String, dynamic>> categories = [
    {'name': 'Garbage', 'icon': '🗑️', 'color': Color(0xFFFFB74D)},
    {'name': 'Noise', 'icon': '🔊', 'color': Color(0xFF64B5F6)},
    {'name': 'Safety', 'icon': '⚠️', 'color': Color(0xFFEF5350)},
    {'name': 'Water', 'icon': '💧', 'color': Color(0xFF4FC3F7)},
    {'name': 'Road Damage', 'icon': '🛣️', 'color': Color(0xFF90A4AE)},
    {'name': 'Illegal Activities', 'icon': '🚨', 'color': Color(0xFFF06292)},
    {'name': 'Other', 'icon': '📝', 'color': Color(0xFF9575CD)},
  ];

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  void _submitReport() async {
    final description = descriptionController.text.trim();
    final currentUser = AuthService.instance.currentUser;
    final userName = currentUser?['name'] ?? 'Anonymous';

    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please describe your concern'),
          backgroundColor: AppColors.accentRed,
        ),
      );
      return;
    }

    setState(() => isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 800));

    DataService.instance.submitReport(selectedCategory, description, userName);

    if (mounted) {
      setState(() => isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Report submitted successfully!'),
          backgroundColor: AppColors.brightGreen,
        ),
      );
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          Navigator.pop(context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryOrange,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Report an Issue',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
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
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    'Help us improve the barangay by reporting issues',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Card with form
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Issue category with beautiful buttons
                        Text(
                          'What is the issue about?',
                          style: TextStyle(
                            color: AppColors.primaryOrange,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 16),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1.2,
                          ),
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            final isSelected = selectedCategory == category['name'];
                            return GestureDetector(
                              onTap: () {
                                setState(() => selectedCategory = category['name']);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? category['color']
                                      : AppColors.lightGrey,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? category['color']
                                        : AppColors.lightGrey,
                                    width: 2,
                                  ),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: category['color']
                                                .withOpacity(0.3),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ]
                                      : [],
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      category['icon'],
                                      style: const TextStyle(fontSize: 28),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      category['name'],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: isSelected
                                            ? AppColors.white
                                            : AppColors.darkGrey,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        // Issue details
                        Text(
                          'Describe the Issue',
                          style: TextStyle(
                            color: AppColors.primaryOrange,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.lightGrey,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.primaryOrange.withOpacity(0.3),
                            ),
                          ),
                          child: TextField(
                            controller: descriptionController,
                            maxLines: 6,
                            decoration: InputDecoration(
                              hintText:
                                  'Provide detailed information about the issue...',
                              hintStyle: TextStyle(
                                color: AppColors.lightGrey,
                                fontSize: 13,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(16),
                            ),
                            style: TextStyle(
                              color: AppColors.primaryOrange,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        // Submit button
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton.icon(
                            onPressed: isSubmitting ? null : _submitReport,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isSubmitting
                                  ? AppColors.lightGrey
                                  : const Color(0xFF8B4513),
                              disabledBackgroundColor: AppColors.lightGrey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 5,
                            ),
                            icon: isSubmitting
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor:
                                          AlwaysStoppedAnimation<Color>(
                                        AppColors.primaryOrange,
                                      ),
                                    ),
                                  )
                                : const Icon(Icons.send),
                            label: Text(
                              isSubmitting ? 'Submitting...' : 'Submit Report',
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Info text
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.brightBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.brightBlue.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info,
                                color: AppColors.brightBlue,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Your report will be tracked and you can monitor its status',
                                  style: TextStyle(
                                    color: AppColors.brightBlue,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
