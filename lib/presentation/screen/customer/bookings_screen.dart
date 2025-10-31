import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:vegnbio/dto/booking.dart';
import 'package:vegnbio/presentation/widget/booking_card.dart';

import '../../../core/constants/values.dart';
import '../../../core/services/secure_storage_service.dart';
import '../../../domain/services/booking_service.dart';
import '../../../dto/booking_filter.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  _BookingsScreenState createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  final _formKey = GlobalKey<FormState>();

  final logger = Logger();
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  String? _selectedType;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isLoading = false;
  List<Booking> filteredBookings = [];

  Future<void> _pickDate(bool isAvailability) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isAvailability) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _filterBooking() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final userId = await SecureStorageService.getUserId();
      if (userId == null) {
        logger.d("User id not found");
        return null;
      }
      final filters = BookingFilter(
        type: _selectedType,
        startDate: _startDate,
        endDate: _endDate,
        userId: userId,
      );

      final bookings = await BookingService().fetchWithFilters(
        bookingFilter: filters,
      );
      setState(() {
        filteredBookings = bookings!;
      });

      
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error : ${e.toString()}')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _filterBooking();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Rechercher une reservation",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF4CAF50),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  /// Dropdown restaurant
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Color(0xFF4CAF50),
                                width: 2,
                              ),
                            ),
                            hintStyle: TextStyle(color: Colors.grey.shade500),
                            labelText: "Type de reservation",
                          ),
                          value: _selectedType,
                          items: bookingType
                              .map(
                                (type) => DropdownMenuItem<String>(
                                  value: type,
                                  child: Text(type),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedType = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  /// Dropdown type de plat
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _pickDate(true),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Color(0xFFE0E0E0)),
                            ),
                            child: Text(
                              _startDate == null
                                  ? "Debut"
                                  : "${_startDate!.day}/${_startDate!.month}/${_startDate!.year}",
                              style: TextStyle(
                                color: _startDate == null
                                    ? Colors.grey.shade500
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 25),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _pickDate(false),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Color(0xFFE0E0E0)),
                            ),
                            child: Text(
                              _endDate == null
                                  ? "Date de fin"
                                  : "${_endDate!.day}/${_endDate!.month}/${_endDate!.year}",
                              style: TextStyle(
                                color: _endDate == null
                                    ? Colors.grey.shade500
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _filterBooking,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: const Icon(Icons.search, color: Colors.white),
                      label: const Text(
                        "Rechercher",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Result
          Expanded(
            flex: 7,
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : filteredBookings.isEmpty
                ? Text("No booking found ")
                : ListView.builder(
                    itemCount: filteredBookings.length,
                    itemBuilder: (context, index) {
                      final item = filteredBookings[index];
                      return BookingCard(booking: item, onTap: () {});
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
