import 'package:json_annotation/json_annotation.dart';

part 'service_model.g.dart';

@JsonSerializable()
class ServiceModel {
  final String id;
  final String name;
  final String description;
  final double basePrice;
  final double pricePerKm;
  final String icon;
  final bool isAvailable;

  ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.basePrice,
    required this.pricePerKm,
    required this.icon,
    this.isAvailable = true,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) => _$ServiceModelFromJson(json);
  Map<String, dynamic> toJson() => _$ServiceModelToJson(this);
} 