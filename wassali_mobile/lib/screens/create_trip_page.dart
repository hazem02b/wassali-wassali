import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/api_service.dart';

class CreateTripPage extends StatefulWidget {
  final int? tripId; // For editing existing trip

  const CreateTripPage({
    super.key,
    this.tripId,
  });

  @override
  State<CreateTripPage> createState() => _CreateTripPageState();
}

class _CreateTripPageState extends State<CreateTripPage> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();
  
  // Form controllers
  final _originController = TextEditingController();
  final _destinationController = TextEditingController();
  final _availableWeightController = TextEditingController();
  final _pricePerKgController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  // State variables
  String _departureDate = '';
  String _departureTime = '';
  String _vehicleType = '';
  String _tripType = 'one-time';
  bool _negotiable = false;
  bool _insurance = false;
  List<String> _acceptedItems = [];
  bool _loading = false;
  String _error = '';
  bool _isEditing = false;

  final List<String> _vehicleTypes = ['Car', 'Van', 'Truck', 'Motorcycle'];
  final List<String> _itemTypes = ['Documents', 'Clothes', 'Electronics', 'Food', 'Books', 'Furniture'];

  @override
  void initState() {
    super.initState();
    if (widget.tripId != null) {
      _isEditing = true;
      _loadTripData();
    }
  }

  Future<void> _loadTripData() async {
    try {
      final trip = await _apiService.getTripById(widget.tripId!);
      
      setState(() {
        _originController.text = '${trip['origin_city']}, ${trip['origin_country']}';
        _destinationController.text = '${trip['destination_city']}, ${trip['destination_country']}';
        
        final datetime = DateTime.parse(trip['departure_date']);
        _departureDate = datetime.toIso8601String().split('T')[0];
        _departureTime = '${datetime.hour.toString().padLeft(2, '0')}:${datetime.minute.toString().padLeft(2, '0')}';
        
        _availableWeightController.text = trip['max_weight'].toString();
        _pricePerKgController.text = trip['price_per_kg'].toString();
        _vehicleType = trip['vehicle_info'] ?? '';
        _descriptionController.text = trip['description'] ?? '';
        
        if (trip['accepted_items'] != null) {
          _acceptedItems = List<String>.from(trip['accepted_items']);
        }
      });
    } catch (e) {
      setState(() {
        _error = 'Error loading trip: $e';
      });
    }
  }

  void _toggleItem(String item) {
    setState(() {
      if (_acceptedItems.contains(item)) {
        _acceptedItems.remove(item);
      } else {
        _acceptedItems.add(item);
      }
    });
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_vehicleType.isEmpty) {
      setState(() {
        _error = 'Please select a vehicle type';
      });
      return;
    }

    if (_departureDate.isEmpty || _departureTime.isEmpty) {
      setState(() {
        _error = 'Please select departure date and time';
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = '';
    });

    try {
      // Combine date and time
      final departureDatetime = '${_departureDate}T$_departureTime:00';

      final originParts = _originController.text.split(',');
      final destinationParts = _destinationController.text.split(',');

      final description = _descriptionController.text.isEmpty
          ? '${_originController.text} to ${_destinationController.text} - $_vehicleType'
          : _descriptionController.text;

      final originCity = originParts[0].trim();
      final originCountry = originParts.length > 1 ? originParts[1].trim() : 'Morocco';
      final destinationCity = destinationParts[0].trim();
      final destinationCountry = destinationParts.length > 1 ? destinationParts[1].trim() : 'France';

      if (_isEditing && widget.tripId != null) {
        await _apiService.updateTrip(
          id: widget.tripId!,
          originCity: originCity,
          originCountry: originCountry,
          destinationCity: destinationCity,
          destinationCountry: destinationCountry,
          departureDate: departureDatetime,
          maxWeight: double.parse(_availableWeightController.text),
          pricePerKg: double.parse(_pricePerKgController.text),
          vehicleType: _vehicleType,
          description: description,
        );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Trajet mis à jour avec succès!')),
        );
      } else {
        await _apiService.createTrip(
          originCity: originCity,
          originCountry: originCountry,
          destinationCity: destinationCity,
          destinationCountry: destinationCountry,
          departureDate: departureDatetime,
          maxWeight: double.parse(_availableWeightController.text),
          pricePerKg: double.parse(_pricePerKgController.text),
          vehicleType: _vehicleType,
          description: description,
        );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Trajet créé avec succès!')),
        );
      }

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _originController.dispose();
    _destinationController.dispose();
    _availableWeightController.dispose();
    _pricePerKgController.dispose();
    _descriptionController.dispose();
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
        title: Text(
          _isEditing ? 'Edit Trip' : 'Post New Trip',
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
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

                // Route Information
                const Text(
                  'Route Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _originController,
                  decoration: InputDecoration(
                    hintText: 'From (e.g., Paris, France)',
                    prefixIcon: const Icon(Icons.location_on, color: Color(0xFF9CA3AF)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter origin';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _destinationController,
                  decoration: InputDecoration(
                    hintText: 'To (e.g., Casablanca, Morocco)',
                    prefixIcon: const Icon(Icons.location_on, color: Color(0xFF9CA3AF)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter destination';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Schedule
                const Text(
                  'Schedule',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          );
                          if (date != null) {
                            setState(() {
                              _departureDate = date.toIso8601String().split('T')[0];
                            });
                          }
                        },
                        child: AbsorbPointer(
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: _departureDate.isEmpty ? 'Date' : _departureDate,
                              prefixIcon: const Icon(Icons.calendar_today, color: Color(0xFF9CA3AF)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            validator: (value) {
                              if (_departureDate.isEmpty) {
                                return 'Select date';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (time != null) {
                            setState(() {
                              _departureTime = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                            });
                          }
                        },
                        child: AbsorbPointer(
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: _departureTime.isEmpty ? 'Time' : _departureTime,
                              prefixIcon: const Icon(Icons.access_time, color: Color(0xFF9CA3AF)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            validator: (value) {
                              if (_departureTime.isEmpty) {
                                return 'Select time';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Capacity & Pricing
                const Text(
                  'Capacity & Pricing',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _availableWeightController,
                  decoration: InputDecoration(
                    hintText: 'Total capacity (kg)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter capacity';
                    }
                    if (double.tryParse(value) == null || double.parse(value) <= 0) {
                      return 'Please enter valid capacity';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                TextFormField(
                  controller: _pricePerKgController,
                  decoration: InputDecoration(
                    hintText: 'Price per kg (€)',
                    prefixIcon: const Icon(Icons.euro, color: Color(0xFF9CA3AF)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter price';
                    }
                    if (double.tryParse(value) == null || double.parse(value) <= 0) {
                      return 'Please enter valid price';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                DropdownButtonFormField<String>(
                  value: _vehicleType.isEmpty ? null : _vehicleType,
                  decoration: InputDecoration(
                    hintText: 'Select vehicle type',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: _vehicleTypes.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _vehicleType = value ?? '';
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select vehicle type';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                CheckboxListTile(
                  value: _negotiable,
                  onChanged: (value) {
                    setState(() {
                      _negotiable = value ?? false;
                    });
                  },
                  title: const Text(
                    'Price negotiable',
                    style: TextStyle(fontSize: 14),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: 24),

                // Trip Type
                const Text(
                  'Trip Type',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),

                Column(
                  children: [
                    _buildTripTypeOption('one-time', 'One Time'),
                    const SizedBox(height: 8),
                    _buildTripTypeOption('weekly', 'Weekly'),
                    const SizedBox(height: 8),
                    _buildTripTypeOption('monthly', 'Monthly'),
                  ],
                ),
                const SizedBox(height: 24),

                // Accepted Items
                const Text(
                  'Accepted Items',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),

                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  children: _itemTypes.map((item) {
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Checkbox(
                            value: _acceptedItems.contains(item),
                            onChanged: (value) => _toggleItem(item),
                            activeColor: const Color(0xFFFF9500),
                          ),
                          Expanded(
                            child: Text(
                              item,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // Additional Info
                const Text(
                  'Additional Information',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),

                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Description (optional)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),

                CheckboxListTile(
                  value: _insurance,
                  onChanged: (value) {
                    setState(() {
                      _insurance = value ?? false;
                    });
                  },
                  title: const Text(
                    'Offer insurance coverage',
                    style: TextStyle(fontSize: 14),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: 32),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(color: Color(0xFFD1D5DB)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
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
                      child: ElevatedButton(
                        onPressed: _loading ? null : _handleSubmit,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: const Color(0xFFFF9500),
                          disabledBackgroundColor: const Color(0xFFD1D5DB),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          _loading
                              ? 'Posting...'
                              : (_isEditing ? 'Update Trip' : 'Publish Trip'),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTripTypeOption(String value, String label) {
    final isSelected = _tripType == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _tripType = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFF7ED) : Colors.white,
          border: Border.all(
            color: isSelected ? const Color(0xFFFF9500) : const Color(0xFFE5E7EB),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: isSelected ? const Color(0xFFFF9500) : Colors.black,
          ),
        ),
      ),
    );
  }
}
