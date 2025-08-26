import 'package:flutter/material.dart';
import 'package:vegnbio/core/services/secure_storage_service.dart';

import '../../domain/services/booking_service.dart';

class TableReservationForm extends StatefulWidget {
  final VoidCallback onReserved;
  final String canteenId;

  const TableReservationForm({
    super.key,
    required this.onReserved,
    required this.canteenId,
  });

  @override
  State<TableReservationForm> createState() => _TableReservationFormState();
}

class _TableReservationFormState extends State<TableReservationForm> {

  final bookingService = BookingService();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();


  int _people = 1; // pas final, car modifiable
  DateTime? _selectedDate; // on stocke la date
  TimeOfDay? _selectedTime; // et l'heure
  bool _isLoading = false;


  Future<void> _tryReserveTable() async {

    if(!_formKey.currentState!.validate() ||
    _selectedDate == null ||
    _selectedTime == null){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez remplir tous les champs.")),
      );
      return;
    }
    setState(() {
      _isLoading = true;
    });

    try {
      // On garde la date (jour J)
      final DateTime reservationDate = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
      );

      // On convertit l'heure choisie en format HH:mm
      final String reservationTime =
          "${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}";

      // User ID retrieving

      final userId = await SecureStorageService.getUserId();
      if(userId == null || userId.isEmpty){
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Utilisateur non connecté")),
        );
        return;
      }

      final result = await bookingService.reserveTable(
        canteenId: widget.canteenId,
        name: _nameController.text.trim(),
        startTime: reservationTime,
        date: reservationDate,
        people: _people,
        userId: userId,
      );

      setState(() => _isLoading = false);

      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Réservation confirmée ✅")),
        );
        widget.onReserved();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erreur lors de la réservation ❌")),
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur: $e")),
      );
    }

  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
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

    return Scaffold(
      appBar: AppBar(
        actions:[
          IconButton(
            icon: const Icon(Icons.close, color: Colors.red),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                      "Réserver une table",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    // Champ nom
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: "Votre nom",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                      value == null || value.isEmpty ? "Nom requis" : null,
                    ),
                    const SizedBox(height: 16),

                    // Nombre de personnes
                    Row(
                      children: [
                        const Text("Personnes: "),
                        const SizedBox(width: 8),
                        DropdownButton<int>(
                          value: _people,
                          items: List.generate(
                            10,
                                (i) => DropdownMenuItem(
                              value: i + 1,
                              child: Text("${i + 1}"),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _people = value!;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Date & Heure
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _pickDate,
                            child: Text(
                              _selectedDate != null
                                  ? "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"
                                  : "Choisir une date",
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _pickTime,
                            child: Text(
                              _selectedTime != null
                                  ? _selectedTime!.format(context)
                                  : "Choisir une heure",
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _tryReserveTable,
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Confirmer"),
                    ),
                  ],
                ),
              ),
            ),
          ),

      ),
    ),
    );
  }
}