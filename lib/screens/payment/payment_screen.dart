import 'package:flutter/material.dart';
import '../../models/order_model.dart';
import '../../themes/app_theme.dart';

class PaymentScreen extends StatelessWidget {
  final OrderModel order;

  const PaymentScreen({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'Pembayaran',
          style: AppTheme.appBarTitleStyle.copyWith(
            color: AppTheme.blackColor,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppTheme.whiteColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.blackColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Order Summary
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: AppTheme.defaultPadding,
              decoration: BoxDecoration(
                color: AppTheme.whiteColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ringkasan Pesanan',
                    style: AppTheme.subheadingStyle,
                  ),
                  const SizedBox(height: 16),
                  _buildOrderDetailRow(
                    Icons.location_on,
                    'Lokasi Penjemputan',
                    order.pickupLocation,
                  ),
                  const SizedBox(height: 12),
                  _buildOrderDetailRow(
                    Icons.flag,
                    'Tujuan',
                    order.destinationLocation,
                  ),
                  const SizedBox(height: 12),
                  _buildOrderDetailRow(
                    Icons.attach_money,
                    'Total Biaya',
                    'Rp ${order.price.toStringAsFixed(0)}',
                  ),
                ],
              ),
            ),
            // Payment Methods
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: AppTheme.defaultPadding,
              decoration: BoxDecoration(
                color: AppTheme.whiteColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Metode Pembayaran',
                    style: AppTheme.subheadingStyle,
                  ),
                  const SizedBox(height: 16),
                  _buildPaymentMethod(
                    'Gopay',
                    'assets/images/gopay.png',
                    isSelected: true,
                  ),
                  const Divider(height: 24),
                  _buildPaymentMethod(
                    'OVO',
                    'assets/images/ovo.png',
                    isSelected: false,
                  ),
                  const Divider(height: 24),
                  _buildPaymentMethod(
                    'Dana',
                    'assets/images/dana.png',
                    isSelected: false,
                  ),
                  const Divider(height: 24),
                  _buildPaymentMethod(
                    'Bank Transfer',
                    'assets/images/bank.png',
                    isSelected: false,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Pay Button
            Padding(
              padding: AppTheme.defaultPadding,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Handle payment
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: AppTheme.whiteColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  'Bayar Sekarang',
                  style: AppTheme.buttonTextStyle,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppTheme.primaryColor,
          size: AppTheme.smallIconSize,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTheme.bodyTextStyle.copyWith(
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: AppTheme.subheadingStyle.copyWith(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethod(String name, String iconPath, {required bool isSelected}) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.whiteColor,
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: AssetImage(iconPath),
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            name,
            style: AppTheme.subheadingStyle.copyWith(
              fontSize: 16,
            ),
          ),
        ),
        if (isSelected)
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check,
              color: AppTheme.whiteColor,
              size: AppTheme.smallIconSize,
            ),
          ),
      ],
    );
  }
} 