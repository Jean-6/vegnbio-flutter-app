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
  String? _canteen;

  // Field for searching rooms
  bool hasConferenceRoom = false;
  bool hasMeditation = false;
  bool? hasAnimation = false;

  bool _isLoading = false;

  String? selectedRestaurantId;
  final _nameController = TextEditingController();
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
        name: _canteen,
        hasAnimation: hasAnimation,
        hasConferenceRoom: hasConferenceRoom,
        hasMeditation: hasMeditation,
      );

      logger.d("Filters sent: ${filters.toQueryParams()}");

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
                          onChanged: (value) => _canteen = value,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const SizedBox(width: 10),
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
                                    "Reunion",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  value: hasConferenceRoom,
                                  activeColor: const Color(0xFF4CAF50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      hasConferenceRoom = value ?? false;
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
                                    "Animation",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  value: hasAnimation,
                                  activeColor: const Color(0xFF4CAF50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      hasAnimation = value ?? false;
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
                                    "Méditation",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  value: hasMeditation,
                                  activeColor: const Color(0xFF4CAF50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      hasMeditation = value ?? false;
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

                  //],
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
