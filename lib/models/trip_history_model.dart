import 'package:flutter/material.dart';
import 'order_model.dart';
import 'service_model.dart';

class TripHistoryModel {
  final String id;
  final OrderModel order;
  final String driverName;
  final String driverVehicle;
  final double rating;
  final DateTime date;
  final String status;

  TripHistoryModel({
    required this.id,
    required this.order,
    required this.driverName,
    required this.driverVehicle,
    required this.rating,
    required this.date,
    required this.status,
  });

  // Contoh data untuk testing
  static List<TripHistoryModel> get sampleTrips => [
        TripHistoryModel(
          id: '1',
          order: OrderModel(
            id: '1',
            pickupLocation: 'Jl. Sudirman No. 123',
            destination: 'Grand Indonesia',
            price: 50000,
            status: 'completed',
            service: ServiceModel(
              id: '1',
              name: 'Regular',
              type: 'Car',
              description: 'Layanan reguler',
              icon: 'assets/icons/car.png',
            ),
            distance: 5.2,
            estimatedTime: 15,
            createdAt: DateTime.now().subtract(const Duration(days: 1)),
            driverType: 'Car',
            paymentMethod: 'Cash',
            pickupLat: -6.2088,
            pickupLng: 106.8456,
            destLat: -6.1950,
            destLng: 106.8200,
          ),
          driverName: 'Mang Ugeng',
          driverVehicle: 'Toyota Avanza • B 1234 ABC',
          rating: 4.8,
          date: DateTime.now().subtract(const Duration(days: 1)),
          status: 'completed',
        ),
        TripHistoryModel(
          id: '2',
          order: OrderModel(
            id: '2',
            pickupLocation: 'Senayan City',
            destination: 'Kemang',
            price: 45000,
            status: 'completed',
            service: ServiceModel(
              id: '1',
              name: 'Regular',
              type: 'Car',
              description: 'Layanan reguler',
              icon: 'assets/icons/car.png',
            ),
            distance: 4.8,
            estimatedTime: 12,
            createdAt: DateTime.now().subtract(const Duration(days: 3)),
            driverType: 'Car',
            paymentMethod: 'Cash',
            pickupLat: -6.2250,
            pickupLng: 106.8000,
            destLat: -6.2500,
            destLng: 106.8200,
          ),
          driverName: 'Pak Budi',
          driverVehicle: 'Daihatsu Xenia • B 5678 DEF',
          rating: 4.5,
          date: DateTime.now().subtract(const Duration(days: 3)),
          status: 'completed',
        ),
      ];
} 