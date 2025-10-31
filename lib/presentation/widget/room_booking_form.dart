import 'package:flutter/material.dart';

import '../../core/services/secure_storage_service.dart';
import '../../domain/services/booking_service.dart';
import '../../dto/booking.dart';

class RoomBookingForm extends StatefulWidget {

  final String canteenId;
  final void Function() onReserved;
  final List<RoomBooking> existingBookings;

  const RoomBookingForm({
    super.key,
    required this.canteenId,
    required this.onReserved,
    required this.existingBookings,
  });

  @override
  State<RoomBookingForm> createState() => _RoomBookingFormState();
}

class _RoomBookingFormState extends State<RoomBookingForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  int _people = 1;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  DateTime? _selectedDate;
  bool _isLoading = false;
  final _peopleController = TextEditingController(text: '1');

  @override
  void dispose() {
    _peopleController.dispose();
    super.dispose();
  }


  final bookingService = BookingService();

  bool isSlotAvailable(DateTime date, TimeOfDay start, TimeOfDay end) {
    final newStart = DateTime(date.year, date.month, date.day, start.hour, start.minute);
    final newEnd = DateTime(date.year, date.month, date.day, end.hour, end.minute);

    for (var booking in widget.existingBookings) {
      final existingStart = DateTime.parse("${booking.date}T${booking.startTime}:00");
      final existingEnd = DateTime.parse("${booking.date}T${booking.endTime}:00");

      if (newStart.isBefore(existingEnd) && newEnd.isAfter(existingStart)) {
        return false; // chevauchement
      }
    }
    return true;
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 9, minute: 0),
    );
    if (picked != null) {
      setState(() {
        _startTime = picked;
      });
    }
  }
  Future<void> _pickEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime ?? TimeOfDay(hour: 10, minute: 0),
    );
    if (picked != null) {
      setState(() {
        _endTime = picked;
      });
    }
  }

  String formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod + (time.period == DayPeriod.pm ? 12 : 0);
    final formattedHour = hour.toString().padLeft(2, '0');
    final formattedMinute = time.minute.toString().padLeft(2, '0');
    return "$formattedHour:$formattedMinute";
  }

  Future<void> _tryReserveRoom() async {
    if (!_formKey.currentState!.validate() ||
        _selectedDate == null ||
        _startTime == null ||
        _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez remplir tous les champs")),
      );
      return;
    }

    final start = _startTime!;
    final end = _endTime!;

    // 🔧 Convertir TimeOfDay → DateTime (avec correction pour 12:00 AM / PM)
    DateTime convertToDateTime(DateTime date, TimeOfDay time) {
      int hour = time.hourOfPeriod + (time.period == DayPeriod.pm ? 12 : 0);
      // Correction : si l'utilisateur choisit 12:00 AM → midi
      if (time.period == DayPeriod.am && time.hourOfPeriod == 12) {
        hour = 12;
      }
      return DateTime(date.year, date.month, date.day, hour, time.minute);
    }

    final startDateTime = convertToDateTime(_selectedDate!, start);
    final endDateTime = convertToDateTime(_selectedDate!, end);

    if (!endDateTime.isAfter(startDateTime)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("L'heure de fin doit être après l'heure de début")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final startTimeStr =
          "${startDateTime.hour.toString().padLeft(2, '0')}:${startDateTime.minute.toString().padLeft(2, '0')}";
      final endTimeStr =
          "${endDateTime.hour.toString().padLeft(2, '0')}:${endDateTime.minute.toString().padLeft(2, '0')}";

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
        date: _selectedDate!,
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


  /*Future<void> _tryReserveRoom() async {
    if (!_formKey.currentState!.validate() ||
        _selectedDate == null ||
        _startTime == null ||
        _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez remplir tous les champs")),
      );
      return;
    }

    // 🔧 Conversion correcte en format 24h
    String formatTimeOfDay(TimeOfDay time) {
      int hour = time.hourOfPeriod + (time.period == DayPeriod.pm && time.hourOfPeriod != 12 ? 12 : 0);
      if (time.period == DayPeriod.am && time.hourOfPeriod == 12) hour = 0; // 12 AM = 00:00
      final formattedHour = hour.toString().padLeft(2, '0');
      final formattedMinute = time.minute.toString().padLeft(2, '0');
      return "$formattedHour:$formattedMinute";
    }

    final startTimeStr = formatTimeOfDay(_startTime!);
    final endTimeStr = formatTimeOfDay(_endTime!);

    final bookingDate = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
    );

    // 🧩 Crée des DateTime complets pour comparaison
    final startDateTime = DateTime(
      bookingDate.year,
      bookingDate.month,
      bookingDate.day,
      int.parse(startTimeStr.split(":")[0]),
      int.parse(startTimeStr.split(":")[1]),
    );

    final endDateTime = DateTime(
      bookingDate.year,
      bookingDate.month,
      bookingDate.day,
      int.parse(endTimeStr.split(":")[0]),
      int.parse(endTimeStr.split(":")[1]),
    );

    if (!endDateTime.isAfter(startDateTime)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("L'heure de fin doit être après l'heure de début ⏰")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
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
  }*/


  /*Future<void> _tryReserveRoom() async {
    if (!_formKey.currentState!.validate() ||
        _selectedDate == null ||
        _startTime == null ||
        _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez remplir tous les champs")),
      );
      return;
    }

    final start = _startTime!;
    final end = _endTime!;

    //final now = DateTime.now();
    //final startDateTime = DateTime(now.year, now.month, now.day, start.hour, start.minute);
    //final endDateTime = DateTime(now.year, now.month, now.day, end.hour, end.minute);

    final startTimeStr = formatTimeOfDay(start);
    final endTimeStr = formatTimeOfDay(end);
    /*final startDateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      start.hour,
      start.minute,
    );
    final endDateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      end.hour,
      end.minute,
    );*/

    /*if (!endDateTime.isAfter(startDateTime)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("L'heure de fin doit être après l'heure de débuteee")),
      );
      return;
    }*/
    /*if (end.hour < start.hour ||
        (end.hour == start.hour && end.minute <= start.minute)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("L'heure de fin doit être après l'heure de début"),
        ),
      );
      return;
    }*/

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
  }*/

  /*Future<void> _pickDate() async {
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
      initialTime: _startTime ?? TimeOfDay.now(),
    );
    if (picked != null) setState(() => _endTime = picked);
  }*/

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
                                _startTime != null
                                    ? _startTime!.format(context)
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
                                _endTime != null
                                    ? _endTime!.format(context)
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
