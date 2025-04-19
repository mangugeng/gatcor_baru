import 'package:flutter/material.dart';
import '../../themes/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'Profil',
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
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: AppTheme.blackColor),
            onPressed: () {
              // TODO: Navigate to settings
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: AppTheme.defaultPadding,
              decoration: BoxDecoration(
                color: AppTheme.whiteColor,
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
                  Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          image: const DecorationImage(
                            image: AssetImage('assets/images/user_avatar.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppTheme.whiteColor,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            color: AppTheme.whiteColor,
                            size: AppTheme.smallIconSize,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Mang Ugeng',
                    style: AppTheme.headingStyle,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'test3@example.com',
                    style: AppTheme.bodyTextStyle,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStatItem('Pesanan', '12'),
                      const SizedBox(width: 32),
                      _buildStatItem('Rating', '4.8'),
                      const SizedBox(width: 32),
                      _buildStatItem('Poin', '120'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Menu Items
            Padding(
              padding: AppTheme.defaultPadding,
              child: Column(
                children: [
                  _buildMenuItem(
                    icon: Icons.history,
                    title: 'Riwayat Pesanan',
                    subtitle: 'Lihat semua pesanan Anda',
                    onTap: () {
                      // TODO: Navigate to order history
                    },
                  ),
                  const Divider(height: 1),
                  _buildMenuItem(
                    icon: Icons.payment,
                    title: 'Metode Pembayaran',
                    subtitle: 'Kelola kartu dan pembayaran',
                    onTap: () {
                      // TODO: Navigate to payment methods
                    },
                  ),
                  const Divider(height: 1),
                  _buildMenuItem(
                    icon: Icons.location_on,
                    title: 'Alamat Saya',
                    subtitle: 'Kelola alamat pengiriman',
                    onTap: () {
                      // TODO: Navigate to addresses
                    },
                  ),
                  const Divider(height: 1),
                  _buildMenuItem(
                    icon: Icons.favorite,
                    title: 'Driver Favorit',
                    subtitle: 'Lihat driver yang sering dipilih',
                    onTap: () {
                      // TODO: Navigate to favorite drivers
                    },
                  ),
                  const Divider(height: 1),
                  _buildMenuItem(
                    icon: Icons.help,
                    title: 'Bantuan',
                    subtitle: 'Pusat bantuan dan FAQ',
                    onTap: () {
                      // TODO: Navigate to help
                    },
                  ),
                  const Divider(height: 1),
                  _buildMenuItem(
                    icon: Icons.info,
                    title: 'Tentang Aplikasi',
                    subtitle: 'Versi 1.0.0',
                    onTap: () {
                      // TODO: Navigate to about
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Logout Button
            Padding(
              padding: AppTheme.defaultPadding,
              child: ElevatedButton(
                onPressed: () {
                  _showLogoutDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade50,
                  foregroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.logout),
                    const SizedBox(width: 8),
                    Text(
                      'Keluar',
                      style: AppTheme.buttonTextStyle.copyWith(
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTheme.headingStyle.copyWith(
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTheme.bodyTextStyle.copyWith(
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: AppTheme.primaryColor,
        ),
      ),
      title: Text(
        title,
        style: AppTheme.subheadingStyle.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTheme.bodyTextStyle.copyWith(
          fontSize: 12,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: AppTheme.greyColor,
      ),
      onTap: onTap,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Keluar',
          style: AppTheme.subheadingStyle,
        ),
        content: Text(
          'Apakah Anda yakin ingin keluar?',
          style: AppTheme.bodyTextStyle,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: AppTheme.bodyTextStyle,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Handle logout
            },
            child: Text(
              'Keluar',
              style: AppTheme.bodyTextStyle.copyWith(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 