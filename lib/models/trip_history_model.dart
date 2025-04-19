import 'package:json_annotation/json_annotation.dart';
import 'order_model.dart';
import 'service_model.dart';

part 'trip_history_model.g.dart';

@JsonSerializable()
class TripHistoryModel {
  final String id;
  final OrderModel order;
  final String driverName;
  final String driverVehicle;
  final String driverPlateNumber;
  final double rating;
  final String? comment;
  final DateTime completedAt;

  TripHistoryModel({
    required this.id,
    required this.order,
    required this.driverName,
    required this.driverVehicle,
    required this.driverPlateNumber,
    required this.rating,
    this.comment,
    required this.completedAt,
  });

  factory TripHistoryModel.fromJson(Map<String, dynamic> json) => _$TripHistoryModelFromJson(json);
  Map<String, dynamic> toJson() => _$TripHistoryModelToJson(this);

  // Example data for testing
  static List<TripHistoryModel> get exampleTrips => [
        TripHistoryModel(
          id: '1',
          order: OrderModel(
            id: 'order1',
            userId: 'user1',
            driverId: 'driver1',
            pickupLocation: 'Jl. Sudirman No. 1',
            destinationLocation: 'Jl. Thamrin No. 10',
            pickupLat: -6.2088,
            pickupLng: 106.8456,
            destinationLat: -6.2088,
            destinationLng: 106.8456,
            status: 'completed',
            price: 50000,
            createdAt: DateTime.now().subtract(const Duration(days: 1)),
            completedAt: DateTime.now().subtract(const Duration(hours: 23)),
          ),
          driverName: 'Mang Ugeng',
          driverVehicle: 'Toyota Avanza',
          driverPlateNumber: 'B 1234 ABC',
          rating: 4.8,
          comment: 'Driver sangat ramah dan tepat waktu',
          completedAt: DateTime.now().subtract(const Duration(hours: 23)),
        ),
        TripHistoryModel(
          id: '2',
          order: OrderModel(
            id: 'order2',
            userId: 'user1',
            driverId: 'driver2',
            pickupLocation: 'Jl. Gatot Subroto No. 5',
            destinationLocation: 'Jl. Asia Afrika No. 8',
            pickupLat: -6.2088,
            pickupLng: 106.8456,
            destinationLat: -6.2088,
            destinationLng: 106.8456,
            status: 'completed',
            price: 45000,
            createdAt: DateTime.now().subtract(const Duration(days: 2)),
            completedAt: DateTime.now().subtract(const Duration(days: 1, hours: 12)),
          ),
          driverName: 'Pak Budi',
          driverVehicle: 'Daihatsu Xenia',
          driverPlateNumber: 'B 5678 DEF',
          rating: 4.5,
          comment: 'Perjalanan nyaman dan aman',
          completedAt: DateTime.now().subtract(const Duration(days: 1, hours: 12)),
        ),
      ];
} 