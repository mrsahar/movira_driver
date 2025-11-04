import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:movira_driver/screens/authentication/subscription_screen.dart';
import 'package:movira_driver/screens/payment/card_add_screen.dart';
import 'package:movira_driver/utils/constants/colors.dart';
import 'package:movira_driver/utils/text_style.dart';
import 'package:movira_driver/utils/widgets/my_app_bar.dart';

class DocumentUploadScreen extends StatefulWidget {
  const DocumentUploadScreen({super.key});

  @override
  State<DocumentUploadScreen> createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends State<DocumentUploadScreen> {
  bool _agreeToVerification = false;
  int _currentStep = 2;
  final int _totalSteps = 3;

  String? _licenseFrontPath;
  String? _licenseBackPath;
  String? _registrationPath;
  String? _inspectionPath;
  String? _insurancePath;

  void _pickDocument(String documentType) {
    // Handle document picker
    // After picking, update the respective path
    setState(() {
      switch (documentType) {
        case 'license_front':
          _licenseFrontPath = 'path/to/document';
          break;
        case 'license_back':
          _licenseBackPath = 'path/to/document';
          break;
        case 'registration':
          _registrationPath = 'path/to/document';
          break;
        case 'inspection':
          _inspectionPath = 'path/to/document';
          break;
        case 'insurance':
          _insurancePath = 'path/to/document';
          break;
      }
    });
  }

  Widget _buildUploadCard({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    String? filePath,
    bool isFullWidth = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isFullWidth ? double.infinity : null,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.greyLight,
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Upload icon
            SvgPicture.asset(
              'assets/icons/upload.svg',
              width: 28,
              height: 28,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.black,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const MAppBar(
        title: 'Complete Your Profile',
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Upload Driver's License
                  Text(
                    'Upload Driver\'s License',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: _buildUploadCard(
                          title: 'Upload Front side',
                          subtitle: '(max 2 mb)',
                          onTap: () => _pickDocument('license_front'),
                          filePath: _licenseFrontPath,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildUploadCard(
                          title: 'Upload Back side',
                          subtitle: '(max 2 mb)',
                          onTap: () => _pickDocument('license_back'),
                          filePath: _licenseBackPath,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Or divider
                  Center(
                    child: Text(
                      'Or',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Upload Vehicle Registration Document
                  Text(
                    'Upload Vehicle Registration Document',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),

                  _buildUploadCard(
                    title: 'Upload Document',
                    subtitle: '(max 2 mb)',
                    onTap: () => _pickDocument('registration'),
                    filePath: _registrationPath,
                    isFullWidth: true,
                  ),

                  const SizedBox(height: 20),

                  // Upload Vehicle Inspection Document
                  Text(
                    'Upload Vehicle Inspection Document',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),

                  _buildUploadCard(
                    title: 'Upload Document',
                    subtitle: '(max 2 mb)',
                    onTap: () => _pickDocument('inspection'),
                    filePath: _inspectionPath,
                    isFullWidth: true,
                  ),

                  const SizedBox(height: 20),

                  // Upload Vehicle Insurance Document
                  Text(
                    'Upload Vehicle Insurance Document',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),

                  _buildUploadCard(
                    title: 'Upload Document',
                    subtitle: '(max 2 mb)',
                    onTap: () => _pickDocument('insurance'),
                    filePath: _insurancePath,
                    isFullWidth: true,
                  ),

                  const SizedBox(height: 24),

                  // Checkbox
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: _agreeToVerification,
                          onChanged: (value) {
                            setState(() {
                              _agreeToVerification = value ?? false;
                            });
                          },
                          activeColor: AppColors.primary,
                          checkColor: AppColors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'I agree to undergo background verification as part of the registration process',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.black,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Progress Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _totalSteps,
                          (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 30,
                        height: 4,
                        decoration: BoxDecoration(
                          color: index <= _currentStep
                              ? AppColors.black
                              : AppColors.greyLight,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Verify Identity Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        // if (!_agreeToVerification) {
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //     SnackBar(
                        //       content: Text(
                        //         'Please agree to background verification',
                        //         style: AppTextStyles.bodyMedium.copyWith(
                        //           color: AppColors.white,
                        //         ),
                        //       ),
                        //       backgroundColor: Colors.red,
                        //     ),
                        //   );
                        //   return;
                        // }
                        // if (_licenseFrontPath == null || _licenseBackPath == null) {
                        //   ScaffoldMessenger.of(context).showSnackBar(
                        //     SnackBar(
                        //       content: Text(
                        //         'Please upload all required documents',
                        //         style: AppTextStyles.bodyMedium.copyWith(
                        //           color: AppColors.white,
                        //         ),
                        //       ),
                        //       backgroundColor: Colors.red,
                        //     ),
                        //   );
                        //   return;
                        // }
                        Get.to(const SubscriptionScreen());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.black,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: Text(
                        'Verify Identity',
                        style: AppTextStyles.button,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}