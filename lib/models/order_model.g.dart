// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => OrderModel(
      id: json['id'] as String,
      service:
          OrderModel._serviceFromJson(json['service'] as Map<String, dynamic>),
      pickupLocation: json['pickupLocation'] as String,
      destination: json['destination'] as String,
      distance: (json['distance'] as num).toDouble(),
      estimatedTime: (json['estimatedTime'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      driverType: json['driverType'] as String,
      paymentMethod: json['paymentMethod'] as String,
      pickupLat: (json['pickupLat'] as num).toDouble(),
      pickupLng: (json['pickupLng'] as num).toDouble(),
      destLat: (json['destLat'] as num).toDouble(),
      destLng: (json['destLng'] as num).toDouble(),
      driverId: json['driverId'] as String?,
      promoCode: json['promoCode'] as String?,
      discount: (json['discount'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'service': OrderModel._serviceToJson(instance.service),
      'pickupLocation': instance.pickupLocation,
      'destination': instance.destination,
      'distance': instance.distance,
      'estimatedTime': instance.estimatedTime,
      'price': instance.price,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
      'driverType': instance.driverType,
      'paymentMethod': instance.paymentMethod,
      'pickupLat': instance.pickupLat,
      'pickupLng': instance.pickupLng,
      'destLat': instance.destLat,
      'destLng': instance.destLng,
      'driverId': instance.driverId,
      'promoCode': instance.promoCode,
      'discount': instance.discount,
    };
