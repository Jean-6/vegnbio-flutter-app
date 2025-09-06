import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:vegnbio/presentation/screen/customer/canteen_details_screen.dart';

import '../../../domain/services/canteen_service.dart';
import '../../../dto/canteen.dart';
import '../../../dto/canteen_filter.dart';
import '../../widget/canteen_card.dart';

class CanteenScreen extends StatefulWidget {
  const CanteenScreen({super.key});

  @override
  CanteenScreenState createState() => CanteenScreenState();
}

class CanteenScreenState extends State<CanteenScreen> {
  final _formKey = GlobalKey<FormState>();
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  final logger = Logger();
  String? _canteenName;
  String? _dishName;
  DateTime? _startDate;
  DateTime? _endDate;

  // Field for searching rooms
  int? capacity;
  bool hasConferenceRoom = false;
  bool hasWifi = false;
  bool? hasPrinter = false;

  bool _isLoading = false;

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
      _isLoading = true;
    });
    try {
      final filters = CanteenFilter(
        canteenName: _canteenName,
        dishName: _dishName,
        startDate: _startDate,
        endDate: _endDate,
        hasWifi: hasWifi,
        hasPrinter: hasPrinter,
      );

      final canteens = await CanteenService().fetchWithFilters(
        filters: filters,
      );

      setState(() {
        filteredCanteens = canteens!;
      });

      logger.d('>>_load canteens');
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

  /*Future<void> _selectTime(BuildContext context) async {
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
  }*/

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
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF4CAF50),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Formulaire scrollable sans Expanded à l'intérieur
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _nameController,
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
                          onChanged: (value) => _canteenName = value,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: _dishNameController,
                          decoration: InputDecoration(
                            labelText: "Nom du plat",
                            hintText: "Entrez le nom du plat",
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
                          onChanged: (value) => _dishName = value,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Checkbox Wi-Fi / Imprimante
                  /*CheckboxListTile(
                    title: const Text("Inclure la recherche de salles de réunion"),
                    value: searchMeetingRooms,
                    onChanged: (value) {
                      setState(() => searchMeetingRooms = value ?? false);
                    },
                    activeColor: const Color(0xFF4CAF50),
                  ),*/
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE0E0E0)),
                    ),
                    child: CheckboxListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      dense: true,
                      title: const Text(
                        "Inclure la recherche de salles de réunion",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      value: searchMeetingRooms,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      activeColor: const Color(0xFF4CAF50),
                      onChanged: (value) {
                        setState(() {
                          searchMeetingRooms = value ?? false;
                        });
                      },
                    ),
                  ),

                  /*if (searchMeetingRooms) ...[
                    CheckboxListTile(
                      title: const Text("Wi-Fi"),
                      value: hasWifi,
                      onChanged: (value) => setState(() => hasWifi = value ?? false),
                    ),
                    CheckboxListTile(
                      title: const Text("Imprimante"),
                      value: hasPrinter,
                      onChanged: (value) => setState(() => hasPrinter = value ?? false),
                    ),
                  ],*/

                  // Sous-formulaire activé uniquement si searchMeetingRooms = true
                  if (searchMeetingRooms) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        // Capacité
                        SizedBox(
                          width: 120,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Capacité",
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color(0xFFE0E0E0),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color(0xFF4CAF50),
                                  width: 2,
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              capacity = int.tryParse(value);
                            },
                          ),
                        ),
                        const SizedBox(width: 10),

                        // Wi-Fi et Imprimante
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: const Color(0xFFE0E0E0),
                                    ),
                                  ),
                                  child: CheckboxListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    dense: true,
                                    title: const Text(
                                      "Wi-Fi",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    value: hasWifi,
                                    activeColor: const Color(0xFF4CAF50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        hasWifi = value ?? false;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: const Color(0xFFE0E0E0),
                                    ),
                                  ),
                                  child: CheckboxListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    dense: true,
                                    title: const Text(
                                      "Imprimante",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    value: hasPrinter,
                                    activeColor: const Color(0xFF4CAF50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        hasPrinter = value ?? false;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 20),

                  // Bouton Rechercher
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _filterCanteens,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      icon: const Icon(Icons.search),
                      label: const Text(
                        "Rechercher",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Liste des résultats dans Expanded
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredCanteens.isEmpty
                ? const Center(child: Text("Aucun restaurant trouvé"))
                : ListView.builder(
                    itemCount: filteredCanteens.length,
                    itemBuilder: (context, index) {
                      final item = filteredCanteens[index];
                      return CanteenCard(
                        canteen: item,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CanteenDetailScreen(canteen: item),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
