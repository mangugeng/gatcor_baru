import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../models/order_model.dart';
import '../../models/driver_model.dart';
import '../chat/chat_screen.dart';
import '../rating/rating_screen.dart';
import '../../themes/app_theme.dart';
import 'dart:async';

class TripStatusScreen extends StatefulWidget {
  final OrderModel order;
  final String driverName;
  final LatLng pickupLocation;
  final LatLng destinationLocation;
  final LatLng driverLocation;

  const TripStatusScreen({
    super.key,
    required this.order,
    required this.driverName,
    required this.pickupLocation,
    required this.destinationLocation,
    required this.driverLocation,
  });

  @override
  State<TripStatusScreen> createState() => _TripStatusScreenState();
}

class _TripStatusScreenState extends State<TripStatusScreen> {
  late GoogleMapController _mapController;
  late Timer _timer;
  bool _isSharingLocation = false;
  LatLng _currentDriverLocation = const LatLng(0, 0);
  int _secondsRemaining = 60; // 1 menit

  @override
  void initState() {
    super.initState();
    _currentDriverLocation = widget.driverLocation;
    _startLocationUpdates();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer.cancel();
          _navigateToRatingScreen();
        }
      });
    });
  }

  void _startLocationUpdates() {
    Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) {
        setState(() {
          // Simulasi pergerakan driver menuju tujuan dengan kecepatan lebih cepat
          _currentDriverLocation = LatLng(
            _currentDriverLocation.latitude + 0.0005, // Meningkatkan kecepatan pergerakan
            _currentDriverLocation.longitude + 0.0005,
          );
        });
      }
    });
  }

  void _navigateToRatingScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => RatingScreen(
          order: widget.order,
          driverName: widget.driverName,
        ),
      ),
    );
  }

  void _showEmergencyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Panggilan Darurat'),
        content: const Text('Apakah Anda yakin ingin menghubungi layanan darurat?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Handle emergency call
            },
            child: const Text(
              'Hubungi',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'Trip Status',
          style: AppTheme.appBarTitleStyle,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: AppTheme.whiteColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // Map
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentDriverLocation,
              zoom: 15,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
            },
            markers: {
              Marker(
                markerId: const MarkerId('driver'),
                position: _currentDriverLocation,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueBlue,
                ),
              ),
              Marker(
                markerId: const MarkerId('pickup'),
                position: widget.pickupLocation,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen,
                ),
              ),
              Marker(
                markerId: const MarkerId('destination'),
                position: widget.destinationLocation,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed,
                ),
              ),
            },
            polylines: {
              Polyline(
                polylineId: const PolylineId('route'),
                points: [
                  _currentDriverLocation,
                  widget.destinationLocation,
                ],
                color: AppTheme.primaryColor,
                width: 5,
              ),
            },
          ),
          // Info Card
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: AppTheme.defaultPadding,
              decoration: AppTheme.cardDecoration,
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          image: const DecorationImage(
                            image: AssetImage('assets/images/driver_avatar.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.driverName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.blackColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Toyota Avanza • B 1234 ABC',
                              style: TextStyle(
                                color: AppTheme.greyColor,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _isSharingLocation
                              ? Icons.location_on
                              : Icons.location_off,
                          color: _isSharingLocation
                              ? AppTheme.primaryColor
                              : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _isSharingLocation = !_isSharingLocation;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // ETA Progress
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Estimasi Tiba',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: 1 - (_secondsRemaining / 60),
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatTime(_secondsRemaining),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            '0:00',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                  driverName: widget.driverName,
                                  order: widget.order,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                          ),
                          icon: const Icon(Icons.chat),
                          label: const Text('Chat'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _showEmergencyDialog,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade50,
                            foregroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: const Icon(Icons.emergency),
                          label: const Text('Darurat'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 