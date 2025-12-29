import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../services/api_service.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class BookingFormPage extends StatefulWidget {
  final int tripId;
  
  const BookingFormPage({
    super.key,
    required this.tripId,
  });

  @override
  State<BookingFormPage> createState() => _BookingFormPageState();
}

class _BookingFormPageState extends State<BookingFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();
  
  // Form controllers
  final _descriptionController = TextEditingController();
  final _weightController = TextEditingController();
  final _pickupAddressController = TextEditingController();
  final _pickupCityController = TextEditingController();
  final _deliveryAddressController = TextEditingController();
  final _deliveryCityController = TextEditingController();
  final _recipientNameController = TextEditingController();
  final _recipientPhoneController = TextEditingController();
  final _notesController = TextEditingController();
  
  // State variables
  String _itemType = '';
  Map<String, dynamic>? _trip;
  bool _loading = true;
  String _error = '';
  File? _packagePhoto;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fetchTrip();
  }

  Future<void> _fetchTrip() async {
    try {
      final trip = await _apiService.getTripById(widget.tripId);
      setState(() {
        _trip = trip;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Map<String, double> _calculateTotal() {
    if (_trip == null || _weightController.text.isEmpty) {
      return {'transportFee': 0, 'serviceFee': 0, 'total': 0};
    }
    
    final weight = double.tryParse(_weightController.text) ?? 0;
    final pricePerKg = (_trip!['price_per_kg'] ?? 0).toDouble();
    final transportFee = pricePerKg * weight;
    final serviceFee = transportFee * 0.1; // 10% service fee
    
    return {
      'transportFee': transportFee,
      'serviceFee': serviceFee,
      'total': transportFee + serviceFee,
    };
  }

  Future<void> _handlePhotoUpload() async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
      
      if (image != null) {
        final file = File(image.path);
        final fileSize = await file.length();
        
        // Check file size (max 5MB)
        if (fileSize > 5 * 1024 * 1024) {
          setState(() {
            _error = 'Image size must be less than 5MB';
          });
          return;
        }
        
        setState(() {
          _packagePhoto = file;
          _error = '';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error uploading photo: $e';
      });
    }
  }

  void _removePhoto() {
    setState(() {
      _packagePhoto = null;
    });
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final bookingData = {
        'trip_id': widget.tripId,
        'weight': double.parse(_weightController.text),
        'item_type': _itemType,
        'description': _descriptionController.text,
        'pickup_address': _pickupAddressController.text,
        'pickup_city': _pickupCityController.text,
        'delivery_address': _deliveryAddressController.text,
        'delivery_city': _deliveryCityController.text,
        'recipient_name': _recipientNameController.text,
        'recipient_phone': _recipientPhoneController.text,
        'notes': _notesController.text.isEmpty ? null : _notesController.text,
      };

      await _apiService.createBooking(
        tripId: widget.tripId,
        weight: double.parse(_weightController.text),
        itemType: _itemType,
        pickupAddress: _pickupAddressController.text,
        pickupCity: _pickupCityController.text,
        deliveryAddress: _deliveryAddressController.text,
        deliveryCity: _deliveryCityController.text,
        recipientName: _recipientNameController.text,
        recipientPhone: _recipientPhoneController.text,
        description: _descriptionController.text,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );
      
      if (!mounted) return;
      
      // Show success dialog puis rediriger vers My Bookings
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('✅ Réservation envoyée'),
          content: const Text(
            '💡 Important: Vous ne paierez QU\'APRÈS que le transporteur accepte votre demande.\n\n'
            '🔒 Votre argent est protégé - aucun paiement avant confirmation!'
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                context.go('/my-bookings'); // Rediriger vers My Bookings comme sur web
              },
              child: const Text('Voir mes réservations'),
            ),
          ],
        ),
      );
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _weightController.dispose();
    _pickupAddressController.dispose();
    _pickupCityController.dispose();
    _deliveryAddressController.dispose();
    _deliveryCityController.dispose();
    _recipientNameController.dispose();
    _recipientPhoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Book Transport',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _trip == null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      _error.isEmpty ? 'Trip not found' : _error,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                )
              : Stack(
                  children: [
                    SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Trip Summary Header
                          Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF0066FF), Color(0xFF0052CC)],
                              ),
                            ),
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Trip Summary',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${_trip!['origin_city']} → ${_trip!['destination_city']}',
                                  style: const TextStyle(
                                    color: Color(0xFFBBDDFF),
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _formatDate(_trip!['departure_date']),
                                  style: const TextStyle(
                                    color: Color(0xFFBBDDFF),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Form(
                            key: _formKey,
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Error message
                                  if (_error.isNotEmpty)
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 16),
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFEE2E2),
                                        border: Border.all(color: const Color(0xFFFECACA)),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        _error,
                                        style: const TextStyle(color: Color(0xFFDC2626)),
                                      ),
                                    ),

                                  // Package Details Section
                                  const Text(
                                    'Package Details',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // Item Type Dropdown
                                  DropdownButtonFormField<String>(
                                    value: _itemType.isEmpty ? null : _itemType,
                                    decoration: InputDecoration(
                                      labelText: 'Item Type',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(color: Color(0xFF0066FF), width: 2),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    items: const [
                                      DropdownMenuItem(value: 'Documents', child: Text('Documents')),
                                      DropdownMenuItem(value: 'Clothing', child: Text('Clothing')),
                                      DropdownMenuItem(value: 'Electronics', child: Text('Electronics')),
                                      DropdownMenuItem(value: 'Food', child: Text('Food')),
                                      DropdownMenuItem(value: 'Other', child: Text('Other')),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        _itemType = value ?? '';
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please select item type';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),

                                  // Description
                                  TextFormField(
                                    controller: _descriptionController,
                                    decoration: InputDecoration(
                                      labelText: 'Item Description',
                                      hintText: 'Describe your package...',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    maxLines: 3,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter description';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),

                                  // Weight
                                  TextFormField(
                                    controller: _weightController,
                                    decoration: InputDecoration(
                                      labelText: 'Weight (kg) *',
                                      hintText: '0.0',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(width: 2),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                                    ],
                                    onChanged: (value) {
                                      setState(() {}); // Rebuild to update price calculation
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter weight';
                                      }
                                      final weight = double.tryParse(value);
                                      if (weight == null || weight <= 0) {
                                        return 'Please enter valid weight';
                                      }
                                      final maxWeight = (_trip!['available_weight'] ?? 0).toDouble();
                                      if (weight > maxWeight) {
                                        return 'Max weight: $maxWeight kg';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Max: ${_trip!['available_weight']} kg available',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF6B7280),
                                        ),
                                      ),
                                      if (_weightController.text.isNotEmpty && 
                                          double.tryParse(_weightController.text) != null &&
                                          double.parse(_weightController.text) > 0)
                                        Text(
                                          '= ${_calculateTotal()['transportFee']!.toStringAsFixed(2)}€',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF0066FF),
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),

                                  // Package Photo
                                  const Text(
                                    'Package Photo (Optional)',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(height: 8),
                                  if (_packagePhoto == null)
                                    GestureDetector(
                                      onTap: _handlePhotoUpload,
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(vertical: 32),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: const Color(0xFFE5E7EB),
                                            width: 2,
                                            style: BorderStyle.solid,
                                          ),
                                        ),
                                        child: const Column(
                                          children: [
                                            Icon(Icons.upload, size: 32, color: Color(0xFF9CA3AF)),
                                            SizedBox(height: 8),
                                            Text(
                                              'Upload package photo',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Color(0xFF6B7280),
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              'Max 5MB (JPG, PNG)',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF9CA3AF),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  else
                                    Stack(
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          height: 200,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(color: const Color(0xFFE5E7EB)),
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(12),
                                            child: Image.file(
                                              _packagePhoto!,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: GestureDetector(
                                            onTap: _removePhoto,
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: const BoxDecoration(
                                                color: Colors.red,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.close,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  const SizedBox(height: 24),

                                  // Special Notes
                                  TextFormField(
                                    controller: _notesController,
                                    decoration: InputDecoration(
                                      labelText: 'Special Notes (Optional)',
                                      hintText: 'Any special instructions...',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    maxLines: 2,
                                  ),
                                  const SizedBox(height: 32),

                                  // Pickup Information Section
                                  const Text(
                                    'Pickup Information',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // Pickup Address
                                  TextFormField(
                                    controller: _pickupAddressController,
                                    decoration: InputDecoration(
                                      labelText: 'Pickup Address',
                                      hintText: 'Enter pickup address',
                                      prefixIcon: const Icon(Icons.location_on, color: Color(0xFF9CA3AF)),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter pickup address';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),

                                  // Pickup City
                                  TextFormField(
                                    controller: _pickupCityController,
                                    decoration: InputDecoration(
                                      labelText: 'Pickup City',
                                      hintText: 'Enter pickup city',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter pickup city';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 32),

                                  // Delivery Information Section
                                  const Text(
                                    'Delivery Information',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // Recipient Name
                                  TextFormField(
                                    controller: _recipientNameController,
                                    decoration: InputDecoration(
                                      labelText: 'Recipient Name',
                                      hintText: 'Full name of recipient',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter recipient name';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),

                                  // Recipient Phone
                                  TextFormField(
                                    controller: _recipientPhoneController,
                                    decoration: InputDecoration(
                                      labelText: 'Recipient Phone',
                                      hintText: '+33 6 12 34 56 78',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    keyboardType: TextInputType.phone,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter recipient phone';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),

                                  // Delivery Address
                                  TextFormField(
                                    controller: _deliveryAddressController,
                                    decoration: InputDecoration(
                                      labelText: 'Delivery Address',
                                      hintText: 'Enter delivery address',
                                      prefixIcon: const Icon(Icons.location_on, color: Color(0xFF9CA3AF)),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter delivery address';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),

                                  // Delivery City
                                  TextFormField(
                                    controller: _deliveryCityController,
                                    decoration: InputDecoration(
                                      labelText: 'Delivery City',
                                      hintText: 'Enter delivery city',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter delivery city';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 32),

                                  // Reservation Summary
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          const Color(0xFFDEEBFF),
                                          Colors.white,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      border: Border.all(
                                        color: const Color(0xFF0066FF),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Reservation Summary',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        _buildSummaryRow(
                                          'Price per kg',
                                          '${_trip!['price_per_kg']}€/kg',
                                        ),
                                        const SizedBox(height: 12),
                                        _buildSummaryRow(
                                          'Weight',
                                          '${_weightController.text.isEmpty ? 0 : _weightController.text} kg',
                                        ),
                                        const SizedBox(height: 12),
                                        _buildSummaryRow(
                                          'Subtotal',
                                          '${_calculateTotal()['transportFee']!.toStringAsFixed(2)}€',
                                        ),
                                        const SizedBox(height: 12),
                                        _buildSummaryRow(
                                          'Service fee (10%)',
                                          '${_calculateTotal()['serviceFee']!.toStringAsFixed(2)}€',
                                        ),
                                        const Divider(height: 32, thickness: 2),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Total',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              '${_calculateTotal()['total']!.toStringAsFixed(2)}€',
                                              style: const TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF0066FF),
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (_weightController.text.isNotEmpty && 
                                            double.tryParse(_weightController.text) != null &&
                                            double.parse(_weightController.text) > 0)
                                          Container(
                                            margin: const EdgeInsets.only(top: 12),
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF0FDF4),
                                              border: Border.all(color: const Color(0xFFBBF7D0)),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              '✓ Cost calculated: ${_weightController.text} kg × ${_trip!['price_per_kg']}€ = ${_calculateTotal()['transportFee']!.toStringAsFixed(2)}€',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF15803D),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Fixed Bottom Buttons
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            top: BorderSide(color: const Color(0xFFE5E7EB)),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, -2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: SafeArea(
                          child: Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => Navigator.pop(context),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    side: const BorderSide(
                                      color: Color(0xFFD1D5DB),
                                      width: 2,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'Back',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF374151),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 2,
                                child: ElevatedButton(
                                  onPressed: _weightController.text.isEmpty ||
                                          double.tryParse(_weightController.text) == null ||
                                          double.parse(_weightController.text) <= 0
                                      ? null
                                      : _handleSubmit,
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    backgroundColor: const Color(0xFF0066FF),
                                    disabledBackgroundColor: const Color(0xFFD1D5DB),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Proceed to Payment',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                      if (_weightController.text.isNotEmpty && 
                                          double.tryParse(_weightController.text) != null &&
                                          double.parse(_weightController.text) > 0)
                                        Container(
                                          margin: const EdgeInsets.only(left: 8),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            '${_calculateTotal()['total']!.toStringAsFixed(2)}€',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF6B7280),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateStr;
    }
  }
}
