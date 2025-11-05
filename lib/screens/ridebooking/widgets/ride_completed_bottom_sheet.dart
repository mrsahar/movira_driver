import 'package:flutter/material.dart';
import 'package:movira_driver/utils/constants/colors.dart';
import 'package:movira_driver/utils/text_style.dart';

class RideCompletedBottomSheet extends StatelessWidget {
  final VoidCallback onRateRider;
  final VoidCallback onSkip;

  const RideCompletedBottomSheet({
    super.key,
    required this.onRateRider,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Celebration Image
          Image.asset(
            'assets/images/reached.png',
            width: 120,
            height: 120,
          ),

          const SizedBox(height: 24),

          // Title
          Text(
            'Ride Completed',
            style: AppTextStyles.h4.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),

          const SizedBox(height: 8),

          // Subtitle
          Text(
            'Your ride has been completed successfully',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),

          // Rate this Rider Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: onRateRider,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.black,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: Text(
                'Rate this Rider',
                style: AppTextStyles.button.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Skip Button
          TextButton(
            onPressed: onSkip,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Text(
              'Skip',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.black,
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
          ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}