// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => OrderModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      driverId: json['driverId'] as String,
      pickupLocation: json['pickupLocation'] as String,
      destinationLocation: json['destinationLocation'] as String,
      pickupLat: (json['pickupLat'] as num).toDouble(),
      pickupLng: (json['pickupLng'] as num).toDouble(),
      destinationLat: (json['destinationLat'] as num).toDouble(),
      destinationLng: (json['destinationLng'] as num).toDouble(),
      status: json['status'] as String,
      price: (json['price'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'driverId': instance.driverId,
      'pickupLocation': instance.pickupLocation,
      'destinationLocation': instance.destinationLocation,
      'pickupLat': instance.pickupLat,
      'pickupLng': instance.pickupLng,
      'destinationLat': instance.destinationLat,
      'destinationLng': instance.destinationLng,
      'status': instance.status,
      'price': instance.price,
      'createdAt': instance.createdAt.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
    };
