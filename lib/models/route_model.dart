import 'package:json_annotation/json_annotation.dart';

part 'route_model.g.dart';

@JsonSerializable()
class RouteModel {
  final double distance; // dalam kilometer
  final double duration; // dalam menit
  final double price;
  final List<Map<String, double>> coordinates;
  final String vehicleType;

  RouteModel({
    required this.distance,
    required this.duration,
    required this.price,
    required this.coordinates,
    required this.vehicleType,
  });

  factory RouteModel.fromJson(Map<String, dynamic> json) =>
      _$RouteModelFromJson(json);
  Map<String, dynamic> toJson() => _$RouteModelToJson(this);
}
