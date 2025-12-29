import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/language_provider.dart';
import '../services/api_service.dart';

class CreateTripPage extends StatefulWidget {
  const CreateTripPage({super.key});

  @override
  State<CreateTripPage> createState() => _CreateTripPageState();
}

class _CreateTripPageState extends State<CreateTripPage> {
  final _apiService = ApiService();
  final _formKey = GlobalKey<FormState>();
  
  final _departureCityController = TextEditingController();
  final _arrivalCityController = TextEditingController();
  final _totalSpaceController = TextEditingController();
  final _pricePerKgController = TextEditingController();
  
  DateTime? _departureDate;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );

    if (picked != null) {
      if (!mounted) return;
      
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null && mounted) {
        setState(() {
          _departureDate = DateTime(
            picked.year,
            picked.month,
            picked.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _handleCreateTrip() async {
    if (!_formKey.currentState!.validate()) return;

    if (_departureDate == null) {
      setState(() {
        _errorMessage = Provider.of<LanguageProvider>(context, listen: false).t('select_date');
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _apiService.createTrip(
        originCity: _departureCityController.text.trim(),
        originCountry: 'Tunisia',  // Default value
        destinationCity: _arrivalCityController.text.trim(),
        destinationCountry: 'France',  // Default value
        departureDate: _departureDate!,
        maxWeight: double.parse(_totalSpaceController.text.trim()),
        pricePerKg: double.parse(_pricePerKgController.text.trim()),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(Provider.of<LanguageProvider>(context, listen: false).t('trip_created')),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageProvider>(context);
    final dateFormat = DateFormat('EEEE, dd MMMM yyyy à HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: Text(lang.t('create_trip')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                lang.t('new_trip_info'),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                lang.t('fill_trip_details'),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 32),

              // Departure City
              TextFormField(
                controller: _departureCityController,
                decoration: InputDecoration(
                  labelText: lang.t('departure_city'),
                  prefixIcon: const Icon(Icons.location_on),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return lang.t('field_required');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Arrival City
              TextFormField(
                controller: _arrivalCityController,
                decoration: InputDecoration(
                  labelText: lang.t('arrival_city'),
                  prefixIcon: const Icon(Icons.flag),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return lang.t('field_required');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Departure Date
              InkWell(
                onTap: _selectDate,
                borderRadius: BorderRadius.circular(12),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: lang.t('departure_date'),
                    prefixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                  ),
                  child: Text(
                    _departureDate == null
                        ? lang.t('select_date_time')
                        : dateFormat.format(_departureDate!),
                    style: TextStyle(
                      color: _departureDate == null ? Colors.grey : null,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Total Space
              TextFormField(
                controller: _totalSpaceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: lang.t('total_space_kg'),
                  prefixIcon: const Icon(Icons.scale),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  suffixText: 'kg',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return lang.t('field_required');
                  }
                  final number = double.tryParse(value.trim());
                  if (number == null || number <= 0) {
                    return lang.t('invalid_number');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Price per KG
              TextFormField(
                controller: _pricePerKgController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: lang.t('price_per_kg'),
                  prefixIcon: const Icon(Icons.attach_money),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  suffixText: 'TND/kg',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return lang.t('field_required');
                  }
                  final number = double.tryParse(value.trim());
                  if (number == null || number <= 0) {
                    return lang.t('invalid_number');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Error Message
              if (_errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),

              // Create Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _handleCreateTrip,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : const Icon(Icons.check_circle),
                  label: Text(
                    lang.t('create_trip'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF9500),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Info Box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF9500).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFFF9500).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: Color(0xFFFF9500),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        lang.t('trip_creation_info'),
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
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
    );
  }

  @override
  void dispose() {
    _departureCityController.dispose();
    _arrivalCityController.dispose();
    _totalSpaceController.dispose();
    _pricePerKgController.dispose();
    super.dispose();
  }
}
