import 'package:flutter/material.dart';
import 'dart:async';
import '../../models/location_model.dart';
import '../../models/accuracy_metrics_model.dart';
import '../../services/location_service.dart';
import '../../services/accuracy_service.dart';
import '../../widgets/accuracy/accuracy_dashboard.dart';

class AccuracyMonitorScreen extends StatefulWidget {
  const AccuracyMonitorScreen({Key? key}) : super(key: key);

  @override
  State<AccuracyMonitorScreen> createState() => _AccuracyMonitorScreenState();
}

class _AccuracyMonitorScreenState extends State<AccuracyMonitorScreen> {
  final LocationService _locationService = LocationService();
  final AccuracyService _accuracyService = AccuracyService();
  StreamSubscription<LocationModel>? _locationSubscription;

  LocationModel? _currentLocation;
  AccuracyMetrics? _metrics;
  bool _isMonitoring = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    LocationModel? location = await _locationService.getCurrentLocation();
    if (location != null) {
      _accuracyService.addLocation(location);
      setState(() {
        _currentLocation = location;
        _metrics = _accuracyService.calculateMetrics();
      });
    }
  }

  void _startMonitoring() {
    _locationSubscription = _locationService.getLocationStream().listen((location) {
      _accuracyService.addLocation(location);
      setState(() {
        _currentLocation = location;
        _metrics = _accuracyService.calculateMetrics();
      });
    });

    setState(() {
      _isMonitoring = true;
    });
  }

  void _stopMonitoring() {
    _locationSubscription?.cancel();
    setState(() {
      _isMonitoring = false;
    });
  }

  void _clearData() {
    _accuracyService.clearHistory();
    setState(() {
      _metrics = _accuracyService.calculateMetrics();
    });
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accuracy Monitor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _clearData,
            tooltip: 'Clear History',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_metrics != null) AccuracyDashboard(metrics: _metrics!),
            const SizedBox(height: 16),
            _buildCurrentLocationCard(),
            const SizedBox(height: 16),
            _buildAccuracyDistribution(),
            const SizedBox(height: 16),
            _buildErrorMetrics(),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _isMonitoring ? _stopMonitoring : _startMonitoring,
              icon: Icon(_isMonitoring ? Icons.stop : Icons.play_arrow),
              label: Text(_isMonitoring ? 'Stop Monitoring' : 'Start Monitoring'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: _isMonitoring ? Colors.red : Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentLocationCard() {
    if (_currentLocation == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('No location data available'),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Reading',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.location_on, 'Coordinates',
                '${_currentLocation!.latitude.toStringAsFixed(6)}, ${_currentLocation!.longitude.toStringAsFixed(6)}'),
            _buildInfoRow(Icons.speed, 'Accuracy',
                _currentLocation!.accuracyDescription),
            _buildInfoRow(Icons.height, 'Altitude',
                '${_currentLocation!.altitude.toStringAsFixed(1)}m'),
            _buildInfoRow(Icons.timer, 'Time',
                _currentLocation!.timestamp.toString().substring(0, 19)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  value,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccuracyDistribution() {
    if (_metrics == null || _metrics!.accuracyDistribution.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Accuracy Distribution',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ..._metrics!.accuracyDistribution.entries.map((entry) {
              int total = _metrics!.totalReadings;
              double percentage = total > 0 ? (entry.value / total) * 100 : 0;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(entry.key),
                        Text('${entry.value} (${percentage.toStringAsFixed(1)}%)'),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: percentage / 100,
                        minHeight: 8,
                        backgroundColor: Colors.grey[200],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorMetrics() {
    Map<String, dynamic> errorMetrics = _accuracyService.getErrorMetrics();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Error Metrics',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.show_chart, 'Standard Deviation',
                '±${errorMetrics['standardDeviation'].toStringAsFixed(2)}m'),
            _buildInfoRow(Icons.analytics, 'Variance',
                '${errorMetrics['variance'].toStringAsFixed(2)}'),
            _buildInfoRow(Icons.straighten, 'Error Range',
                '${errorMetrics['errorRange'].toStringAsFixed(2)}m'),
          ],
        ),
      ),
    );
  }
}