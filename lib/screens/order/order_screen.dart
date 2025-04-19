import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/service_model.dart';
import '../../models/order_model.dart';
import '../location/location_search_screen.dart';
import '../payment/payment_screen.dart';
import '../chat/chat_screen.dart';
import 'trip_status_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../themes/app_theme.dart';
import 'dart:async';
import 'order_summary_screen.dart';
import '../../models/driver_model.dart';

class OrderScreen extends StatefulWidget {
  final ServiceModel service;
  final String? initialDestination;
  final double? initialLat;
  final double? initialLng;

  const OrderScreen({
    super.key,
    required this.service,
    this.initialDestination,
    this.initialLat,
    this.initialLng,
  });

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  GoogleMapController? mapController;
  Position? currentPosition;
  final Set<Marker> markers = {};
  final Set<Polyline> polylines = {};
  final TextEditingController pickupController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  String? pickupAddress;
  String? destinationAddress;
  double? distance;
  int? estimatedTime;
  double? estimatedPrice;
  final String apiKey = 'AIzaSyDJdqPbGuQVGHFbHDydMJF1pkHBaAJPdQg';
  List<Map<String, dynamic>> searchResults = [];
  bool showSearchResults = false;
  bool isCalculating = false;
  bool isPickupSearch = true;
  String? selectedDriverType;
  String? selectedPaymentMethod;
  final List<String> driverTypes = ['By System', 'QR Code', 'Driver Favorite'];
  final List<String> paymentMethods = ['Cash', 'E-Wallet', 'Bank Transfer'];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _loadPickupLocation();
    if (widget.initialDestination != null &&
        widget.initialLat != null &&
        widget.initialLng != null) {
      setState(() {
        destinationAddress = widget.initialDestination;
        destinationController.text = widget.initialDestination!;
        markers.add(
          Marker(
            markerId: const MarkerId('destination'),
            position: LatLng(widget.initialLat!, widget.initialLng!),
            infoWindow: InfoWindow(title: 'Lokasi Tujuan'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRed),
          ),
        );
      });
      // Calculate route after destination is set
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _calculateRoute();
      });
    }
    // Add initial marker for Bandung
    markers.add(
      Marker(
        markerId: const MarkerId('bandung'),
        position: const LatLng(-6.9147, 107.6098),
        infoWindow: const InfoWindow(title: 'Bandung'),
      ),
    );
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lokasi tidak aktif')),
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Izin lokasi ditolak')),
          );
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition();
      setState(() {
        currentPosition = position;
        markers.add(
          Marker(
            markerId: const MarkerId('current_location'),
            position: LatLng(position.latitude, position.longitude),
            infoWindow: const InfoWindow(title: 'Lokasi Saya'),
          ),
        );
      });

      if (mapController != null) {
        mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 15,
            ),
          ),
        );
      }
    } catch (e) {
      print('Error getting location: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _loadPickupLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final pickupAddress = prefs.getString('pickup_address');
    final pickupLat = prefs.getDouble('pickup_lat');
    final pickupLng = prefs.getDouble('pickup_lng');

    if (pickupAddress != null && pickupLat != null && pickupLng != null) {
      setState(() {
        this.pickupAddress = pickupAddress;
        pickupController.text = pickupAddress;
        markers.add(
          Marker(
            markerId: const MarkerId('pickup'),
            position: LatLng(pickupLat, pickupLng),
            infoWindow: InfoWindow(title: 'Lokasi Jemput'),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen),
          ),
        );
      });

      // Jika sudah ada lokasi jemput dan tujuan, hitung rute
      if (widget.initialDestination != null &&
          widget.initialLat != null &&
          widget.initialLng != null) {
        _calculateRoute();
      }
    }
  }

  Future<void> _searchPlace(String query, bool isPickup) async {
    if (query.isEmpty) {
      setState(() {
        showSearchResults = false;
        searchResults.clear();
      });
      return;
    }

    setState(() {
      isPickupSearch = isPickup;
    });

    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/autocomplete/json?'
      'input=$query&key=$apiKey&components=country:id',
    );

    try {
      final response = await http.get(url);
      final data = json.decode(response.body);

      if (data['status'] == 'OK' && data['predictions'] != null) {
        setState(() {
          searchResults = List<Map<String, dynamic>>.from(data['predictions']);
          showSearchResults = true;
        });
      } else {
        setState(() {
          showSearchResults = false;
          searchResults.clear();
        });
      }
    } catch (e) {
      print('Error searching place: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _selectPlace(String placeId, bool isPickup) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/details/json?'
      'place_id=$placeId&key=$apiKey',
    );

    try {
      final response = await http.get(url);
      final data = json.decode(response.body);

      if (data['status'] == 'OK' && data['result'] != null) {
        final place = data['result'];
        final location = place['geometry']['location'];
        final lat = location['lat'];
        final lng = location['lng'];
        final address = place['formatted_address'];

        setState(() {
          if (isPickup) {
            pickupAddress = address;
            pickupController.text = address;
            markers.removeWhere((m) => m.markerId.value == 'pickup');
            markers.add(
              Marker(
                markerId: const MarkerId('pickup'),
                position: LatLng(lat, lng),
                infoWindow: InfoWindow(title: 'Lokasi Jemput'),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueGreen),
              ),
            );
          } else {
            destinationAddress = address;
            destinationController.text = address;
            markers.removeWhere((m) => m.markerId.value == 'destination');
            markers.add(
              Marker(
                markerId: const MarkerId('destination'),
                position: LatLng(lat, lng),
                infoWindow: InfoWindow(title: 'Lokasi Tujuan'),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRed),
              ),
            );
          }
          showSearchResults = false;
          searchResults.clear();
        });

        mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(LatLng(lat, lng), 15),
        );
      }
    } catch (e) {
      print('Error selecting place: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _useMyLocation() async {
    if (currentPosition != null) {
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?'
        'latlng=${currentPosition!.latitude},${currentPosition!.longitude}&key=$apiKey',
      );

      try {
        final response = await http.get(url);
        final data = json.decode(response.body);

        if (data['status'] == 'OK' &&
            data['results'] != null &&
            data['results'].isNotEmpty) {
          final address = data['results'][0]['formatted_address'];

          setState(() {
            pickupAddress = address;
            pickupController.text = address;
            markers.removeWhere((m) => m.markerId.value == 'pickup');
            markers.add(
              Marker(
                markerId: const MarkerId('pickup'),
                position: LatLng(
                    currentPosition!.latitude, currentPosition!.longitude),
                infoWindow: InfoWindow(title: 'Lokasi Jemput'),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueGreen),
              ),
            );
          });
        }
      } catch (e) {
        print('Error getting address: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _calculateRoute() async {
    if (pickupAddress == null || destinationAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih lokasi jemput dan tujuan')),
      );
      return;
    }

    setState(() {
      isCalculating = true;
    });

    try {
      final pickup = markers.firstWhere((m) => m.markerId.value == 'pickup');
      final destination =
          markers.firstWhere((m) => m.markerId.value == 'destination');

      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?'
        'origin=${pickup.position.latitude},${pickup.position.longitude}'
        '&destination=${destination.position.latitude},${destination.position.longitude}'
        '&key=$apiKey',
      );

      final response = await http.get(url);
      final data = json.decode(response.body);

      if (data['status'] == 'OK' &&
          data['routes'] != null &&
          data['routes'].isNotEmpty) {
        final route = data['routes'][0];
        final leg = route['legs'][0];
        final steps = leg['steps'];

        List<LatLng> polylineCoordinates = [];
        for (var step in steps) {
          final startLat = step['start_location']['lat'];
          final startLng = step['start_location']['lng'];
          final endLat = step['end_location']['lat'];
          final endLng = step['end_location']['lng'];

          polylineCoordinates.add(LatLng(startLat, startLng));
          polylineCoordinates.add(LatLng(endLat, endLng));
        }

        setState(() {
          polylines.clear();
          polylines.add(
            Polyline(
              polylineId: const PolylineId('route'),
              points: polylineCoordinates,
              color: AppTheme.primaryColor,
              width: 5,
            ),
          );

          distance = leg['distance']['value'] / 1000;
          estimatedTime = (leg['duration']['value'] / 60).round();
          estimatedPrice = _calculatePrice(distance!);
          isCalculating = false;
        });

        LatLngBounds bounds = LatLngBounds(
          southwest: LatLng(
            route['bounds']['southwest']['lat'],
            route['bounds']['southwest']['lng'],
          ),
          northeast: LatLng(
            route['bounds']['northeast']['lat'],
            route['bounds']['northeast']['lng'],
          ),
        );
        mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
      } else {
        setState(() {
          isCalculating = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak dapat menemukan rute')),
        );
      }
    } catch (e) {
      setState(() {
        isCalculating = false;
      });
      print('Error calculating route: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  double _calculatePrice(double distance) {
    double basePrice = 10000;
    double pricePerKm = 5000;
    double minDistance = 1.0;

    if (distance < minDistance) {
      return basePrice;
    }

    return basePrice + (distance * pricePerKm);
  }

  Future<void> _selectLocationFromMap(LatLng position, bool isPickup) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?'
      'latlng=${position.latitude},${position.longitude}&key=$apiKey',
    );

    try {
      final response = await http.get(url);
      final data = json.decode(response.body);

      if (data['status'] == 'OK' &&
          data['results'] != null &&
          data['results'].isNotEmpty) {
        final address = data['results'][0]['formatted_address'];

        setState(() {
          if (isPickup) {
            pickupAddress = address;
            pickupController.text = address;
            markers.removeWhere((m) => m.markerId.value == 'pickup');
            markers.add(
              Marker(
                markerId: const MarkerId('pickup'),
                position: position,
                infoWindow: InfoWindow(title: 'Lokasi Jemput'),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueGreen),
              ),
            );
          } else {
            destinationAddress = address;
            destinationController.text = address;
            markers.removeWhere((m) => m.markerId.value == 'destination');
            markers.add(
              Marker(
                markerId: const MarkerId('destination'),
                position: position,
                infoWindow: InfoWindow(title: 'Lokasi Tujuan'),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRed),
              ),
            );
          }
        });

        mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(position, 15),
        );
      }
    } catch (e) {
      print('Error getting address: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _showDriverSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Pilih Driver'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: driverTypes.map((type) => RadioListTile(
            title: Text(type),
            value: type,
            groupValue: selectedDriverType,
            onChanged: (value) {
              setState(() {
                selectedDriverType = value;
              });
              Navigator.pop(context);
              _showPaymentSelectionDialog();
            },
          )).toList(),
        ),
      ),
    );
  }

  void _showPaymentSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Pilih Metode Pembayaran'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: paymentMethods.map((method) => RadioListTile(
            title: Text(method),
            value: method,
            groupValue: selectedPaymentMethod,
            onChanged: (value) {
              setState(() {
                selectedPaymentMethod = value;
              });
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentScreen(
                    order: OrderModel(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      service: widget.service,
                      pickupLocation: pickupAddress!,
                      destination: destinationAddress!,
                      distance: distance!,
                      estimatedTime: estimatedTime!,
                      price: estimatedPrice!,
                      status: 'pending',
                      createdAt: DateTime.now(),
                      driverType: selectedDriverType!,
                      paymentMethod: selectedPaymentMethod!,
                      pickupLat: markers.firstWhere((m) => m.markerId.value == 'pickup').position.latitude,
                      pickupLng: markers.firstWhere((m) => m.markerId.value == 'pickup').position.longitude,
                      destLat: markers.firstWhere((m) => m.markerId.value == 'destination').position.latitude,
                      destLng: markers.firstWhere((m) => m.markerId.value == 'destination').position.longitude,
                      driverId: null,
                      promoCode: null,
                      discount: null,
                    ),
                  ),
                ),
              );
            },
          )).toList(),
        ),
      ),
    );
  }

  void _navigateToSearchScreen() {
    // TODO: Implement navigation to search screen
  }

  void _showOrderSummaryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.receipt_long, color: AppTheme.primaryColor),
            const SizedBox(width: 8),
            Text(
              'Ringkasan Pesanan',
              style: TextStyle(
                color: Colors.grey.shade800,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pickup Location
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.pin_drop, color: AppTheme.primaryColor, size: 16),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    pickupAddress ?? '-',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Destination Location
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.location_on, color: AppTheme.primaryColor, size: 16),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    destinationAddress ?? '-',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Trip Details
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Jarak',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        distance != null ? '${distance!.toStringAsFixed(1)} km' : '-',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade800,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Estimasi Waktu',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        estimatedTime != null ? '$estimatedTime menit' : '-',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade800,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Metode Pembayaran',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        selectedPaymentMethod ?? '-',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade800,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Total Price
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Biaya',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    estimatedPrice != null ? 'Rp ${estimatedPrice!.toStringAsFixed(0)}' : '-',
                    style: const TextStyle(
                      fontSize: 18,
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentScreen(
                    order: OrderModel(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      service: widget.service,
                      pickupLocation: pickupAddress!,
                      destination: destinationAddress!,
                      distance: distance!,
                      estimatedTime: estimatedTime!,
                      price: estimatedPrice!,
                      status: 'pending',
                      createdAt: DateTime.now(),
                      driverType: selectedDriverType!,
                      paymentMethod: selectedPaymentMethod!,
                      pickupLat: markers.firstWhere((m) => m.markerId.value == 'pickup').position.latitude,
                      pickupLng: markers.firstWhere((m) => m.markerId.value == 'pickup').position.longitude,
                      destLat: markers.firstWhere((m) => m.markerId.value == 'destination').position.latitude,
                      destLng: markers.firstWhere((m) => m.markerId.value == 'destination').position.longitude,
                      driverId: null,
                      promoCode: null,
                      discount: null,
                    ),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Konfirmasi'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Full Screen Map
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(-6.9147, 107.6098),
              zoom: 12,
            ),
            markers: markers,
            polylines: polylines,
            onMapCreated: (GoogleMapController controller) {
              setState(() {
                mapController = controller;
              });
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
          ),

          // Back Button
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),
          ),

          // Location Indicators
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            right: 16,
            child: Column(
              children: [
                // Pickup Location
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.pin_drop, color: AppTheme.primaryColor, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          pickupAddress ?? 'Mendeteksi lokasi...',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade800,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Destination Location
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on, color: AppTheme.primaryColor, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          destinationAddress ?? 'Pilih tujuan',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade800,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom Sheet
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: AppTheme.defaultPadding,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Price and Distance Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.directions_car, color: AppTheme.primaryColor, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  distance != null ? '${distance!.toStringAsFixed(1)} km' : '-',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.timer, color: AppTheme.primaryColor, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  estimatedTime != null ? '$estimatedTime menit' : '-',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppTheme.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          estimatedPrice != null ? 'Rp ${estimatedPrice!.toStringAsFixed(0)}' : '-',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Payment Method Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Metode Pembayaran',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            // Cash
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: selectedPaymentMethod == 'Cash' ? Colors.white.withOpacity(0.2) : AppTheme.primaryColor.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.money, size: 14),
                                    ),
                                    const SizedBox(width: 4),
                                    const Text('Cash', style: TextStyle(fontSize: 10)),
                                  ],
                                ),
                                selected: selectedPaymentMethod == 'Cash',
                                onSelected: (selected) {
                                  setState(() {
                                    selectedPaymentMethod = selected ? 'Cash' : null;
                                  });
                                },
                                backgroundColor: Colors.grey.shade100,
                                selectedColor: AppTheme.primaryColor,
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                              ),
                            ),
                            // E-Wallet
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: selectedPaymentMethod == 'E-Wallet' ? Colors.white.withOpacity(0.2) : AppTheme.primaryColor.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.wallet, size: 14),
                                    ),
                                    const SizedBox(width: 4),
                                    const Text('E-Wallet', style: TextStyle(fontSize: 10)),
                                  ],
                                ),
                                selected: selectedPaymentMethod == 'E-Wallet',
                                onSelected: (selected) {
                                  setState(() {
                                    selectedPaymentMethod = selected ? 'E-Wallet' : null;
                                  });
                                },
                                backgroundColor: Colors.grey.shade100,
                                selectedColor: AppTheme.primaryColor,
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                              ),
                            ),
                            // Bank Transfer
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: selectedPaymentMethod == 'Bank Transfer' ? Colors.white.withOpacity(0.2) : AppTheme.primaryColor.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.account_balance, size: 14),
                                    ),
                                    const SizedBox(width: 4),
                                    const Text('Bank', style: TextStyle(fontSize: 10)),
                                  ],
                                ),
                                selected: selectedPaymentMethod == 'Bank Transfer',
                                onSelected: (selected) {
                                  setState(() {
                                    selectedPaymentMethod = selected ? 'Bank Transfer' : null;
                                  });
                                },
                                backgroundColor: Colors.grey.shade100,
                                selectedColor: AppTheme.primaryColor,
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Driver Selection Section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pilih Driver',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            // Gatcor System
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: selectedDriverType == 'Gatcor System' ? Colors.white.withOpacity(0.2) : AppTheme.primaryColor.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.auto_awesome, size: 14),
                                    ),
                                    const SizedBox(width: 4),
                                    const Text('Gatcor', style: TextStyle(fontSize: 10)),
                                  ],
                                ),
                                selected: selectedDriverType == 'Gatcor System',
                                onSelected: (selected) {
                                  setState(() {
                                    selectedDriverType = selected ? 'Gatcor System' : null;
                                  });
                                },
                                backgroundColor: Colors.grey.shade100,
                                selectedColor: AppTheme.primaryColor,
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                              ),
                            ),
                            // QR Tap
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: selectedDriverType == 'QR Tap' ? Colors.white.withOpacity(0.2) : AppTheme.primaryColor.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.qr_code, size: 14),
                                    ),
                                    const SizedBox(width: 4),
                                    const Text('QR Tap', style: TextStyle(fontSize: 10)),
                                  ],
                                ),
                                selected: selectedDriverType == 'QR Tap',
                                onSelected: (selected) {
                                  setState(() {
                                    selectedDriverType = selected ? 'QR Tap' : null;
                                  });
                                },
                                backgroundColor: Colors.grey.shade100,
                                selectedColor: AppTheme.primaryColor,
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                              ),
                            ),
                            // My Favorite Driver
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: selectedDriverType == 'My Favorite Driver' ? Colors.white.withOpacity(0.2) : AppTheme.primaryColor.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.favorite, size: 14),
                                    ),
                                    const SizedBox(width: 4),
                                    const Text('Favorit', style: TextStyle(fontSize: 10)),
                                  ],
                                ),
                                selected: selectedDriverType == 'My Favorite Driver',
                                onSelected: (selected) {
                                  setState(() {
                                    selectedDriverType = selected ? 'My Favorite Driver' : null;
                                  });
                                },
                                backgroundColor: Colors.grey.shade100,
                                selectedColor: AppTheme.primaryColor,
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Order Button
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).padding.bottom + 16,
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          if (selectedPaymentMethod == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Pilih metode pembayaran terlebih dahulu')),
                            );
                            return;
                          }
                          if (selectedDriverType == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Pilih tipe driver terlebih dahulu')),
                            );
                            return;
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderSummaryScreen(
                                service: widget.service,
                                pickupAddress: pickupAddress!,
                                destinationAddress: destinationAddress!,
                                distance: distance!,
                                estimatedTime: estimatedTime!,
                                estimatedPrice: estimatedPrice!,
                                selectedPaymentMethod: selectedPaymentMethod!,
                                selectedDriverType: selectedDriverType!,
                                pickupLocation: markers.firstWhere((m) => m.markerId.value == 'pickup').position,
                                destinationLocation: markers.firstWhere((m) => m.markerId.value == 'destination').position,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          padding: AppTheme.defaultPadding,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Pesan Sekarang',
                          style: AppTheme.buttonTextStyle,
                        ),
                      ),
                    ),
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