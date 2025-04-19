import 'package:flutter/material.dart';
import '../../models/service_model.dart';
import '../../models/trip_history_model.dart';
import '../../themes/app_theme.dart';
import '../promo/promo_detail_screen.dart';
import '../profile/profile_screen.dart';
import '../order/initial_order_screen.dart';
import '../trip_history_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<ServiceModel> services = [
    ServiceModel(
      id: '1',
      name: 'Gatcor Motor',
      icon: '🏍️',
      description: 'Ojek online dengan motor',
      basePrice: 10000,
      pricePerKm: 2000,
      isAvailable: true,
    ),
    ServiceModel(
      id: '2',
      name: 'Gatcor Car',
      icon: '🚗',
      description: 'Taksi online dengan mobil',
      basePrice: 15000,
      pricePerKm: 3000,
      isAvailable: true,
    ),
    ServiceModel(
      id: '3',
      name: 'Gatcor Kirim',
      icon: '📦',
      description: 'Layanan pengiriman barang',
      basePrice: 8000,
      pricePerKm: 1500,
      isAvailable: true,
    ),
    ServiceModel(
      id: '4',
      name: 'Gatcor Food',
      icon: '🍔',
      description: 'Pesan makanan online',
      basePrice: 5000,
      pricePerKm: 1000,
      isAvailable: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Gatcor',
          style: AppTheme.appBarTitleStyle,
        ),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Show notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: _selectedIndex == 0 ? _buildHomeContent() : _buildOrderHistory(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: AppTheme.whiteColor,
        elevation: 8,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: AppTheme.greyColor,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: AppTheme.bodyText.copyWith(
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: AppTheme.bodyText,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_outlined),
            activeIcon: Icon(Icons.history),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingLg),
              child: TextField(
                style: AppTheme.bodyText,
                decoration: InputDecoration(
                  hintText: 'Cari layanan...',
                  hintStyle: AppTheme.hintTextStyle,
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: AppTheme.spacingMd,
                  ),
                ),
              ),
            ),

            // Promo Banner
            Container(
              height: 140,
              margin: EdgeInsets.symmetric(horizontal: AppTheme.spacingLg),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                gradient: LinearGradient(
                  colors: [AppTheme.primaryColor, Colors.lightBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    right: -20,
                    top: -20,
                    child: Icon(
                      Icons.local_offer,
                      size: 100,
                      color: AppTheme.whiteColor.withOpacity(0.2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppTheme.spacingMd),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Promo Spesial!',
                          style: AppTheme.heading1.copyWith(
                            color: AppTheme.whiteColor,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingXs),
                        Text(
                          'Dapatkan diskon 50% untuk pesanan pertama',
                          style: AppTheme.bodyText.copyWith(
                            color: AppTheme.whiteColor,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingMd),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PromoDetailScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.whiteColor,
                            foregroundColor: AppTheme.primaryColor,
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppTheme.spacingMd,
                              vertical: AppTheme.spacingSm,
                            ),
                            minimumSize: const Size(0, 28),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                            ),
                          ),
                          child: Text(
                            'Lihat Detail',
                            style: AppTheme.buttonText.copyWith(
                              color: AppTheme.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: AppTheme.spacingLg),
            
            // Services Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(
                left: AppTheme.spacingLg,
                right: AppTheme.spacingLg,
                bottom: AppTheme.spacingXl,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppTheme.spacingLg,
                mainAxisSpacing: AppTheme.spacingLg,
                childAspectRatio: 1.1,
              ),
              itemCount: services.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InitialOrderScreen(service: services[index]),
                      ),
                    );
                  },
                  child: Container(
                    decoration: AppTheme.cardDecoration,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          services[index].icon,
                          style: const TextStyle(fontSize: 40),
                        ),
                        const SizedBox(height: AppTheme.spacingMd),
                        Text(
                          services[index].name,
                          style: AppTheme.subheadingStyle,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppTheme.spacingXs),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.spacingMd,
                          ),
                          child: Text(
                            services[index].description,
                            style: AppTheme.bodyText.copyWith(
                              color: AppTheme.greyColor,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderHistory() {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Riwayat Pesanan',
                  style: AppTheme.heading1,
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TripHistoryScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.history),
                  label: Text(
                    'Lihat Semua',
                    style: AppTheme.bodyText.copyWith(
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingLg,
              ),
              itemCount: TripHistoryModel.exampleTrips.length,
              itemBuilder: (context, index) {
                final trip = TripHistoryModel.exampleTrips[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: AppTheme.spacingMd),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.spacingMd),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              trip.order.pickupLocation,
                              style: AppTheme.subheadingStyle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'Rp ${trip.order.price.toStringAsFixed(0)}',
                              style: AppTheme.priceTextStyle,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppTheme.spacingXs),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 16,
                              color: AppTheme.greyColor,
                            ),
                            const SizedBox(width: AppTheme.spacingXs),
                            Expanded(
                              child: Text(
                                trip.order.destinationLocation,
                                style: AppTheme.bodyText.copyWith(
                                  color: AppTheme.greyColor,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppTheme.spacingMd),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                              child: const Icon(
                                Icons.person_outline,
                                size: 16,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                            const SizedBox(width: AppTheme.spacingSm),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  trip.driverName,
                                  style: AppTheme.bodyText.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${trip.driverVehicle} • ${trip.driverPlateNumber}',
                                  style: AppTheme.bodyText.copyWith(
                                    color: AppTheme.greyColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 16,
                                  color: Colors.amber,
                                ),
                                const SizedBox(width: AppTheme.spacingXs),
                                Text(
                                  trip.rating.toStringAsFixed(1),
                                  style: AppTheme.bodyText.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
} 