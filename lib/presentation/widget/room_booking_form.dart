import 'package:flutter/material.dart';

import '../../core/services/secure_storage_service.dart';
import '../../domain/services/booking_service.dart';

class RoomBookingForm extends StatefulWidget {
  final VoidCallback onReserved;
  final String canteenId;

  const RoomBookingForm({
    super.key,
    required this.onReserved,
    required this.canteenId,
  });

  @override
  State<RoomBookingForm> createState() => _RoomBookingFormState();
}

class _RoomBookingFormState extends State<RoomBookingForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  int _people = 1;
  TimeOfDay? _selectedStartTime;
  TimeOfDay? _selectedEndTime;
  DateTime? _selectedDate;
  bool _isLoading = false;

  final bookingService = BookingService();

  Future<void> _tryReserveRoom() async {
    if (!_formKey.currentState!.validate() ||
        _selectedDate == null ||
        _selectedStartTime == null ||
        _selectedEndTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez remplir tous les champs")),
      );
      return;
    }

    final start = _selectedStartTime!;
    final end = _selectedEndTime!;

    if (end.hour < start.hour ||
        (end.hour == start.hour && end.minute <= start.minute)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("L'heure de fin doit être après l'heure de début"),
        ),
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

      final startTimeStr =
          "${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}";
      final endTimeStr =
          "${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}";

      final userId = await SecureStorageService.getUserId();
      if (userId == null || userId.isEmpty) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Utilisateur non connecté")),
        );
        return;
      }

      final result = await bookingService.reserveRoom(
        canteenId: widget.canteenId,
        name: _nameController.text.trim(),
        startTime: startTimeStr,
        endTime: endTimeStr,
        date: bookingDate,
        people: _people,
        userId: userId,
      );

      setState(() => _isLoading = false);

      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Salle réservée avec succès ✅")),
        );
        widget.onReserved();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erreur lors de la réservation ❌")),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Erreur: $e")));
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

  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => _selectedStartTime = picked);
  }

  Future<void> _pickEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedStartTime ?? TimeOfDay.now(),
    );
    if (picked != null) setState(() => _selectedEndTime = picked);
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color(0xFF4CAF50); // 🌿 Vert VegNBio

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        elevation: 0,
        title: const Text(
          "Réservation de salle",
          style: TextStyle(color: Colors.white),
        ),
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
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /*const Text(
                        "Réserver une salle 🏢",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 20),*/

                      // Nom
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: "Nom de l'organisateur",
                          prefixIcon: const Icon(Icons.person, color: Colors.grey),
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) =>
                        value == null || value.isEmpty ? "Nom requis" : null,
                      ),
                      const SizedBox(height: 16),

                      // Participants
                      Row(
                        children: [
                          const Icon(Icons.group, color: Colors.grey),
                          const SizedBox(width: 12),
                          const Text("Participants : ", style: TextStyle(fontSize: 16)),
                          const Spacer(),
                          DropdownButton<int>(
                            value: _people,
                            borderRadius: BorderRadius.circular(12),
                            items: List.generate(
                              50,
                                  (i) => DropdownMenuItem(
                                value: i + 1,
                                child: Text("${i + 1}"),
                              ),
                            ),
                            onChanged: (value) => setState(() => _people = value!),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Date & Heure
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.calendar_today, color: Colors.black54),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
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
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.access_time, color: Colors.black54),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                side: BorderSide(color: themeColor),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: _pickStartTime,
                              label: Text(
                                _selectedStartTime != null
                                    ? _selectedStartTime!.format(context)
                                    : "Heure de début",
                                style: const TextStyle(color: Colors.black87),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.access_time, color: Colors.black54),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                side: BorderSide(color: themeColor),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: _pickEndTime,
                              label: Text(
                                _selectedEndTime != null
                                    ? _selectedEndTime!.format(context)
                                    : "Heure de fin",
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
                          onPressed: _isLoading ? null : _tryReserveRoom,
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
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
