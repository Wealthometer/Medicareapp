import 'package:flutter/material.dart';
import 'package:medicare/services/location_service.dart';
import 'package:medicare/models/location_model.dart';

class BookingDialog extends StatefulWidget {
  final String bookingType;

  const BookingDialog({Key? key, required this.bookingType}) : super(key: key);

  @override
  State<BookingDialog> createState() => _BookingDialogState();
}

class _BookingDialogState extends State<BookingDialog> {
  final _formKey = GlobalKey<FormState>();
  final LocationService _locationService = LocationService();

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  // State variables
  LocationModel? _currentLocation;
  bool _isLoadingLocation = false;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedAmbulanceType;
  String? _selectedBedType;
  String? _selectedDepartment;
  String? _selectedBloodGroup;
  String? _selectedHospital;

  // Data
  final List<String> ambulanceTypes = ['Basic Life Support (BLS)', 'Advanced Life Support (ALS)', 'Patient Transport', 'Neonatal Ambulance'];
  final List<String> bedTypes = ['General Ward', 'Private Room', 'ICU', 'NICU', 'Emergency Bed'];
  final List<String> departments = ['Cardiology', 'Orthopedics', 'Neurology', 'General Medicine', 'Pediatrics', 'Gynecology'];
  final List<String> bloodGroups = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];
  final List<String> hospitals = ['City Hospital', 'Medicare Hospital', 'Apollo Hospital', 'Fortis Hospital', 'Max Hospital'];

  @override
  void initState() {
    super.initState();
    _retrieveLocation();
  }

  Future<void> _retrieveLocation() async {
    setState(() => _isLoadingLocation = true);
    try {
      LocationModel? location = await _locationService.getCurrentLocation();
      if (location != null) {
        setState(() {
          _currentLocation = location;
          _addressController.text = location.address ?? 'Vasai, Maharashtra';
        });
      }
    } catch (e) {
      setState(() => _addressController.text = 'Vasai, Maharashtra');
    } finally {
      setState(() => _isLoadingLocation = false);
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: _getThemeColor()),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: _getThemeColor()),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  Color _getThemeColor() {
    switch (widget.bookingType) {
      case 'ambulance':
        return Colors.blue.shade600;
      case 'bed':
        return Colors.purple.shade600;
      case 'appointment':
        return Colors.teal.shade600;
      case 'blood':
        return Colors.red.shade600;
      default:
        return Colors.blue.shade600;
    }
  }

  IconData _getIcon() {
    switch (widget.bookingType) {
      case 'ambulance':
        return Icons.local_hospital;
      case 'bed':
        return Icons.hotel;
      case 'appointment':
        return Icons.event_available;
      case 'blood':
        return Icons.bloodtype;
      default:
        return Icons.medical_services;
    }
  }

  String _getTitle() {
    switch (widget.bookingType) {
      case 'ambulance':
        return 'Book Ambulance';
      case 'bed':
        return 'Book Hospital Bed';
      case 'appointment':
        return 'Book Appointment';
      case 'blood':
        return 'Request Blood';
      default:
        return 'Book Service';
    }
  }

  void _submitBooking() {
    if (_formKey.currentState!.validate()) {
      // Validate specific fields based on booking type
      if (widget.bookingType == 'ambulance' && _selectedAmbulanceType == null) {
        _showError('Please select ambulance type');
        return;
      }
      if (widget.bookingType == 'bed' && _selectedBedType == null) {
        _showError('Please select bed type');
        return;
      }
      if (widget.bookingType == 'appointment') {
        if (_selectedDepartment == null) {
          _showError('Please select department');
          return;
        }
        if (_selectedDate == null) {
          _showError('Please select date');
          return;
        }
        if (_selectedTime == null) {
          _showError('Please select time');
          return;
        }
      }
      if (widget.bookingType == 'blood' && _selectedBloodGroup == null) {
        _showError('Please select blood group');
        return;
      }

      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookingConfirmationScreen(
            bookingType: widget.bookingType,
            name: _nameController.text,
            phone: _phoneController.text,
            address: _addressController.text,
            notes: _notesController.text,
            location: _currentLocation,
            ambulanceType: _selectedAmbulanceType,
            bedType: _selectedBedType,
            department: _selectedDepartment,
            bloodGroup: _selectedBloodGroup,
            hospital: _selectedHospital,
            date: _selectedDate,
            time: _selectedTime,
          ),
        ),
      );
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _getThemeColor().withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(_getIcon(), color: _getThemeColor(), size: 28),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_getTitle(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            const Text('Fill details to proceed', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ),
                      IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Location Status
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(_isLoadingLocation ? Icons.location_searching : Icons.location_on, color: Colors.blue.shade700, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _isLoadingLocation ? 'Retrieving your location...' : 'Location retrieved successfully',
                            style: TextStyle(color: Colors.blue.shade900, fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Type-specific fields
                  if (widget.bookingType == 'ambulance') ...[
                    const Text('Select Ambulance Type *', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.local_hospital),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      hint: const Text('Choose ambulance type'),
                      value: _selectedAmbulanceType,
                      items: ambulanceTypes.map((type) => DropdownMenuItem(value: type, child: Text(type, style: const TextStyle(fontSize: 14)))).toList(),
                      onChanged: (value) => setState(() => _selectedAmbulanceType = value),
                    ),
                    const SizedBox(height: 15),
                  ],

                  if (widget.bookingType == 'bed') ...[
                    const Text('Select Bed Type *', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.hotel),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      hint: const Text('Choose bed type'),
                      value: _selectedBedType,
                      items: bedTypes.map((type) => DropdownMenuItem(value: type, child: Text(type, style: const TextStyle(fontSize: 14)))).toList(),
                      onChanged: (value) => setState(() => _selectedBedType = value),
                    ),
                    const SizedBox(height: 15),
                  ],

                  if (widget.bookingType == 'appointment') ...[
                    const Text('Select Department *', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.local_hospital),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      hint: const Text('Choose department'),
                      value: _selectedDepartment,
                      items: departments.map((dept) => DropdownMenuItem(value: dept, child: Text(dept, style: const TextStyle(fontSize: 14)))).toList(),
                      onChanged: (value) => setState(() => _selectedDepartment = value),
                    ),
                    const SizedBox(height: 15),
                  ],

                  if (widget.bookingType == 'blood') ...[
                    const Text('Select Blood Group *', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: bloodGroups.map((blood) {
                        bool isSelected = _selectedBloodGroup == blood;
                        return InkWell(
                          onTap: () => setState(() => _selectedBloodGroup = blood),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.red.shade100 : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: isSelected ? Colors.red.shade700 : Colors.grey.shade300, width: 2),
                            ),
                            child: Text(
                              blood,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                color: isSelected ? Colors.red.shade700 : Colors.grey.shade700,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 15),
                  ],

                  // Hospital Selection
                  const Text('Select Hospital *', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.local_hospital),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    hint: const Text('Choose hospital'),
                    value: _selectedHospital,
                    items: hospitals.map((hospital) => DropdownMenuItem(value: hospital, child: Text(hospital, style: const TextStyle(fontSize: 14)))).toList(),
                    onChanged: (value) => setState(() => _selectedHospital = value),
                  ),
                  const SizedBox(height: 15),

                  // Date and Time for Appointments
                  if (widget.bookingType == 'appointment') ...[
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Select Date *', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 10),
                              InkWell(
                                onTap: _selectDate,
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade400),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.calendar_today, size: 20),
                                      const SizedBox(width: 8),
                                      Text(
                                        _selectedDate == null ? 'Pick date' : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                                        style: TextStyle(fontSize: 14, color: _selectedDate == null ? Colors.grey : Colors.black87),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Select Time *', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 10),
                              InkWell(
                                onTap: _selectTime,
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade400),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.access_time, size: 20),
                                      const SizedBox(width: 8),
                                      Text(
                                        _selectedTime == null ? 'Pick time' : _selectedTime!.format(context),
                                        style: TextStyle(fontSize: 14, color: _selectedTime == null ? Colors.grey : Colors.black87),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                  ],

                  // Common fields
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name *',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Please enter your name' : null,
                  ),
                  const SizedBox(height: 15),

                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone Number *',
                      prefixIcon: const Icon(Icons.phone),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'Please enter phone number';
                      if (value.length < 10) return 'Please enter valid phone number';
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),

                  TextFormField(
                    controller: _addressController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: 'Address *',
                      prefixIcon: const Icon(Icons.location_city),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Please enter address' : null,
                  ),
                  const SizedBox(height: 15),

                  TextFormField(
                    controller: _notesController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Additional Notes (Optional)',
                      prefixIcon: const Icon(Icons.note),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      hintText: 'Any specific requirements or information...',
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Submit Button
                  ElevatedButton.icon(
                    onPressed: _submitBooking,
                    icon: const Icon(Icons.check_circle, color: Colors.white),
                    label: const Text('CONFIRM BOOKING', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getThemeColor(),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}

// Booking Confirmation Screen
class BookingConfirmationScreen extends StatefulWidget {
  final String bookingType;
  final String name;
  final String phone;
  final String address;
  final String notes;
  final LocationModel? location;
  final String? ambulanceType;
  final String? bedType;
  final String? department;
  final String? bloodGroup;
  final String? hospital;
  final DateTime? date;
  final TimeOfDay? time;

  const BookingConfirmationScreen({
    Key? key,
    required this.bookingType,
    required this.name,
    required this.phone,
    required this.address,
    required this.notes,
    this.location,
    this.ambulanceType,
    this.bedType,
    this.department,
    this.bloodGroup,
    this.hospital,
    this.date,
    this.time,
  }) : super(key: key);

  @override
  State<BookingConfirmationScreen> createState() => _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  String _bookingId = '';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..forward();
    _generateBookingId();
  }

  void _generateBookingId() {
    final now = DateTime.now();
    final typeCode = widget.bookingType.substring(0, 3).toUpperCase();
    _bookingId = '$typeCode${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getThemeColor() {
    switch (widget.bookingType) {
      case 'ambulance':
        return Colors.blue.shade600;
      case 'bed':
        return Colors.purple.shade600;
      case 'appointment':
        return Colors.teal.shade600;
      case 'blood':
        return Colors.red.shade600;
      default:
        return Colors.blue.shade600;
    }
  }

  String _getTitle() {
    switch (widget.bookingType) {
      case 'ambulance':
        return 'Ambulance Booked';
      case 'bed':
        return 'Bed Reserved';
      case 'appointment':
        return 'Appointment Confirmed';
      case 'blood':
        return 'Blood Request Sent';
      default:
        return 'Booking Confirmed';
    }
  }

  String _getSuccessMessage() {
    switch (widget.bookingType) {
      case 'ambulance':
        return 'Your ambulance has been booked successfully. You will receive a call shortly.';
      case 'bed':
        return 'Hospital bed has been reserved. Please visit the hospital for admission.';
      case 'appointment':
        return 'Your appointment has been scheduled. You will receive a confirmation SMS.';
      case 'blood':
        return 'Blood request has been sent to nearby blood banks. You will be notified soon.';
      default:
        return 'Your booking has been confirmed successfully.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _getThemeColor().withOpacity(0.05),
      appBar: AppBar(
        title: const Text('Booking Confirmation', style: TextStyle(color: Colors.white)),
        backgroundColor: _getThemeColor(),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Success Animation
                ScaleTransition(
                  scale: _animationController,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.check_circle, color: Colors.green.shade600, size: 80),
                  ),
                ),

                const SizedBox(height: 30),

                Text(_getTitle(), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _getThemeColor())),
                const SizedBox(height: 10),
                Text(_getSuccessMessage(), textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: Colors.grey)),

                const SizedBox(height: 30),

                // Booking ID Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _getThemeColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _getThemeColor().withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.confirmation_number, color: _getThemeColor(), size: 24),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Booking ID', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          Text(_bookingId, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _getThemeColor())),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Booking Details Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Booking Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),

                      if (widget.ambulanceType != null) ...[
                        _buildDetailRow(Icons.local_hospital, 'Ambulance Type', widget.ambulanceType!),
                        const Divider(height: 30),
                      ],

                      if (widget.bedType != null) ...[
                        _buildDetailRow(Icons.hotel, 'Bed Type', widget.bedType!),
                        const Divider(height: 30),
                      ],

                      if (widget.department != null) ...[
                        _buildDetailRow(Icons.medical_services, 'Department', widget.department!),
                        const Divider(height: 30),
                      ],

                      if (widget.bloodGroup != null) ...[
                        _buildDetailRow(Icons.bloodtype, 'Blood Group', widget.bloodGroup!),
                        const Divider(height: 30),
                      ],

                      if (widget.hospital != null) ...[
                        _buildDetailRow(Icons.local_hospital, 'Hospital', widget.hospital!),
                        const Divider(height: 30),
                      ],

                      if (widget.date != null && widget.time != null) ...[
                        _buildDetailRow(Icons.calendar_today, 'Date & Time', '${widget.date!.day}/${widget.date!.month}/${widget.date!.year} at ${widget.time!.format(context)}'),
                        const Divider(height: 30),
                      ],

                      _buildDetailRow(Icons.person, 'Name', widget.name),
                      const Divider(height: 30),

                      _buildDetailRow(Icons.phone, 'Phone', widget.phone),
                      const Divider(height: 30),

                      _buildDetailRow(Icons.location_on, 'Address', widget.address),

                      if (widget.location != null) ...[
                        const Divider(height: 30),
                        _buildDetailRow(Icons.my_location, 'Coordinates', '${widget.location!.latitude.toStringAsFixed(6)}, ${widget.location!.longitude.toStringAsFixed(6)}'),
                      ],

                      if (widget.notes.isNotEmpty) ...[
                        const Divider(height: 30),
                        _buildDetailRow(Icons.note, 'Notes', widget.notes),
                      ],

                      const Divider(height: 30),
                      _buildDetailRow(Icons.access_time, 'Booked At', '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} ${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}'),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // Share booking details
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Booking details copied to clipboard')),
                          );
                        },
                        icon: Icon(Icons.share, color: _getThemeColor()),
                        label: Text('Share', style: TextStyle(color: _getThemeColor(), fontWeight: FontWeight.w600)),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: _getThemeColor()),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                        icon: const Icon(Icons.home, color: Colors.white),
                        label: const Text('Go Home', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _getThemeColor(),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Support Info
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.support_agent, color: Colors.orange.shade700, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Need Help?', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.orange.shade900)),
                            const SizedBox(height: 4),
                            Text('Contact support: 1800-XXX-XXXX', style: TextStyle(fontSize: 12, color: Colors.orange.shade700)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: _getThemeColor(), size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87)),
            ],
          ),
        ),
      ],
    );
  }
}