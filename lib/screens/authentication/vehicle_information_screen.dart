import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:movira_driver/screens/payment/card_add_screen.dart';
import 'package:movira_driver/utils/constants/colors.dart';
import 'package:movira_driver/utils/text_style.dart';
import 'package:movira_driver/utils/widgets/my_app_bar.dart';
import 'package:movira_driver/utils/widgets/my_text_box.dart';

import 'document_upload_screen.dart';

class VehicleInformationScreen extends StatefulWidget {
  const VehicleInformationScreen({super.key});

  @override
  State<VehicleInformationScreen> createState() =>
      _VehicleInformationScreenState();
}

class _VehicleInformationScreenState extends State<VehicleInformationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();
  final _plateNumberController = TextEditingController();
  final _ssnController = TextEditingController();

  String? _selectedVehicleType;
  String? _selectedVehicleBrand;
  int _currentStep = 1;
  final int _totalSteps = 3;

  final List<String> _vehicleTypes = [
    'Sedan',
    'SUV',
    'Hatchback',
    'Truck',
    'Van',
    'Coupe',
  ];

  final List<String> _vehicleBrands = [
    'Toyota',
    'Honda',
    'Ford',
    'BMW',
    'Mercedes',
    'Audi',
    'Nissan',
    'Hyundai',
  ];

  @override
  void dispose() {
    _modelController.dispose();
    _yearController.dispose();
    _plateNumberController.dispose();
    _ssnController.dispose();
    super.dispose();
  }

  void _showVehicleTypePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Vehicle Type',
                style: AppTextStyles.h4,
              ),
              const SizedBox(height: 20),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _vehicleTypes.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        _vehicleTypes[index],
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.black,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _selectedVehicleType = _vehicleTypes[index];
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showVehicleBrandPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select Vehicle Brand',
                style: AppTextStyles.h4,
              ),
              const SizedBox(height: 20),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _vehicleBrands.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        _vehicleBrands[index],
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.black,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _selectedVehicleBrand = _vehicleBrands[index];
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const MAppBar(
        title: 'Vehicle Information',
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // Vehicle Type Dropdown
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Vehicle Type',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: _showVehicleTypePicker,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(
                                color: AppColors.greyLight,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _selectedVehicleType ?? 'Select vehicle type',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: _selectedVehicleType != null
                                          ? AppColors.black
                                          : AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                                SvgPicture.asset(
                                  'assets/icons/arrow_down.svg',
                                  width: 20,
                                  height: 20,
                                  colorFilter: ColorFilter.mode(
                                    AppColors.textSecondary,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Vehicle Brand Dropdown
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Vehicle Brand',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: _showVehicleBrandPicker,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(
                                color: AppColors.greyLight,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _selectedVehicleBrand ?? 'Enter vehicle brand',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: _selectedVehicleBrand != null
                                          ? AppColors.black
                                          : AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                                SvgPicture.asset(
                                  'assets/icons/arrow_down.svg',
                                  width: 20,
                                  height: 20,
                                  colorFilter: ColorFilter.mode(
                                    AppColors.textSecondary,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Model
                    MTextField(
                      label: 'Model',
                      hintText: 'Enter your vehicle model',
                      iconPath: 'assets/icons/car.svg',
                      controller: _modelController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your vehicle model';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Make model year
                    MTextField(
                      label: 'Make model year',
                      hintText: 'Enter the year',
                      iconPath: 'assets/icons/calendar.svg',
                      controller: _yearController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the year';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Vehicle Plate Number
                    MTextField(
                      label: 'Vehicle Plate Number',
                      hintText: 'Enter vehicle plate number',
                      iconPath: 'assets/icons/plate.svg',
                      controller: _plateNumberController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter vehicle plate number';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Social security number
                    MTextField(
                      label: 'Social security number',
                      hintText: 'Enter social security number',
                      iconPath: 'assets/icons/security.svg',
                      controller: _ssnController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter social security number';
                        }
                        return null;
                      },
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

                    // Continue Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          // if (_formKey.currentState!.validate()) {
                          //   if (_selectedVehicleType == null) {
                          //     ScaffoldMessenger.of(context).showSnackBar(
                          //       SnackBar(
                          //         content: Text(
                          //           'Please select a vehicle type',
                          //           style: AppTextStyles.bodyMedium.copyWith(
                          //             color: AppColors.white,
                          //           ),
                          //         ),
                          //         backgroundColor: Colors.red,
                          //       ),
                          //     );
                          //     return;
                          //   }
                          //   if (_selectedVehicleBrand == null) {
                          //     ScaffoldMessenger.of(context).showSnackBar(
                          //       SnackBar(
                          //         content: Text(
                          //           'Please select a vehicle brand',
                          //           style: AppTextStyles.bodyMedium.copyWith(
                          //             color: AppColors.white,
                          //           ),
                          //         ),
                          //         backgroundColor: Colors.red,
                          //       ),
                          //     );
                          //     return;
                          //   }
                          //   // Handle continue
                          //   Get.to(CardAddScreen());
                          // }
                          Get.to(const DocumentUploadScreen());
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
                          'Continue',
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
      ),
    );
  }
}