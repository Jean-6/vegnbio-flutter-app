

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:vegnbio/core/constants/values.dart';
import 'package:vegnbio/domain/services/event_service.dart';
import 'package:vegnbio/dto/canteen_option.dart';
import 'package:vegnbio/dto/event_filter.dart';
import 'package:vegnbio/presentation/widget/event_card.dart';
import 'package:intl/intl.dart';
import '../../../dto/event.dart';
import 'event_details_screen.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  EventsScreenState createState() => EventsScreenState();
}

class EventsScreenState extends State<EventsScreen> {
  final _formKey = GlobalKey<FormState>();
  final logger = Logger();
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  String? _canteen;
  String? _selectedCanteen;
  String? _canteenName;
  String? _selectedType;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isLoading = false;

  final _canteenController = TextEditingController();
  List<Event> filteredEvents = [];
  List<CanteenOption> canteenOptions = [];

  @override
  void initState() {
    super.initState();
    _filterEvents();
    _loadCanteenOption();
  }

  Future<void> _loadCanteenOption() async {
    setState(() => _isLoading = true);
    try {
      // Charge les options de cantines
      // final result = await CanteenService().fetchCanteenOption();
      // if (result != null) canteenOptions = result;
    } catch (e, stack) {
      logger.e('Exception in _loadCanteens: $e $stack');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erreur : ${e.toString()}')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _filterEvents() async {
    setState(() => _isLoading = true);
    try {
      final filters = EventFilter(
        canteenId: _selectedCanteen,
        canteenName: _canteen,
        type: _selectedType,
        startDate: _startDate,
        endDate: _endDate,
      );

      final events = await EventService().fetchWithFilters(eventFilter: filters);

      setState(() => filteredEvents = events ?? []);
      logger.d('Load Events: $filteredEvents');
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erreur : ${e.toString()}')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Liste des événements",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF4CAF50),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Formulaire de filtrage
              Expanded(
                flex: 3,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [

                        TextFormField(
                          controller: _canteenController,
                          decoration: InputDecoration(
                            labelText: "Nom du restaurant",
                            hintText: "Entrez le nom du restaurant",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color(0xFF4CAF50),
                                width: 2,
                              ),
                            ),
                          ),
                          onChanged: (value) => _canteen = value,
                        ),
                        // Filtrer par restaurant
                       
                        const SizedBox(height: 8),
                        // Filtrer par type
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Color(0xFF4CAF50), width: 2),
                            ),
                            labelText: "Sélectionner le type d'événement",
                            hintStyle: TextStyle(color: Colors.grey.shade500),
                          ),
                          value: _selectedType,
                          items: eventType.map((type) {
                            return DropdownMenuItem<String>(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                          onChanged: (value) => setState(() => _selectedType = value),
                        ),
                        const SizedBox(height: 8),
                        // Dates
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _pickDate(true),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 14),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: const Color(0xFFE0E0E0)),
                                  ),
                                  child: Text(
                                    _startDate == null
                                        ? "Date de début"
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
                            const SizedBox(width: 20),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _pickDate(false),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 14),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: const Color(0xFFE0E0E0)),
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
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _filterEvents,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4CAF50),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
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
              ),
              // Liste des événements
              Expanded(
                flex: 7,
                child: filteredEvents.isEmpty
                    ? const Center(child: Text("Aucun événement trouvé"))
                    : ListView.builder(
                  itemCount: filteredEvents.length,
                  itemBuilder: (context, index) {
                    final item = filteredEvents[index];
                    return EventCard(
                      event: item,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EventDetailScreen(event: item),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          // Loader overlay
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF4CAF50),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
