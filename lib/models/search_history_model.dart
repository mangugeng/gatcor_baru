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
    final historyJson = prefs.getString('search_history') ?? '[]';
    final List<dynamic> historyList = json.decode(historyJson);
    return historyList.map((item) => SearchHistoryModel.fromJson(item)).toList();
  }

  static Future<void> addToHistory(SearchHistoryModel history) async {
    final prefs = await SharedPreferences.getInstance();
    final currentHistory = await getHistory();
    
    // Remove duplicate entries
    currentHistory.removeWhere((item) => item.query == history.query);
    
    // Add new history to the beginning
    currentHistory.insert(0, history);
    
    // Keep only the last 10 entries
    if (currentHistory.length > 10) {
      currentHistory.removeRange(10, currentHistory.length);
    }
    
    final historyJson = json.encode(currentHistory.map((item) => item.toJson()).toList());
    await prefs.setString('search_history', historyJson);
  }

  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('search_history');
  }
} 