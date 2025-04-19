import 'package:flutter/material.dart';
import '../../models/order_model.dart';
import '../../themes/app_theme.dart';
import 'driver_accepted_screen.dart';

class WaitingDriverScreen extends StatefulWidget {
  final OrderModel order;

  const WaitingDriverScreen({
    super.key,
    required this.order,
  });

  @override
  State<WaitingDriverScreen> createState() => _WaitingDriverScreenState();
}

class _WaitingDriverScreenState extends State<WaitingDriverScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isSimulating = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // Simulate driver acceptance after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && !_isSimulating) {
        _simulateDriverAcceptance();
      }
    });
  }

  void _simulateDriverAcceptance() {
    setState(() => _isSimulating = true);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DriverAcceptedScreen(order: widget.order),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showCancelDialog(BuildContext context) {
    final List<Map<String, dynamic>> reasons = [
      {
        'icon': Icons.timer_outlined,
        'text': 'Driver terlalu lama',
        'color': Colors.orange,
      },
      {
        'icon': Icons.person_outline,
        'text': 'Saya sudah menemukan driver lain',
        'color': Colors.blue,
      },
      {
        'icon': Icons.location_on_outlined,
        'text': 'Saya ingin mengubah tujuan',
        'color': Colors.green,
      },
      {
        'icon': Icons.pin_drop_outlined,
        'text': 'Saya ingin mengubah lokasi jemput',
        'color': Colors.purple,
      },
      {
        'icon': Icons.more_horiz,
        'text': 'Lainnya',
        'color': Colors.grey,
      },
    ];

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: AppTheme.defaultPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: AppTheme.defaultPadding,
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.warning_rounded,
                  color: Colors.red.shade700,
                  size: AppTheme.largeIconSize,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Alasan Pembatalan',
                style: AppTheme.headingStyle,
              ),
              const SizedBox(height: 8),
              Text(
                'Pilih alasan pembatalan pesanan Anda',
                style: AppTheme.bodyTextStyle.copyWith(
                  color: AppTheme.greyColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ...reasons.map((reason) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      _cancelOrder(context, reason['text']);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: AppTheme.defaultPadding,
                      decoration: BoxDecoration(
                        color: reason['color'].withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: reason['color'].withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            reason['icon'],
                            color: reason['color'],
                            size: AppTheme.mediumIconSize,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            reason['text'],
                            style: TextStyle(
                              fontSize: 16,
                              color: reason['color'],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.chevron_right,
                            color: reason['color'],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  void _cancelOrder(BuildContext context, String reason) {
    // TODO: Implement order cancellation with reason
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'Menunggu Driver',
          style: AppTheme.appBarTitleStyle,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: AppTheme.whiteColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppTheme.whiteColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  // Radar Animation
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Background gradient
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              AppTheme.primaryColor.withOpacity(0.1),
                              AppTheme.whiteColor,
                            ],
                            stops: const [0.0, 0.7],
                          ),
                        ),
                      ),
                      // Outer circles
                      AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: 1.0 + (_animation.value * 0.5),
                            child: Container(
                              width: 160,
                              height: 160,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppTheme.primaryColor.withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: 1.0 + (_animation.value * 0.3),
                            child: Container(
                              width: 160,
                              height: 160,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppTheme.primaryColor.withOpacity(0.2),
                                  width: 2,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      // Center icon
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppTheme.whiteColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryColor.withOpacity(0.2),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.person_search,
                          size: AppTheme.largeIconSize,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      // Scanning line
                      AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _animation.value * 2 * 3.14159,
                            child: Container(
                              width: 160,
                              height: 2,
                              color: AppTheme.primaryColor.withOpacity(0.5),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  // Status Text
                  Container(
                    padding: AppTheme.defaultPadding,
                    decoration: BoxDecoration(
                      color: AppTheme.whiteColor,
                      borderRadius: BorderRadius.circular(30),
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
                        Text(
                          'Mencari Driver',
                          style: AppTheme.headingStyle.copyWith(
                            color: AppTheme.blackColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Mohon tunggu sebentar...',
                          style: AppTheme.bodyTextStyle.copyWith(
                            color: AppTheme.greyColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Order Details
                  Container(
                    margin: AppTheme.defaultPadding,
                    padding: AppTheme.defaultPadding,
                    decoration: BoxDecoration(
                      color: AppTheme.whiteColor,
                      borderRadius: BorderRadius.circular(20),
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
                        _buildOrderDetailRow(
                          'Lokasi Jemput',
                          widget.order.pickupLocation,
                          Icons.pin_drop,
                        ),
                        const SizedBox(height: 16),
                        Container(
                          height: 1,
                          color: AppTheme.greyColor.withOpacity(0.2),
                        ),
                        const SizedBox(height: 16),
                        _buildOrderDetailRow(
                          'Lokasi Tujuan',
                          widget.order.destinationLocation,
                          Icons.location_on,
                        ),
                        const SizedBox(height: 16),
                        Container(
                          height: 1,
                          color: AppTheme.greyColor.withOpacity(0.2),
                        ),
                        const SizedBox(height: 16),
                        _buildOrderDetailRow(
                          'Total Biaya',
                          'Rp ${widget.order.price.toStringAsFixed(0)}',
                          Icons.attach_money,
                          isPrice: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          // Cancel Button
          Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom + 16,
              left: 24,
              right: 24,
            ),
            child: ElevatedButton(
              onPressed: () => _showCancelDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade50,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 0,
                side: BorderSide(
                  color: Colors.red.shade300,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.close,
                    color: Colors.red.shade700,
                    size: AppTheme.smallIconSize,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Batalkan Pesanan',
                    style: AppTheme.buttonTextStyle.copyWith(
                      color: Colors.red.shade700,
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

  Widget _buildOrderDetailRow(String label, String value, IconData icon, {bool isPrice = false}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppTheme.primaryColor, size: AppTheme.smallIconSize),
        ),
        const SizedBox(width: 16),
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
                  fontSize: 15,
                  color: isPrice ? AppTheme.primaryColor : AppTheme.blackColor,
                  fontWeight: isPrice ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
} 