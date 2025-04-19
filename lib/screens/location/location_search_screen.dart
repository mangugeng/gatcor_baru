import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../models/search_history_model.dart';
import '../../themes/app_theme.dart';

class LocationSearchScreen extends StatefulWidget {
  final String? initialQuery;
  final Function(String, double, double, String) onLocationSelected;

  const LocationSearchScreen({
    super.key,
    this.initialQuery,
    required this.onLocationSelected,
  });

  @override
  State<LocationSearchScreen> createState() => _LocationSearchScreenState();
}

class _LocationSearchScreenState extends State<LocationSearchScreen> {
  final TextEditingController searchController = TextEditingController();
  List<SearchHistoryModel> searchHistory = [];
  List<Map<String, dynamic>> searchResults = [];
  bool isLoading = false;
  final String apiKey = 'AIzaSyDJdqPbGuQVGHFbHDydMJF1pkHBaAJPdQg';

  @override
  void initState() {
    super.initState();
    if (widget.initialQuery != null) {
      searchController.text = widget.initialQuery!;
      _searchPlace(widget.initialQuery!);
    }
    _loadSearchHistory();
  }

  Future<void> _loadSearchHistory() async {
    final history = await SearchHistoryModel.getHistory();
    setState(() {
      searchHistory = history;
    });
  }

  Future<void> _searchPlace(String query) async {
    if (query.isEmpty) {
      setState(() {
        searchResults.clear();
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    // Bounds for West Java region
    final bounds = 'bounds=-7.5,106.0,-6.0,108.0';
    // Correct format for components
    final components = 'components=country:id';

    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/autocomplete/json?'
      'input=$query&key=$apiKey&$components&$bounds&language=id&types=address',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Search response: $data'); // Debug log

        if (data['status'] == 'OK' && data['predictions'] != null) {
          // Filter results to only show West Java addresses
          final filteredResults = List<Map<String, dynamic>>.from(data['predictions'])
              .where((prediction) {
                final description = prediction['description'].toString().toLowerCase();
                return description.contains('jawa barat') || 
                       description.contains('bandung') ||
                       description.contains('cimahi') ||
                       description.contains('garut') ||
                       description.contains('tasikmalaya') ||
                       description.contains('cirebon') ||
                       description.contains('sukabumi') ||
                       description.contains('subang') ||
                       description.contains('sumedang') ||
                       description.contains('majalengka') ||
                       description.contains('indramayu') ||
                       description.contains('karawang') ||
                       description.contains('purwakarta') ||
                       description.contains('bekasi') ||
                       description.contains('depok') ||
                       description.contains('bogor');
              })
              .toList();

          setState(() {
            searchResults = filteredResults;
          });
        } else {
          setState(() {
            searchResults.clear();
          });
          if (data['status'] != 'ZERO_RESULTS') {
            print('Search error: ${data['status']}'); // Debug log
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${data['status']}')),
            );
          }
        }
      } else {
        print('HTTP error: ${response.statusCode}'); // Debug log
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print('Error searching place: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _selectPlace(String placeId) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/details/json?'
      'place_id=$placeId&key=$apiKey&language=id',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Place details response: $data'); // Debug log

        if (data['status'] == 'OK' && data['result'] != null) {
          final place = data['result'];
          final location = place['geometry']['location'];
          final lat = location['lat'];
          final lng = location['lng'];
          final address = place['formatted_address'];

          // Save to history
          await SearchHistoryModel.addToHistory(
            SearchHistoryModel(
              query: address,
              timestamp: DateTime.now(),
              placeId: placeId,
              lat: lat,
              lng: lng,
            ),
          );

          widget.onLocationSelected(address, lat, lng, placeId);
          Navigator.pop(context);
        } else {
          print('Place details error: ${data['status']}'); // Debug log
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${data['status']}')),
          );
        }
      } else {
        print('HTTP error: ${response.statusCode}'); // Debug log
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print('Error selecting place: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cari Lokasi',
          style: AppTheme.appBarTitleStyle,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: AppTheme.whiteColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: AppTheme.defaultPadding,
            child: TextField(
              controller: searchController,
              style: AppTheme.inputTextStyle,
              decoration: InputDecoration(
                hintText: 'Masukkan alamat tujuan',
                hintStyle: AppTheme.hintTextStyle,
                prefixIcon: Icon(Icons.search, size: AppTheme.mediumIconSize, color: AppTheme.lightGreyColor),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, size: AppTheme.mediumIconSize, color: AppTheme.lightGreyColor),
                        onPressed: () {
                          searchController.clear();
                          setState(() {
                            searchResults.clear();
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: _searchPlace,
            ),
          ),

          // Search Results
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : searchResults.isEmpty && searchController.text.isEmpty
                    ? ListView.builder(
                        itemCount: searchHistory.length,
                        itemBuilder: (context, index) {
                          final history = searchHistory[index];
                          return ListTile(
                            leading: Icon(Icons.history, size: AppTheme.smallIconSize, color: AppTheme.lightGreyColor),
                            title: Text(history.query, style: AppTheme.searchTextStyle),
                            onTap: () => _selectPlace(history.placeId!),
                          );
                        },
                      )
                    : ListView.builder(
                        itemCount: searchResults.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Icon(Icons.location_on, size: AppTheme.smallIconSize, color: AppTheme.lightGreyColor),
                            title: Text(searchResults[index]['description'], style: AppTheme.searchTextStyle),
                            onTap: () => _selectPlace(searchResults[index]['place_id']),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
} 