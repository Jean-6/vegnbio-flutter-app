import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:vegnbio/core/constants/values.dart';
import 'package:vegnbio/domain/services/canteen_service.dart';
import 'package:vegnbio/domain/services/event_service.dart';
import 'package:vegnbio/dto/canteen.dart';
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

  String? _selectedCanteen;
  String? _selectedType;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isLoading = false;

  List<Event> filteredEvents = [];
  List<Canteen> canteens = [];
  List<CanteenOption> canteenOptions = [];
  late Future<List<Event>> futureEvents;

  Future<void> _loadCanteenOption() async {
    logger.d('>>_load canteens');
    setState(() {
      _isLoading = true;
    });
    try {
      final result = await CanteenService().fetchCanteenOption();
      if (result != null) {
        setState(() {
          canteenOptions = result;
        });
      }
    } catch (e, stack) {
      logger.e('>> Exception in _loadCanteens : ${e} ${stack}');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error : ${e.toString()}')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _filterEvents() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final filters = EventFilter(
        canteenId: _selectedCanteen,
        type: _selectedType,
        startDate: _startDate,
        endDate: _endDate,
      );

      final events = await EventService().fetchWithFilters(
        eventFilter: filters,
      );

      setState(() {
        filteredEvents = events!;
      });
      logger.d('Load all Events : $filteredEvents');
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

  /*String _formatDate(DateTime? date) {
    if (date == null) return "Choir une date de debut";
    return "$date{date.year}-${date.month.toString().padLeft(2, '0')} - ${date.day.toString().padLeft(2, '0')}";
  }*/

  /*Future<void> _selectDate(BuildContext context, bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      locale: const Locale('fr', ''), // important pour avoir les libellés FR
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
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
  }*/

  /*void _showCustomDatePicker(bool isStart) async {
    final pickedDate = await DatePickerService.showCustomDatePicker(
      context,
      initialDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        if (isStart) {
          _startDate = pickedDate;
        } else {
          _endDate = pickedDate;
        }
      });
    }
  }*/

  @override
  void initState() {
    super.initState();
    _filterEvents();
    _loadCanteenOption();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Liste des evenements",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF4CAF50),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
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
                                borderSide: BorderSide(
                                  color: Color(0xFFE0E0E0),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Color(0xFFE0E0E0),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Color(0xFF4CAF50),
                                  width: 2,
                                ),
                              ),
                              hintStyle: TextStyle(color: Colors.grey.shade500),
                              labelText: "Selectionner le restaurant",
                            ),
                            value: _selectedCanteen,
                            items: canteenOptions.map((canteen) {
                              return DropdownMenuItem<String>(
                                value: canteen.id,
                                child: Text(canteen.name),
                              );
                            }).toList(),

                            onChanged: (String? value) {
                              setState(() {
                                _selectedCanteen = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

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
                                borderSide: BorderSide(
                                  color: Color(0xFFE0E0E0),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Color(0xFFE0E0E0),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Color(0xFF4CAF50),
                                  width: 2,
                                ),
                              ),
                              hintStyle: TextStyle(color: Colors.grey.shade500),
                              labelText: "Selectionner le type d'evenement",
                            ),
                            value: _selectedType,
                            items: eventType.map((type) {
                              return DropdownMenuItem<String>(
                                value: type,
                                child: Text(type),
                              );
                            }).toList(),

                            onChanged: (String? value) {
                              setState(() {
                                _selectedType = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),
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
                                    ? "Date de debut"
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
                        SizedBox(width: 20),
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

          // Result
          Expanded(
            flex: 7,
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : filteredEvents.isEmpty
                ? Text("Aucun événément trouvé")
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
    );
  }
}
