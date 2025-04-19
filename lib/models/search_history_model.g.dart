// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchHistoryModel _$SearchHistoryModelFromJson(Map<String, dynamic> json) =>
    SearchHistoryModel(
      query: json['query'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      placeId: json['placeId'] as String?,
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
      isFavorite: json['isFavorite'] as bool? ?? false,
    );

Map<String, dynamic> _$SearchHistoryModelToJson(SearchHistoryModel instance) =>
    <String, dynamic>{
      'query': instance.query,
      'timestamp': instance.timestamp.toIso8601String(),
      'placeId': instance.placeId,
      'lat': instance.lat,
      'lng': instance.lng,
      'isFavorite': instance.isFavorite,
    };
