import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/user_model.dart';
import '../models/route_model.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['BASE_URL'] ?? '',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
    ),
  );

  String? _token;

  void setToken(String token) {
    _token = token;
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  Future<UserModel> registerUser({
    required String name,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/api/auth/register',
        data: {
          'name': name,
          'email': email,
          'phoneNumber': phoneNumber,
          'password': password,
          'role': 'passenger',
        },
      );

      if (response.data['status'] != 'success') {
        throw Exception(response.data['message'] ?? 'Failed to register');
      }

      return UserModel.fromJson(response.data['data']['user']);
    } catch (e) {
      throw Exception('Failed to register user: $e');
    }
  }

  Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/api/auth/login',
        data: {'email': email, 'password': password},
      );

      if (response.data['status'] != 'success') {
        throw Exception(response.data['message'] ?? 'Failed to login');
      }

      final userData = response.data['data'];
      final user = UserModel.fromJson(userData['user']);
      final token = userData['token'];

      // Set token for future requests
      setToken(token);

      return {
        'user': user,
        'token': token,
      };
    } catch (e) {
      print('Login Error: $e');
      throw Exception('Failed to login: $e');
    }
  }

  Future<List<UserModel>> getNearbyDrivers({
    required double latitude,
    required double longitude,
    required String vehicleType,
  }) async {
    try {
      final response = await _dio.get(
        '/api/location/nearby-drivers',
        queryParameters: {
          'latitude': latitude,
          'longitude': longitude,
          'vehicleType': vehicleType,
        },
      );

      if (response.data['status'] != 'success') {
        throw Exception(response.data['message'] ?? 'Failed to get nearby drivers');
      }

      return (response.data['data'] as List)
          .map((driver) => UserModel.fromJson(driver))
          .toList();
    } catch (e) {
      throw Exception('Failed to get nearby drivers: $e');
    }
  }

  Future<RouteModel> calculateRoute({
    required double startLat,
    required double startLng,
    required double endLat,
    required double endLng,
    required String vehicleType,
  }) async {
    try {
      final response = await _dio.post(
        '/api/maps/route-with-price',
        data: {
          'startLat': startLat,
          'startLng': startLng,
          'endLat': endLat,
          'endLng': endLng,
          'vehicleType': vehicleType,
        },
      );

      if (response.data['status'] != 'success') {
        throw Exception(response.data['message'] ?? 'Failed to calculate route');
      }

      return RouteModel.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('Failed to calculate route: $e');
    }
  }
}
