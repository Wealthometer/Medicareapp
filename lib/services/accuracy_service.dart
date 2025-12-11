import 'dart:math' as math;

import '../models/location_model.dart';
import '../models/accuracy_metrics_model.dart';

class AccuracyService {
  final List<LocationModel> _locationHistory = [];
  static const int maxHistorySize = 100;

  void addLocation(LocationModel location) {
    _locationHistory.add(location);
    if (_locationHistory.length > maxHistorySize) {
      _locationHistory.removeAt(0);
    }
  }

  AccuracyMetrics calculateMetrics() {
    if (_locationHistory.isEmpty) {
      return AccuracyMetrics(
        averageAccuracy: 0,
        minAccuracy: 0,
        maxAccuracy: 0,
        totalReadings: 0,
        confidenceScore: 0,
        lastUpdated: DateTime.now(),
        accuracyDistribution: {},
      );
    }

    List<double> accuracies = _locationHistory.map((l) => l.accuracy).toList();

    double sum = accuracies.reduce((a, b) => a + b);
    double average = sum / accuracies.length;
    double min = accuracies.reduce((a, b) => a < b ? a : b);
    double max = accuracies.reduce((a, b) => a > b ? a : b);

    // Calculate confidence score (0-100)
    double confidenceScore = calculateConfidenceScore(average, min, max);

    // Calculate accuracy distribution
    Map<String, int> distribution = {
      'Excellent (0-10m)': accuracies.where((a) => a <= 10).length,
      'Good (10-30m)': accuracies.where((a) => a > 10 && a <= 30).length,
      'Fair (30-50m)': accuracies.where((a) => a > 30 && a <= 50).length,
      'Poor (>50m)': accuracies.where((a) => a > 50).length,
    };

    return AccuracyMetrics(
      averageAccuracy: average,
      minAccuracy: min,
      maxAccuracy: max,
      totalReadings: _locationHistory.length,
      confidenceScore: confidenceScore,
      lastUpdated: DateTime.now(),
      accuracyDistribution: distribution,
    );
  }

  double calculateConfidenceScore(double avg, double min, double max) {
    // Lower average accuracy (in meters) => higher confidence.
    // Clamp inputs to a reasonable 0..100m window for scoring.
    double avgClamped = avg.clamp(0.0, 100.0).toDouble();
    double avgScore = (100.0 - avgClamped).clamp(0.0, 100.0);

    // Consistency: use range (max-min) as a simple proxy. Lower range => higher score.
    double range = (max - min).clamp(0.0, 100.0);
    double consistencyScore = (100.0 - range).clamp(0.0, 100.0);

    // Weighted combination and ensure double in 0..100
    double score = (avgScore * 0.7 + consistencyScore * 0.3);
    return score.clamp(0.0, 100.0).toDouble();
  }

  List<LocationModel> getLocationHistory() =>
      List.unmodifiable(_locationHistory);

  void clearHistory() => _locationHistory.clear();

  Map<String, dynamic> getErrorMetrics() {
    if (_locationHistory.length < 2) {
      return {'standardDeviation': 0.0, 'variance': 0.0, 'errorRange': 0.0};
    }

    List<double> accuracies = _locationHistory.map((l) => l.accuracy).toList();
    double mean = accuracies.reduce((a, b) => a + b) / accuracies.length;

    double variance =
        accuracies.map((a) => (a - mean) * (a - mean)).reduce((a, b) => a + b) /
        accuracies.length;

    // Standard deviation is sqrt(variance)
    double stdDev = variance >= 0 ? math.sqrt(variance) : 0.0;

    double maxAcc = accuracies.reduce((a, b) => a > b ? a : b);
    double minAcc = accuracies.reduce((a, b) => a < b ? a : b);

    return {
      'standardDeviation': stdDev,
      'variance': variance,
      'errorRange': maxAcc - minAcc,
    };
  }
}
