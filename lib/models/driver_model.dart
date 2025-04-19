class DriverModel {
  final String id;
  final String name;
  final String phone;
  final String vehicleType;
  final String vehicleNumber;
  final double rating;
  final String photoUrl;
  final double latitude;
  final double longitude;

  DriverModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.vehicleType,
    required this.vehicleNumber,
    required this.rating,
    required this.photoUrl,
    required this.latitude,
    required this.longitude,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      vehicleType: json['vehicleType'],
      vehicleNumber: json['vehicleNumber'],
      rating: json['rating'].toDouble(),
      photoUrl: json['photoUrl'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'vehicleType': vehicleType,
      'vehicleNumber': vehicleNumber,
      'rating': rating,
      'photoUrl': photoUrl,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
} 