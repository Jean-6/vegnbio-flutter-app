import 'package:flutter/material.dart';
import 'package:vegnbio/core/services/secure_storage_service.dart';

import '../../domain/services/booking_service.dart';

class TableBookingForm extends StatefulWidget {
  final VoidCallback onReserved;
  final String canteenId;

  const TableBookingForm({
    super.key,
    required this.onReserved,
    required this.canteenId,
  });

  @override
  State<TableBookingForm> createState() => _TableBookingFormState();
}

class _TableBookingFormState extends State<TableBookingForm> {
  final bookingService = BookingService();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  int _people = 1;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _isLoading = false;

  Future<void> _tryReserveTable() async {
    if (!_formKey.currentState!.validate() ||
        _selectedDate == null ||
        _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez remplir tous les champs.")),
      );
      return;
    }
    setState(() => _isLoading = true);

    try {
      final bookingDate = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
      );

      final bookingTime =
          "${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}";

      final userId = await SecureStorageService.getUserId();
      if (userId == null || userId.isEmpty) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Utilisateur non connecté")),
        );
        return;
      }

      final result = await bookingService.reserveTable(
        canteenId: widget.canteenId,
        name: _nameController.text.trim(),
        startTime: bookingTime,
        date: bookingDate,
        people: _people,
        userId: userId,
      );

      setState(() => _isLoading = false);

      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Table réservée avec succès ✅")),
        );
        widget.onReserved();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erreur lors de la réservation ❌")),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erreur: $e")));
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color(0xFF4CAF50); // 🌿 Vert VegNBio

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        elevation: 0,
        title: const Text("Réservation de table", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[100],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /*const Text(
                        "Réserver une table 🍽️",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),*/
                      //const SizedBox(height: 20),
                      // Champ Nom
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: "Votre nom",
                          prefixIcon: const Icon(
                            Icons.person,
                            color: Colors.grey,
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? "Nom requis"
                            : null,
                      ),
                      const SizedBox(height: 16),

                      // Personnes
                      Row(
                        children: [
                          const Icon(Icons.group, color: Colors.grey),
                          const SizedBox(width: 12),
                          const Text(
                            "Nombre de personnes : ",
                            style: TextStyle(fontSize: 16),
                          ),
                          const Spacer(),
                          DropdownButton<int>(
                            value: _people,
                            borderRadius: BorderRadius.circular(12),
                            items: List.generate(
                              10,
                              (i) => DropdownMenuItem(
                                value: i + 1,
                                child: Text("${i + 1}"),
                              ),
                            ),
                            onChanged: (value) =>
                                setState(() => _people = value!),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Date & Heure
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              icon: const Icon(
                                Icons.calendar_today,
                                color: Colors.black54,
                              ),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                side: BorderSide(color: themeColor),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: _pickDate,
                              label: Text(
                                _selectedDate != null
                                    ? "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"
                                    : "Choisir une date",
                                style: const TextStyle(color: Colors.black87),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: OutlinedButton.icon(
                              icon: const Icon(
                                Icons.access_time,
                                color: Colors.black54,
                              ),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                side: BorderSide(color: themeColor),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: _pickTime,
                              label: Text(
                                _selectedTime != null
                                    ? _selectedTime!.format(context)
                                    : "Choisir une heure",
                                style: const TextStyle(color: Colors.black87),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: themeColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _isLoading ? null : _tryReserveTable,
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  "Confirmer la réservation",
                                  style: TextStyle(fontSize: 16),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
