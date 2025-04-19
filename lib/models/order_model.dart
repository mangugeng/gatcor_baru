import 'package:json_annotation/json_annotation.dart';

part 'order_model.g.dart';

@JsonSerializable()
class OrderModel {
  final String id;
  final String userId;
  final String driverId;
  final String pickupLocation;
  final String destinationLocation;
  final double pickupLat;
  final double pickupLng;
  final double destinationLat;
  final double destinationLng;
  final String status;
  final double price;
  final DateTime createdAt;
  final DateTime? completedAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.driverId,
    required this.pickupLocation,
    required this.destinationLocation,
    required this.pickupLat,
    required this.pickupLng,
    required this.destinationLat,
    required this.destinationLng,
    required this.status,
    required this.price,
    required this.createdAt,
    this.completedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => _$OrderModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderModelToJson(this);
} 