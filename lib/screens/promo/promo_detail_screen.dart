import 'package:flutter/material.dart';
import '../../themes/app_theme.dart';

class PromoDetailScreen extends StatelessWidget {
  const PromoDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail Promo',
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
        padding: AppTheme.defaultPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: AppTheme.defaultPadding,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primaryColor, Colors.lightBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Promo Spesial!',
                    style: AppTheme.headingStyle.copyWith(
                      color: AppTheme.whiteColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Dapatkan diskon 50% untuk pesanan pertama',
                    style: AppTheme.bodyTextStyle.copyWith(
                      color: AppTheme.whiteColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: AppTheme.whiteColor,
                        size: AppTheme.smallIconSize,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Berlaku hingga 31 Desember 2024',
                        style: AppTheme.bodyTextStyle.copyWith(
                          color: AppTheme.whiteColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Syarat dan Ketentuan',
              style: AppTheme.subheadingStyle,
            ),
            const SizedBox(height: 16),
            _buildTermItem(
              '1. Promo hanya berlaku untuk pengguna baru',
            ),
            _buildTermItem(
              '2. Minimal pembelian Rp 50.000',
            ),
            _buildTermItem(
              '3. Maksimal diskon Rp 25.000',
            ),
            _buildTermItem(
              '4. Tidak dapat digabungkan dengan promo lain',
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: AppTheme.whiteColor,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Gunakan Promo',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            color: AppTheme.primaryColor,
            size: AppTheme.smallIconSize,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppTheme.bodyTextStyle.copyWith(
                fontSize: 14,
                color: AppTheme.blackColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 