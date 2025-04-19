import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../models/order_model.dart';
import '../../models/service_model.dart';
import '../../themes/app_theme.dart';
import 'waiting_driver_screen.dart';

class OrderSummaryScreen extends StatelessWidget {
  final ServiceModel service;
  final String pickupAddress;
  final String destinationAddress;
  final double distance;
  final int estimatedTime;
  final double estimatedPrice;
  final String selectedPaymentMethod;
  final String selectedDriverType;
  final LatLng pickupLocation;
  final LatLng destinationLocation;

  const OrderSummaryScreen({
    super.key,
    required this.service,
    required this.pickupAddress,
    required this.destinationAddress,
    required this.distance,
    required this.estimatedTime,
    required this.estimatedPrice,
    required this.selectedPaymentMethod,
    required this.selectedDriverType,
    required this.pickupLocation,
    required this.destinationLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Ringkasan Pesanan',
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
          // Content
          SingleChildScrollView(
            padding: EdgeInsets.only(
              top: 16,
              bottom: MediaQuery.of(context).padding.bottom + 80,
            ),
            child: Padding(
              padding: AppTheme.defaultPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Locations
                  Container(
                    padding: AppTheme.defaultPadding,
                    decoration: AppTheme.cardDecoration,
                    child: Column(
                      children: [
                        // Pickup Location
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.pin_drop, color: AppTheme.primaryColor, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Lokasi Jemput',
                                    style: AppTheme.searchTitleTextStyle,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    pickupAddress,
                                    style: AppTheme.searchTextStyle,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Destination Location
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.location_on, color: AppTheme.primaryColor, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Lokasi Tujuan',
                                    style: AppTheme.searchTitleTextStyle,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    destinationAddress,
                                    style: AppTheme.searchTextStyle,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Trip Details
                  _buildTripDetailsSection(),
                  const SizedBox(height: 24),
                  // Payment Method
                  _buildPaymentMethodSection(),
                  const SizedBox(height: 24),
                  // Driver Type
                  _buildDriverTypeSection(),
                ],
              ),
            ),
          ),
          // Confirm Button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 16,
                left: 16,
                right: 16,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () => _handleOrderConfirmation(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Konfirmasi Pesanan',
                  style: AppTheme.buttonTextStyle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleOrderConfirmation(BuildContext context) {
    switch (selectedDriverType) {
      case 'Gatcor System':
        // Send order to system and wait for driver
        _sendOrderAndWait(context);
        break;
      case 'QR Tap':
        // Show QR code scanner
        _showQRScanner(context);
        break;
      case 'My Favorite Driver':
        // Show favorite drivers list
        _showFavoriteDrivers(context);
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pilih tipe driver terlebih dahulu')),
        );
    }
  }

  void _sendOrderAndWait(BuildContext context) {
    // Create order
    final order = OrderModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'current_user_id', // TODO: Get from auth
      driverId: '',
      pickupLocation: pickupAddress,
      destinationLocation: destinationAddress,
      pickupLat: pickupLocation.latitude,
      pickupLng: pickupLocation.longitude,
      destinationLat: destinationLocation.latitude,
      destinationLng: destinationLocation.longitude,
      status: 'waiting',
      price: estimatedPrice,
      createdAt: DateTime.now(),
    );

    // TODO: Send order to backend
    // For now, just navigate to waiting screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => WaitingDriverScreen(order: order),
      ),
    );
  }

  void _showQRScanner(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Scan QR Code Driver'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 200,
              width: 200,
              color: Colors.grey.shade200,
              child: const Center(
                child: Text('QR Scanner Placeholder'),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _sendOrderAndWait(context);
              },
              child: const Text('Scan QR Code'),
            ),
          ],
        ),
      ),
    );
  }

  void _showFavoriteDrivers(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pilih Driver Favorit'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: 3, // Placeholder count
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                  child: const Icon(Icons.person, color: AppTheme.primaryColor),
                ),
                title: Text('Driver ${index + 1}'),
                subtitle: const Text('4.8 ★'),
                onTap: () {
                  Navigator.pop(context);
                  _sendOrderAndWait(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTripDetailsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTripDetailRow(
            'Jarak',
            '${distance.toStringAsFixed(1)} km',
            Icons.directions_car,
          ),
          const SizedBox(height: 12),
          _buildTripDetailRow(
            'Estimasi Waktu',
            '$estimatedTime menit',
            Icons.timer,
          ),
          const SizedBox(height: 12),
          _buildTripDetailRow(
            'Total Biaya',
            'Rp ${estimatedPrice.toStringAsFixed(0)}',
            Icons.attach_money,
            isPrice: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTripDetailRow(String label, String value, IconData icon, {bool isPrice = false}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppTheme.primaryColor, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: isPrice ? AppTheme.primaryColor : Colors.grey.shade800,
                  fontWeight: isPrice ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getPaymentIcon(selectedPaymentMethod),
              color: AppTheme.primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Metode Pembayaran',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  selectedPaymentMethod,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverTypeSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getDriverTypeIcon(selectedDriverType),
              color: AppTheme.primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tipe Driver',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  selectedDriverType,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getPaymentIcon(String method) {
    switch (method) {
      case 'Cash':
        return Icons.money;
      case 'E-Wallet':
        return Icons.wallet;
      case 'Bank Transfer':
        return Icons.account_balance;
      default:
        return Icons.payment;
    }
  }

  IconData _getDriverTypeIcon(String type) {
    switch (type) {
      case 'Gatcor System':
        return Icons.auto_awesome;
      case 'QR Tap':
        return Icons.qr_code;
      case 'My Favorite Driver':
        return Icons.favorite;
      default:
        return Icons.person;
    }
  }
} 