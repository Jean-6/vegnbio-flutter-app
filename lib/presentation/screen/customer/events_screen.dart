import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:vegnbio/core/services/date_picker_service.dart';
import 'package:vegnbio/domain/services/canteen_service.dart';
import 'package:vegnbio/domain/services/event_service.dart';
import 'package:vegnbio/presentation/widget/event_card.dart';
import 'package:intl/intl.dart';
import '../../../dto/event.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy'); //

  String? selectedRestaurantId;
  DateTime? startDate;
  DateTime? endDate;
  bool isLoading = false;

  List<Event> filteredEvents = [];
  late Future<List<Event>> futureEvents;
  final logger = Logger();


  Future<void> _loadCanteens() async {

    setState((){
      isLoading = true;
    });

    try{
      final canteens = await CanteenService().fetchCanteens();
      setState(() {
        isLoading = false;
      });
      logger.d('>> Canteen list : ${canteens}');
    }catch(e){
      ScaffoldMessenger.of(
          context
      ).showSnackBar(SnackBar(content: Text('Error : ${e.toString()}')));
    }finally{
      setState(() {
        isLoading = false;
      });
    }
  }


  Future<void> _filterEvents() async {
    setState(() {
      isLoading = true;
    });
    try {
      final events = await EventService().fetchEvents(
        restaurantId: selectedRestaurantId,
        startDate: startDate,
        endDate: endDate,
      );

      setState(() {
        filteredEvents = events!;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context
      ).showSnackBar(SnackBar(content: Text('Error : ${e.toString()}')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "Choir une date de debut";
    return "$date{date.year}-${date.month.toString().padLeft(2, '0')} - ${date.day.toString().padLeft(2, '0')}";
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
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
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  void _showCustomDatePicker(bool isStart) async {
    final pickedDate = await DatePickerService.showCustomDatePicker(
      context,
      initialDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        if (isStart) {
          startDate = pickedDate;
        } else {
          endDate = pickedDate;
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _filterEvents();
    _loadCanteens();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Liste des evenements",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 10,
                ),
                labelText: "Choisissez un restaurant",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                filled: true,
              ),
              value: selectedRestaurantId,
              items: [],
              onChanged: (String? value) {
                setState(() {
                  selectedRestaurantId = value;
                });
              },
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _showCustomDatePicker(
                      true,
                    ), //_selectDate(context, true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[100],
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Text(
                        startDate != null
                            ? "📅 ${dateFormat.format(startDate!)}"
                            : "Date de début",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _showCustomDatePicker(false),
                    //_showCustomDatePicker(false),
                    //_selectDate(context, false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[100],
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Text(
                        endDate != null
                            ? "📅 ${dateFormat.format(endDate!)}"
                            : "Date de fin",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _filterEvents,
                icon: const Icon(Icons.search),
                label: const Text("Rechercher"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            // Result
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : filteredEvents.isEmpty
                  ? Text("Aucun événément trouvé")
                  : ListView.builder(
                      itemCount: filteredEvents.length,
                      itemBuilder: (context, index) {
                        final item = filteredEvents[index];
                        return EventCard(event: item, onTap: () {});
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
