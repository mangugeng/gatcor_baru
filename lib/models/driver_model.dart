import 'package:json_annotation/json_annotation.dart';

part 'driver_model.g.dart';

@JsonSerializable()
class DriverModel {
  final String id;
  final String name;
  final String phoneNumber;
  final String email;
  final String profilePicture;
  final double rating;
  final int totalTrips;
  final String vehicleType;
  final String vehicleNumber;
  final String vehicleColor;
  final double currentLat;
  final double currentLng;
  final bool isAvailable;
  final String status;

  DriverModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.profilePicture,
    required this.rating,
    required this.totalTrips,
    required this.vehicleType,
    required this.vehicleNumber,
    required this.vehicleColor,
    required this.currentLat,
    required this.currentLng,
    this.isAvailable = true,
    this.status = 'available',
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) => _$DriverModelFromJson(json);
  Map<String, dynamic> toJson() => _$DriverModelToJson(this);
} 