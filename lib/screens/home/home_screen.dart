import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movira_driver/screens/home/widget/earnings_stats_card.dart';
import 'package:movira_driver/screens/home/widget/reject_request_bottom_sheet.dart';
import 'package:movira_driver/screens/home/widget/ride_request_card.dart';
import 'package:movira_driver/utils/constants/colors.dart';
import 'package:movira_driver/utils/text_style.dart';

import '../ridebooking/ride_booking_screen.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  bool _isOnline = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65),
        child: AppBar(
          backgroundColor: AppColors.white,
          elevation: 4,
          automaticallyImplyLeading: false,
          centerTitle: false,
          titleSpacing: 16,
          title: Row(
            children: [
              // Profile Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/user.png',
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.greyLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.person,
                        color: AppColors.textSecondary,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(width: 12),

              // Name and Location
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Bessie Cooper',
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '4140 Parker Rd, Mexico 31134',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            // Notification Bell
            Center(
              child: Container(
                height: 40,
                width: 40,
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.notifications,
                    color: AppColors.black,
                    size: 20,
                  ),
                  onPressed: () {
                    // Navigate to notifications
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Change Status Section - Attached to AppBar
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Change Status',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _isOnline ? 'Online' : 'Offline',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: _isOnline ? Colors.green : Colors.red.shade600,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Transform.scale(
                    scale: 0.75, // Adjust this value to make it smaller or larger
                    child: Switch(
                      value: _isOnline,
                      onChanged: (value) {
                        setState(() {
                          _isOnline = value;
                        });
                      },
                      activeThumbColor: Colors.green,
                      activeTrackColor: Colors.green.shade100,
                      inactiveThumbColor: AppColors.textSecondary,
                      inactiveTrackColor: AppColors.greyLight,
                    ),
                  )
                  ,
                ],
              ),
            ),
          ),

          // Main Content
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Earnings Card
                      EarningsStatsCard(
                        todayEarnings: '\$32',
                        inProgressDeliveries: 56,
                        completedDeliveries: 46,
                        onTap: () {
                          // Navigate to earnings details
                        },
                      ),

                      const SizedBox(height: 24),

                      // Show content based on online/offline status
                      if (_isOnline) ...[
                        // All Requests Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'All Requests (2)',
                              style: AppTextStyles.h5.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Navigate to all requests
                                Get.to(RideBookingScreen());
                              },
                              child: Row(
                                children: [
                                  Text(
                                    'View All',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.orange,
                                    size: 14,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Request Card 1
                        RideRequestCard(
                          name: 'Marvin McKinney',
                          image: 'assets/images/profile_user.png',
                          price: '\$65',
                          bookingType: 'Booked for rider',
                          pickupLocation: 'Maryland bustop, Anthony Ikeja',
                          dropLocation:
                          '6391 Elgin St, Celina, Delaware 10299',
                          timerSeconds: 109,
                          onAccept: () {
                            print('Accepted ride');
                          },
                          onReject: () {
                            Get.bottomSheet(
                              RejectRequestBottomSheet(
                                onSubmit: () {
                                  print('Request rejected with reason');
                                  // Handle rejection logic
                                },
                              ),
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                            );
                          },
                          onTimerExpired: () {
                            print('Timer expired');
                          },
                        ),

                        const SizedBox(height: 16),

                        // Request Card 2
                        RideRequestCard(
                          name: 'Savannah Nguyen',
                          image: 'assets/images/profile_user.png',
                          price: '\$65',
                          bookingType: 'Booked for parcel',
                          pickupLocation: 'Maryland bustop, Anthony Ikeja',
                          dropLocation:
                          '6391 Elgin St, Celina, Delaware 10299',
                          timerSeconds: 59,
                          onAccept: () {
                            print('Accepted parcel delivery');
                          },
                          onReject: () {
                            Get.bottomSheet(
                              RejectRequestBottomSheet(
                                onSubmit: () {
                                  print('Request rejected with reason');
                                  // Handle rejection logic
                                },
                              ),
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                            );
                          },
                          onTimerExpired: () {
                            print('Timer expired for parcel');
                          },
                        ),
                      ] else ...[
                        // Offline Message
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 40),
                              Image.asset(
                                'assets/images/offline.png',
                                width: 200,
                                height: 200,
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'You are offline now!',
                                style: AppTextStyles.h4.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 40),
                                child: Text(
                                  'You don\'t have booking requests as you are offline now, Go online to get ride requests.',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textSecondary,
                                    fontSize: 13,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
