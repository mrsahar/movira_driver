import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movira_driver/utils/constants/colors.dart';
import 'package:movira_driver/utils/text_style.dart';

class RejectRequestBottomSheet extends StatefulWidget {
  final VoidCallback onSubmit;
  final String? selectedReason;

  const RejectRequestBottomSheet({
    super.key,
    required this.onSubmit,
    this.selectedReason,
  });

  @override
  State<RejectRequestBottomSheet> createState() =>
      _RejectRequestBottomSheetState();
}

class _RejectRequestBottomSheetState extends State<RejectRequestBottomSheet> {
  String? _selectedReason;

  final List<String> _rejectReasons = [
    'Wrong address shown',
    'Any Legal instructions violation',
    'Other reason',
  ];

  @override
  void initState() {
    super.initState();
    _selectedReason = widget.selectedReason;
  }

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
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          Text(
            'Reject Request',
            style: AppTextStyles.h4.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 8),

          // Subtitle
          Text(
            'Please select a reason for reject booking',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 8),

          // Reason List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _rejectReasons.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: AppColors.greyLight,
            ),
            itemBuilder: (context, index) {
              final reason = _rejectReasons[index];
              final isSelected = _selectedReason == reason;

              return ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 4,
                ),
                title: Text(
                  reason,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isSelected ? Colors.brown.shade700 : AppColors.black,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
                trailing: isSelected
                    ? Icon(
                  Icons.check,
                  color: Colors.brown.shade700,
                  size: 24,
                )
                    : null,
                onTap: () {
                  setState(() {
                    _selectedReason = reason;
                  });
                },
              );
            },
          ),

          const SizedBox(height: 16),

          // Submit Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _selectedReason != null
                  ? () {
                widget.onSubmit();
                Get.back(result: _selectedReason);
              }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.black,
                elevation: 0,
                disabledBackgroundColor: AppColors.greyLight,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: Text(
                'Submit',
                style: AppTextStyles.button.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Cancel Button
          TextButton(
            onPressed: () {
              Get.back();
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Text(
              'Cancel',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.black,
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
          ),

        ],
      ),
    );
  }
}

// Helper function to show the bottom sheet
void showRejectRequestBottomSheet(
    BuildContext context, {
      required VoidCallback onSubmit,
      String? selectedReason,
    }) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => RejectRequestBottomSheet(
      onSubmit: onSubmit,
      selectedReason: selectedReason,
    ),
  );
}