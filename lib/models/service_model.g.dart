// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceModel _$ServiceModelFromJson(Map<String, dynamic> json) => ServiceModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      basePrice: (json['basePrice'] as num).toDouble(),
      pricePerKm: (json['pricePerKm'] as num).toDouble(),
      icon: json['icon'] as String,
      isAvailable: json['isAvailable'] as bool? ?? true,
    );

Map<String, dynamic> _$ServiceModelToJson(ServiceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'basePrice': instance.basePrice,
      'pricePerKm': instance.pricePerKm,
      'icon': instance.icon,
      'isAvailable': instance.isAvailable,
    };
