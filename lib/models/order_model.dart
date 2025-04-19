import 'package:json_annotation/json_annotation.dart';
import 'service_model.dart';

part 'order_model.g.dart';

@JsonSerializable()
class OrderModel {
  final String id;
  @JsonKey(fromJson: _serviceFromJson, toJson: _serviceToJson)
  final ServiceModel service;
  final String pickupLocation;
  final String destination;
  final double distance;
  final int estimatedTime;
  final double price;
  final String status;
  final DateTime createdAt;
  final String driverType;
  final String paymentMethod;
  final double pickupLat;
  final double pickupLng;
  final double destLat;
  final double destLng;
  final String? driverId;
  final String? promoCode;
  final double? discount;

  OrderModel({
    required this.id,
    required this.service,
    required this.pickupLocation,
    required this.destination,
    required this.distance,
    required this.estimatedTime,
    required this.price,
    required this.status,
    required this.createdAt,
    required this.driverType,
    required this.paymentMethod,
    required this.pickupLat,
    required this.pickupLng,
    required this.destLat,
    required this.destLng,
    this.driverId,
    this.promoCode,
    this.discount,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => _$OrderModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderModelToJson(this);

  static ServiceModel _serviceFromJson(Map<String, dynamic> json) => ServiceModel.fromJson(json);
  static Map<String, dynamic> _serviceToJson(ServiceModel service) => service.toJson();
} 