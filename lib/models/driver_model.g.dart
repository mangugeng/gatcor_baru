// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'driver_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriverModel _$DriverModelFromJson(Map<String, dynamic> json) => DriverModel(
      id: json['id'] as String,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String,
      email: json['email'] as String,
      profilePicture: json['profilePicture'] as String,
      rating: (json['rating'] as num).toDouble(),
      totalTrips: (json['totalTrips'] as num).toInt(),
      vehicleType: json['vehicleType'] as String,
      vehicleNumber: json['vehicleNumber'] as String,
      vehicleColor: json['vehicleColor'] as String,
      currentLat: (json['currentLat'] as num).toDouble(),
      currentLng: (json['currentLng'] as num).toDouble(),
      isAvailable: json['isAvailable'] as bool? ?? true,
      status: json['status'] as String? ?? 'available',
    );

Map<String, dynamic> _$DriverModelToJson(DriverModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'profilePicture': instance.profilePicture,
      'rating': instance.rating,
      'totalTrips': instance.totalTrips,
      'vehicleType': instance.vehicleType,
      'vehicleNumber': instance.vehicleNumber,
      'vehicleColor': instance.vehicleColor,
      'currentLat': instance.currentLat,
      'currentLng': instance.currentLng,
      'isAvailable': instance.isAvailable,
      'status': instance.status,
    };
