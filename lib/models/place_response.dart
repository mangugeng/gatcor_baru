import 'package:json_annotation/json_annotation.dart';

part 'place_response.g.dart';

@JsonSerializable()
class PlaceResponse {
  final String name;
  final String address;
  final double lat;
  final double lng;
  final String placeId;
  final double rating;
  final int userRatingsTotal;
  final List<String> types;
  final String? photoReference;

  PlaceResponse({
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,
    required this.placeId,
    required this.rating,
    required this.userRatingsTotal,
    required this.types,
    this.photoReference,
  });

  factory PlaceResponse.fromJson(Map<String, dynamic> json) =>
      _$PlaceResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PlaceResponseToJson(this);
} 