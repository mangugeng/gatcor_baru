// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaceResponse _$PlaceResponseFromJson(Map<String, dynamic> json) =>
    PlaceResponse(
      name: json['name'] as String,
      address: json['address'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      placeId: json['placeId'] as String,
      rating: (json['rating'] as num).toDouble(),
      userRatingsTotal: (json['userRatingsTotal'] as num).toInt(),
      types: (json['types'] as List<dynamic>).map((e) => e as String).toList(),
      photoReference: json['photoReference'] as String?,
    );

Map<String, dynamic> _$PlaceResponseToJson(PlaceResponse instance) =>
    <String, dynamic>{
      'name': instance.name,
      'address': instance.address,
      'lat': instance.lat,
      'lng': instance.lng,
      'placeId': instance.placeId,
      'rating': instance.rating,
      'userRatingsTotal': instance.userRatingsTotal,
      'types': instance.types,
      'photoReference': instance.photoReference,
    };
