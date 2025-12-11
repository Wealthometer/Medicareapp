class LocationModel {
  final double latitude;
  final double longitude;
  final double accuracy;
  final double altitude;
  final double speed;
  final DateTime timestamp;
  final String? address;

  LocationModel({
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    this.altitude = 0.0,
    this.speed = 0.0,
    required this.timestamp,
    this.address,
  });

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'accuracy': accuracy,
        'altitude': altitude,
        'speed': speed,
        'timestamp': timestamp.toIso8601String(),
        'address': address,
      };

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
        latitude: json['latitude'],
        longitude: json['longitude'],
        accuracy: json['accuracy'],
        altitude: json['altitude'] ?? 0.0,
        speed: json['speed'] ?? 0.0,
        timestamp: DateTime.parse(json['timestamp']),
        address: json['address'],
      );

  String get accuracyLevel {
    if (accuracy <= 10) return 'Excellent';
    if (accuracy <= 30) return 'Good';
    if (accuracy <= 50) return 'Fair';
    return 'Poor';
  }

  String get accuracyDescription {
    if (accuracy <= 10) return 'Very precise location (±${accuracy.toStringAsFixed(1)}m)';
    if (accuracy <= 30) return 'Good location accuracy (±${accuracy.toStringAsFixed(1)}m)';
    if (accuracy <= 50) return 'Moderate accuracy (±${accuracy.toStringAsFixed(1)}m)';
    return 'Low accuracy (±${accuracy.toStringAsFixed(1)}m)';
  }
}
