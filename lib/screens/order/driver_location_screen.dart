import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import '../../models/order_model.dart';
import '../../themes/app_theme.dart';
import 'trip_status_screen.dart';

class DriverLocationScreen extends StatefulWidget {
  final OrderModel order;
  final String driverName;
  final LatLng pickupLocation;
  final LatLng driverLocation;

  const DriverLocationScreen({
    super.key,
    required this.order,
    required this.driverName,
    required this.pickupLocation,
    required this.driverLocation,
  });

  @override
  State<DriverLocationScreen> createState() => _DriverLocationScreenState();
}

class _DriverLocationScreenState extends State<DriverLocationScreen> {
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  Timer? _locationUpdateTimer;
  LatLng _currentDriverLocation = const LatLng(0, 0);

  @override
  void initState() {
    super.initState();
    _currentDriverLocation = widget.driverLocation;
    _updateMapMarkers();
    _startLocationUpdates();
  }

  @override
  void dispose() {
    _locationUpdateTimer?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  void _startLocationUpdates() {
    // Simulate driver moving towards pickup location
    _locationUpdateTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) {
        setState(() {
          // Simulate driver moving closer to pickup location
          _currentDriverLocation = LatLng(
            _currentDriverLocation.latitude + 0.0001,
            _currentDriverLocation.longitude + 0.0001,
          );
          _updateMapMarkers();

          // Check if driver has arrived at pickup location
          final distance = _calculateDistance(_currentDriverLocation, widget.pickupLocation);
          if (distance < 0.0001) {
            timer.cancel();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => TripStatusScreen(
                  order: widget.order,
                  driverName: widget.driverName,
                  pickupLocation: widget.pickupLocation,
                  destinationLocation: const LatLng(-6.2088, 106.8456), // Example destination
                  driverLocation: _currentDriverLocation,
                ),
              ),
            );
          }
        });
      }
    });
  }

  double _calculateDistance(LatLng point1, LatLng point2) {
    final lat1 = point1.latitude;
    final lon1 = point1.longitude;
    final lat2 = point2.latitude;
    final lon2 = point2.longitude;

    final dLat = lat2 - lat1;
    final dLon = lon2 - lon1;

    return dLat * dLat + dLon * dLon;
  }

  void _updateMapMarkers() {
    _markers.clear();
    _polylines.clear();

    // Add pickup location marker
    _markers.add(
      Marker(
        markerId: const MarkerId('pickup'),
        position: widget.pickupLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: const InfoWindow(title: 'Lokasi Jemput'),
      ),
    );

    // Add driver location marker
    _markers.add(
      Marker(
        markerId: const MarkerId('driver'),
        position: _currentDriverLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: InfoWindow(title: 'Driver: ${widget.driverName}'),
      ),
    );

    // Add polyline between driver and pickup location
    _polylines.add(
      Polyline(
        polylineId: const PolylineId('route'),
        points: [_currentDriverLocation, widget.pickupLocation],
        color: AppTheme.primaryColor,
        width: 4,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'Driver Location',
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
              target: widget.pickupLocation,
              zoom: 15,
            ),
            markers: _markers,
            polylines: _polylines,
            onMapCreated: (controller) {
              _mapController = controller;
              _updateMapMarkers();
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
          ),
          // Top Info Card
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          image: const DecorationImage(
                            image: AssetImage('assets/images/driver_avatar.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.driverName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '4.8',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Estimasi Kedatangan',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '5 menit',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chat),
                            onPressed: () {
                              // TODO: Navigate to chat screen
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.phone),
                            onPressed: () {
                              // TODO: Call driver
                            },
                          ),
                        ],
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