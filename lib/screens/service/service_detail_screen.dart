import 'package:flutter/material.dart';
import '../../models/service_model.dart';
import '../../themes/app_theme.dart';

class ServiceDetailScreen extends StatelessWidget {
  final ServiceModel service;

  const ServiceDetailScreen({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          service.name,
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              color: AppTheme.primaryColor.withOpacity(0.1),
              child: Center(
                child: Text(
                  service.icon,
                  style: const TextStyle(fontSize: 100),
                ),
              ),
            ),
            Padding(
              padding: AppTheme.defaultPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.name,
                    style: AppTheme.headingStyle,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    service.description,
                    style: AppTheme.bodyTextStyle,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Harga',
                    style: AppTheme.subheadingStyle,
                  ),
                  const SizedBox(height: 8),
                  _buildPriceInfo('Tarif Awal', 'Rp ${service.basePrice}'),
                  _buildPriceInfo('Per Kilometer', 'Rp ${service.pricePerKm}'),
                  _buildPriceInfo('Estimasi Waktu Tunggu', '5-10 menit'),
                  const SizedBox(height: 24),
                  Text(
                    'Fitur',
                    style: AppTheme.subheadingStyle,
                  ),
                  const SizedBox(height: 8),
                  _buildFeature('Driver berpengalaman'),
                  _buildFeature('Pembayaran cashless'),
                  _buildFeature('Lacak perjalanan real-time'),
                  _buildFeature('Asuransi perjalanan'),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Navigate to order screen
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: AppTheme.whiteColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Pesan Sekarang',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTheme.bodyTextStyle,
          ),
          Text(
            value,
            style: AppTheme.bodyTextStyle.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeature(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: AppTheme.successColor,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: AppTheme.bodyTextStyle,
          ),
        ],
      ),
    );
  }
} 