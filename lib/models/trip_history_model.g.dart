// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TripHistoryModel _$TripHistoryModelFromJson(Map<String, dynamic> json) =>
    TripHistoryModel(
      id: json['id'] as String,
      order: OrderModel.fromJson(json['order'] as Map<String, dynamic>),
      driverName: json['driverName'] as String,
      driverVehicle: json['driverVehicle'] as String,
      driverPlateNumber: json['driverPlateNumber'] as String,
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] as String?,
      completedAt: DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$TripHistoryModelToJson(TripHistoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order': instance.order,
      'driverName': instance.driverName,
      'driverVehicle': instance.driverVehicle,
      'driverPlateNumber': instance.driverPlateNumber,
      'rating': instance.rating,
      'comment': instance.comment,
      'completedAt': instance.completedAt.toIso8601String(),
    };
