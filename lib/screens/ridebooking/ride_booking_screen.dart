import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:movira_driver/screens/ridebooking/widgets/heading_to_pickup_bottom_sheet.dart';
import 'package:movira_driver/screens/ridebooking/widgets/pickup_location_bottom_sheet.dart';
import 'package:movira_driver/screens/ridebooking/widgets/ride_completed_bottom_sheet.dart';
import 'package:movira_driver/utils/constants/colors.dart';
import 'package:movira_driver/utils/map_theme.dart';
import 'package:movira_driver/utils/widgets/my_app_bar.dart';

import '../home/delivery_receipt_screen.dart';

// Bottom Sheet Types Enum
enum BottomSheetType {
  pickup,
  destination,
  typeSelection,
  confirmation,
  findingDriver,
  driverArriving,
  tripProgress,
  sos,
  destinationReached,
}

class RideBookingScreen extends StatefulWidget {
  const RideBookingScreen({super.key});

  @override
  State<RideBookingScreen> createState() => _RideBookingScreenState();
}

class _RideBookingScreenState extends State<RideBookingScreen> {
  GoogleMapController? _mapController;
  LatLng _currentPosition = const LatLng(37.7749, -122.4194);
  LatLng _pickupPosition = const LatLng(37.7749, -122.4194);
  LatLng? _destinationPosition;
  final Set<Marker> _markers = {};
  bool _isLoading = true;


  // Search controllers for different bottom sheets
  final TextEditingController _pickupSearchController = TextEditingController();
  final TextEditingController _destinationSearchController = TextEditingController();

  List<Map<String, dynamic>> _searchResults = [];
  bool _showSearchResults = false;

  // Current bottom sheet being displayed
  BottomSheetType _currentBottomSheet = BottomSheetType.driverArriving;

  // Addresses
  String? _pickupAddress;
  String? _destinationAddress;

  // Booking details
  String selectedCarType = 'Mini Car';
  double baseFare = 95.0;
  double platformCharges = 5.0;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _pickupSearchController.dispose();
    _destinationSearchController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => _isLoading = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() => _isLoading = false);
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _pickupPosition = _currentPosition;
        _isLoading = false;
        _updateMarkers();
      });

      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(_currentPosition, 15),
      );
    } catch (e) {
      setState(() => _isLoading = false);
      print('Error getting location: $e');
    }
  }

  void _updateMarkers() {
    _markers.clear();

    // Current location marker (yellow)
    _markers.add(
      Marker(
        markerId: const MarkerId('current_location'),
        position: _currentPosition,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
        anchor: const Offset(0.5, 0.5),
      ),
    );

    // Pickup location marker (black pin)
    if (_pickupPosition != _currentPosition) {
      _markers.add(
        Marker(
          markerId: const MarkerId('pickup_location'),
          position: _pickupPosition,
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    }

    // Destination marker (red)
    if (_destinationPosition != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId('destination_location'),
          position: _destinationPosition!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }

    setState(() {});
  }

  Future<void> _searchLocation(String query) async {
    if (query.isEmpty || query.length < 3) {
      setState(() {
        _showSearchResults = false;
        _searchResults = [];
      });
      return;
    }

    try {
      List<Location> locations = await locationFromAddress(query);
      List<Map<String, dynamic>> results = [];

      for (var location in locations) {
        try {
          List<Placemark> placemarks = await placemarkFromCoordinates(
            location.latitude,
            location.longitude,
          );

          if (placemarks.isNotEmpty) {
            final placemark = placemarks.first;
            String name = '';

            if (placemark.name != null && placemark.name!.isNotEmpty) {
              name = placemark.name!;
            }
            if (placemark.street != null && placemark.street!.isNotEmpty) {
              name += name.isEmpty ? placemark.street! : ', ${placemark.street}';
            }
            if (placemark.locality != null && placemark.locality!.isNotEmpty) {
              name += name.isEmpty ? placemark.locality! : ', ${placemark.locality}';
            }
            if (placemark.country != null && placemark.country!.isNotEmpty) {
              name += name.isEmpty ? placemark.country! : ', ${placemark.country}';
            }

            results.add({
              'name': name.isEmpty ? 'Unknown Location' : name,
              'location': location,
            });
          }
        } catch (e) {
          print('Error getting placemark: $e');
        }
      }

      setState(() {
        _searchResults = results;
        _showSearchResults = results.isNotEmpty;
      });
    } catch (e) {
      print('Error searching location: $e');
      setState(() {
        _searchResults = [];
        _showSearchResults = false;
      });
    }
  }

  void _selectSearchResult(int index) async {
    final result = _searchResults[index];
    final Location location = result['location'];
    final selectedPosition = LatLng(location.latitude, location.longitude);

    if (_currentBottomSheet == BottomSheetType.pickup) {
      _pickupSearchController.text = result['name'];
      _pickupAddress = result['name'];
      setState(() {
        _pickupPosition = selectedPosition;
        _showSearchResults = false;
        _updateMarkers();
      });
    } else if (_currentBottomSheet == BottomSheetType.destination) {
      _destinationSearchController.text = result['name'];
      _destinationAddress = result['name'];
      setState(() {
        _destinationPosition = selectedPosition;
        _showSearchResults = false;
        _updateMarkers();
      });
    }

    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(selectedPosition, 16),
    );
  }

  void _onMapTapped(LatLng position) {
    if (_currentBottomSheet == BottomSheetType.pickup) {
      setState(() {
        _pickupPosition = position;
        _updateMarkers();
      });
      _updateSearchFieldWithAddress(position, true);
    } else if (_currentBottomSheet == BottomSheetType.destination) {
      setState(() {
        _destinationPosition = position;
        _updateMarkers();
      });
      _updateSearchFieldWithAddress(position, false);
    }
  }

  Future<void> _updateSearchFieldWithAddress(LatLng position, bool isPickup) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        String address = '';

        if (placemark.street != null && placemark.street!.isNotEmpty) {
          address = placemark.street!;
        }
        if (placemark.locality != null && placemark.locality!.isNotEmpty) {
          address += address.isEmpty ? placemark.locality! : ', ${placemark.locality}';
        }

        final finalAddress = address.isEmpty ? 'Selected Location' : address;

        if (isPickup) {
          _pickupSearchController.text = finalAddress;
          _pickupAddress = finalAddress;
        } else {
          _destinationSearchController.text = finalAddress;
          _destinationAddress = finalAddress;
        }
      }
    } catch (e) {
      print('Error getting address: $e');
    }
  }

  // Navigate to next bottom sheet
  void _goToNextBottomSheet() {
    setState(() {
      if (_currentBottomSheet == BottomSheetType.pickup) {
        _currentBottomSheet = BottomSheetType.destination;
        _showSearchResults = false;
      } else if (_currentBottomSheet == BottomSheetType.destination) {
        _currentBottomSheet = BottomSheetType.typeSelection;
        _showSearchResults = false;
      } else if (_currentBottomSheet == BottomSheetType.typeSelection) {
        _currentBottomSheet = BottomSheetType.confirmation;
      } else if (_currentBottomSheet == BottomSheetType.confirmation) {
        _currentBottomSheet = BottomSheetType.findingDriver;
        _simulateFindingDriver();
      }
      // TODO: Add more bottom sheet navigation logic here
    });
  }

  // Navigate to previous bottom sheet
  void _goToPreviousBottomSheet() {
    setState(() {
      if (_currentBottomSheet == BottomSheetType.destination) {
        _currentBottomSheet = BottomSheetType.pickup;
        _showSearchResults = false;
      } else if (_currentBottomSheet == BottomSheetType.typeSelection) {
        _currentBottomSheet = BottomSheetType.destination;
        _showSearchResults = false;
      } else if (_currentBottomSheet == BottomSheetType.confirmation) {
        _currentBottomSheet = BottomSheetType.typeSelection;
      }
      // TODO: Add more bottom sheet navigation logic here
    });
  }

  // Switch to specific bottom sheet
  void _switchToBottomSheet(BottomSheetType type) {
    setState(() {
      _currentBottomSheet = type;
      _showSearchResults = false;
    });
  }

  // Simulate finding driver
  void _simulateFindingDriver() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _currentBottomSheet == BottomSheetType.findingDriver) {
        setState(() {
          _currentBottomSheet = BottomSheetType.driverArriving;
        });
        _simulateDriverArrival();
      }
    });
  }

  // Simulate driver arrival to trip start
  void _simulateDriverArrival() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && _currentBottomSheet == BottomSheetType.driverArriving) {
        setState(() {
          _currentBottomSheet = BottomSheetType.tripProgress;
        });
        _simulateTripCompletion();
      }
    });
  }

  // Simulate trip completion
  void _simulateTripCompletion() {
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted && _currentBottomSheet == BottomSheetType.tripProgress) {
        setState(() {
          _currentBottomSheet = BottomSheetType.destinationReached;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const MAppBar(
        title: 'Ride Booking',
        showBackButton: true,
      ),
      body: Stack(
        children: [
          // Google Map
          _isLoading
              ? const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          )
              : GoogleMap(
            style: lightMapTheme, // Use style parameter instead of setMapStyle
            initialCameraPosition: CameraPosition(
              target: _currentPosition,
              zoom: 14.0,
            ),
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
              // Removed deprecated setMapStyle call
            },
            markers: _markers,
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            compassEnabled: false,
            onTap: _onMapTapped,
          ),

          // Bottom Sheet - Dynamic based on current state
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildCurrentBottomSheet(),
          ),

          // My Location Button
          if (_currentBottomSheet == BottomSheetType.pickup ||
              _currentBottomSheet == BottomSheetType.destination)
            Positioned(
              right: 16,
              top: 20,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.my_location,
                    color: AppColors.black,
                    size: 20,
                  ),
                  onPressed: () async {
                    await _mapController!.animateCamera(
                      CameraUpdate.newLatLngZoom(_currentPosition, 12),
                    );

                    // Small delay for effect
                    await Future.delayed(Duration(milliseconds: 300));

                    // Zoom back in
                    await _mapController!.animateCamera(
                      CameraUpdate.newLatLngZoom(_currentPosition, 14),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Add this method to your _RideBookingScreenState class

  Widget _buildCurrentBottomSheet() {
    switch (_currentBottomSheet) {
      case BottomSheetType.driverArriving:
        return HeadingToPickupBottomSheet(
          driverName: 'Marvin McKinney',
          driverImage: 'assets/images/profile_user.png',
          pickupAddress: _pickupAddress ?? 'Maryland bustop, Anthony Ikeja',
          dropAddress: _destinationAddress ?? '6391 Elgin St, Celina, Delaware 10299',
          approximatePrice: '\$54',
          estimatedTime: '2 mins',
          onReachedDestination: () {
            setState(() {
              _currentBottomSheet = BottomSheetType.tripProgress;
            });
          },
          onCall: () {
            print('Calling driver...');
            // Add call functionality
          },
          onMessage: () {
            print('Messaging driver...');
            // Add message functionality
          },
        );

      case BottomSheetType.tripProgress:
        return PickupLocationBottomSheet(
          driverName: 'Marvin McKinney',
          driverImage: 'assets/images/profile_user.png',
          pickupAddress: _pickupAddress ?? 'Maryland bustop, Anthony Ikeja',
          dropAddress: _destinationAddress ?? '6391 Elgin St, Celina, Delaware 10299',
          approximatePrice: '\$54',
          estimatedTime: '2 mins',
          onReachedDestination: () {
            setState(() {
              _currentBottomSheet = BottomSheetType.destinationReached;
            });
          },
          onCall: () {
            print('Calling driver...');
            // Add call functionality
          },
          onMessage: () {
            print('Messaging driver...');
            // Add message functionality
          },
        );

      case BottomSheetType.destinationReached:
        return RideCompletedBottomSheet(
          onRateRider: () {
            print('Rate rider');
            // Navigate to rating screen
            Navigator.pop(context);
          },
          onSkip: () {
            print('Skipped rating');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DeliveryReceiptScreen(
                  driverName: 'Marvin McKinney',
                  driverImage: 'assets/images/profile_user.png',
                  trackingId: 'UD32499983',
                  fromAddress: '1213 Washington Blvd, Belpre, OH',
                  toAddress: '121 Pike St, Marietta, OH',
                  date: '2 Sep, 2023',
                  time: '12:00 am',
                  rating: 4.0,
                  reviewText: 'Great customer! The passenger was punctual, polite, and respectful throughout the trip. Communication was smooth and pleasant. Highly recommend for future rides. Would definitely drive again. Thank you!"',
                  baseFare: 10,
                  distanceCharges: 40,
                  serviceFees: 10,
                  gasSurcharges: 10,
                  totalCost: 330,
                  isDelivered: true,
                ),
              ),
            );
          },
        );

      default:
        return Container(); // Return your existing bottom sheets for other states
    }
  }
}