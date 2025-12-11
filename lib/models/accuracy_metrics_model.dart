class AccuracyMetrics {
  final double averageAccuracy;
  final double minAccuracy;
  final double maxAccuracy;
  final int totalReadings;
  final double confidenceScore;
  final DateTime lastUpdated;
  final Map<String, int> accuracyDistribution;

  AccuracyMetrics({
    required this.averageAccuracy,
    required this.minAccuracy,
    required this.maxAccuracy,
    required this.totalReadings,
    required this.confidenceScore,
    required this.lastUpdated,
    required this.accuracyDistribution,
  });

  String get confidenceLevel {
    if (confidenceScore >= 90) return 'Very High';
    if (confidenceScore >= 75) return 'High';
    if (confidenceScore >= 60) return 'Medium';
    if (confidenceScore >= 40) return 'Low';
    return 'Very Low';
  }

  Map<String, dynamic> toJson() => {
        'averageAccuracy': averageAccuracy,
        'minAccuracy': minAccuracy,
        'maxAccuracy': maxAccuracy,
        'totalReadings': totalReadings,
        'confidenceScore': confidenceScore,
        'lastUpdated': lastUpdated.toIso8601String(),
        'accuracyDistribution': accuracyDistribution,
      };
}
