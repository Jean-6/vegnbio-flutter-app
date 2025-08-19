import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:vegnbio/presentation/screen/customer/canteen_details_screen.dart';

import '../../../domain/services/canteen_service.dart';
import '../../../dto/canteen.dart';
import '../../widget/canteen_card.dart';

class CanteenScreen extends StatefulWidget {
  const CanteenScreen({super.key});

  @override
  CanteenScreenState createState() => CanteenScreenState();
}

class CanteenScreenState extends State<CanteenScreen> {
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  final logger = Logger();
  String? restaurantName;
  String? dishName;
  DateTime? startDate;
  DateTime? endDate;
  // Field for searching rooms
  int? capacity;
  bool hasConferenceRoom = false;
  bool hasWifi = false;
  bool? hasPrinter = false;

  bool isLoading = false;

  String? selectedRestaurantId;
  final _nameController = TextEditingController();
  final _dishNameController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalCodeController = TextEditingController();
  List<String> selectedTags = [];
  List<String> selectedEquipments = [];
  double minSeats = 0;
  double maxSeats = 200;

  bool searchMeetingRooms = false;
  
  TimeOfDay? selectedTime;

  List<Canteen> filteredCanteens = [];

  Future<void> _filterCanteens() async {
    setState(() {
      isLoading = true;
    });
    try {
      final canteens = await CanteenService().fetchCanteens(
        restaurantName: restaurantName,
        dishName: dishName,
        startDate: startDate,
        endDate: endDate,
        hasWifi : hasWifi,
        hasPrinter : hasPrinter
      );

      setState(() {
        filteredCanteens = canteens!;
      });

      logger.d('>>_load canteens');

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


  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: "Choisir l'heure",
    );

    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: "Sélectionne une heure",
    );

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _filterCanteens();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Rechercher un restaurant",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Nom du restaurant",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                filled: true,
              ),
              onChanged: (value) {
                // TODO: stocker le nom du plat
              },
              controller: _nameController,
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Nom du plat",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                filled: true,
              ),
              onChanged: (value) {
                // TODO: stocker le nom du plat
              },
              controller: _dishNameController,
            ),
            const SizedBox(height: 20),

            // Les deux boutons sur la même ligne
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _selectTime(context),
                    child: Text("Heure d'ouverture"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _selectTime(context),
                    child: Text("Heure de fermeture"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            //-- Meeting room


            CheckboxListTile(
              title: Text("Inclure la recherche de salles de réunion"),
              value: searchMeetingRooms,
              onChanged: (value) {
                setState(() {
                  searchMeetingRooms = value ?? false;
                });
              },
            ),

            // --- SOUS-FORMULAIRE S’IL EST ACTIVÉ ---
            if (searchMeetingRooms) ...[
              const SizedBox(height: 10),
            // Capacité d'accueil + Wi-Fi & Imprimante
              Row(
                children: [
                  // Champ capacité plus petit
                  SizedBox(
                    width: 150,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Capacité",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        filled: true,
                      ),
                      onChanged: (value) {
                        capacity = int.tryParse(value);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Cases Wi-Fi et Imprimante sur la même ligne
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            title: Text("Wi-Fi", style: TextStyle(fontSize: 14)),
                            value: hasWifi,
                            onChanged: (value) {
                              setState(() {
                                hasWifi = value ?? false;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            title: Text("Imprimante", style: TextStyle(fontSize: 14)),
                            value: hasPrinter,
                            onChanged: (value) {
                              setState(() {
                                hasPrinter = value ?? false;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],


            // Result
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : filteredCanteens.isEmpty
                  ? Text("Aucun événément trouvé")
                  : ListView.builder(
                itemCount: filteredCanteens.length,
                itemBuilder: (context, index) {
                  final item = filteredCanteens[index];
                  return CanteenCard(canteen: item, onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => CanteenDetailScreen(canteen: item),
                        ),
                    );
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
