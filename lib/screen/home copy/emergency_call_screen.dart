import 'package:flutter/material.dart';
import 'package:medicare/models/location_model.dart';
import 'package:medicare/common/color_extension.dart';
import 'dart:async';

class EmergencyCallScreen extends StatefulWidget {
  final String name;
  final String phone;
  final String address;
  final String emergencyType;
  final LocationModel? location;

  const EmergencyCallScreen({
    Key? key,
    required this.name,
    required this.phone,
    required this.address,
    required this.emergencyType,
    this.location,
  }) : super(key: key);

  @override
  State<EmergencyCallScreen> createState() => _EmergencyCallScreenState();
}

class _EmergencyCallScreenState extends State<EmergencyCallScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  bool _isConnecting = true;
  Timer? _connectionTimer;

  final Map<String, String> emergencyLabels = {
    'accident': 'Accident',
    'pregnancy': 'Pregnancy Emergency',
    'heart': 'Heart Attack',
    'stroke': 'Stroke',
    'injury': 'Severe Injury',
    'other': 'Other Emergency',
  };

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();

    // Simulate connection delay
    _connectionTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isConnecting = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _connectionTimer?.cancel();
    super.dispose();
  }

  String _getEmergencyLabel() {
    return emergencyLabels[widget.emergencyType] ?? 'Emergency';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade50,
      appBar: AppBar(
        title: const Text(
          'Emergency Call',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red.shade700,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Emergency Type Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.red.shade700,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.emergency, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      _getEmergencyLabel(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Animated Call Icon
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Container(
                    width: 120 + (_pulseController.value * 20),
                    height: 120 + (_pulseController.value * 20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red.shade700.withOpacity(0.1 - (_pulseController.value * 0.1)),
                    ),
                    child: Center(
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red.shade700,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.shade700.withOpacity(0.4),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.phone,
                          color: Colors.white,
                          size: 60,
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 30),

              // Status Text
              Text(
                _isConnecting ? 'Connecting to Emergency Services...' : 'Connected',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.red.shade900,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                _isConnecting ? 'Please wait' : 'Help is on the way',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),

              const SizedBox(height: 40),

              // Patient Details Card
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Emergency Details',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),

                        _buildDetailRow(Icons.person, 'Name', widget.name),
                        const Divider(height: 30),

                        _buildDetailRow(Icons.phone, 'Phone', widget.phone),
                        const Divider(height: 30),

                        _buildDetailRow(Icons.location_on, 'Address', widget.address),

                        if (widget.location != null) ...[
                          const Divider(height: 30),
                          _buildDetailRow(
                            Icons.my_location,
                            'Coordinates',
                            '${widget.location!.latitude.toStringAsFixed(6)}, ${widget.location!.longitude.toStringAsFixed(6)}',
                          ),
                          const Divider(height: 30),
                          _buildDetailRow(
                            Icons.track_changes,
                            'Accuracy',
                            widget.location!.accuracyDescription,
                          ),
                        ],

                        const Divider(height: 30),
                        _buildDetailRow(
                          Icons.access_time,
                          'Request Time',
                          '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}',
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Emergency Numbers
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.orange.shade700, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Emergency Contacts',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.orange.shade900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildEmergencyNumber('Ambulance', '108'),
                        _buildEmergencyNumber('Police', '100'),
                        _buildEmergencyNumber('Fire', '101'),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close, color: Colors.white),
                      label: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade600,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // In real app, this would make an actual call
                        _showCallConfirmation();
                      },
                      icon: const Icon(Icons.call, color: Colors.white),
                      label: const Text(
                        'Call 108',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.red.shade700, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmergencyNumber(String label, String number) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          number,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.orange.shade900,
          ),
        ),
      ],
    );
  }

  void _showCallConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.phone, color: Colors.green),
            SizedBox(width: 10),
            Text('Calling 108'),
          ],
        ),
        content: const Text(
          'Emergency services will be notified with your location and details.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Here you would integrate actual calling functionality
              // using url_launcher: tel:108
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Calling emergency services...'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text('Call Now', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}