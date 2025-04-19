import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

part 'search_history_model.g.dart';

@JsonSerializable()
class SearchHistoryModel {
  final String query;
  final DateTime timestamp;
  final String? placeId;
  final double? lat;
  final double? lng;
  final bool isFavorite;

  SearchHistoryModel({
    required this.query,
    required this.timestamp,
    this.placeId,
    this.lat,
    this.lng,
    this.isFavorite = false,
  });

  factory SearchHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$SearchHistoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$SearchHistoryModelToJson(this);

  static Future<List<SearchHistoryModel>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getStringList('search_history') ?? [];
    return historyJson
        .map((json) => SearchHistoryModel.fromJson(
            Map<String, dynamic>.from(jsonDecode(json))))
        .toList();
  }

  static Future<void> addToHistory(SearchHistoryModel history) async {
    final prefs = await SharedPreferences.getInstance();
    final historyList = await getHistory();
    
    // Remove if already exists
    historyList.removeWhere((h) => h.query == history.query);
    
    // Add to beginning
    historyList.insert(0, history);
    
    // Limit to 20 items
    if (historyList.length > 20) {
      historyList.removeRange(20, historyList.length);
    }
    
    // Save to storage
    final historyJson = historyList
        .map((h) => jsonEncode(h.toJson()))
        .toList();
    await prefs.setStringList('search_history', historyJson);
  }

  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('search_history');
  }
} 