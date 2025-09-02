import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:vegnbio/domain/services/menu_service.dart';

import '../../../core/constants/values.dart';
import '../../../domain/services/canteen_service.dart';
import '../../../dto/canteen.dart';
import '../../../dto/canteen_option.dart';
import '../../../dto/event.dart';
import '../../../dto/menu.dart';
import '../../../dto/menu_filter.dart';
import '../../widget/menu_card.dart';

class MenusScreen extends StatefulWidget {
  const MenusScreen({super.key});

  @override
  MenusScreenState createState() => MenusScreenState();
}

class MenusScreenState extends State<MenusScreen> {
  final _formKey = GlobalKey<FormState>();
  final logger = Logger();

  late Future<List<Event>> futureEvents;

  final TextEditingController _dishNameCtrl = TextEditingController();
  String? _selectedCanteen;
  String? _selectedDishType;
  String? _selectedDiet;
  DateTime? startDate;
  DateTime? endDate;
  bool _isLoading = false;

  List<Menu> filteredMenus = [];
  List<Canteen> canteens = [];
  List<CanteenOption> canteenOptions = [];
  List<Menu> menus = [];


  Future<void> _filterMenus() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final filters = MenuFilter(
          canteenId: _selectedCanteen,
          dishName: _dishNameCtrl.text,
          dishType: _selectedDishType,
          diet: _selectedDiet
      );
      final menus = await MenuService().fetchWithFilters(
        menuFilters: filters,
      );

      setState(() {
        filteredMenus = menus!;
      });
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

    Future<void> _loadMenus() async {
      logger.d(' >> load menus');

      setState(() {
        _isLoading = true;
      });
      try {
        final result = await MenuService().fetchMenus();
        if (result != null) {
          setState(() {
            filteredMenus = result;
          });
        }
      } catch (e, stack) {
        logger.e('>> Exception in _loadMenus : ${e} ${stack}');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error : ${e.toString()}')));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }

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


    @override
    void initState() {
      super.initState();
      _loadCanteenOption();
      _loadMenus();
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Rechercher un menu",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xFF4CAF50),
          centerTitle: true,
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

                      /// Dropdown restaurant
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
                                hintStyle: TextStyle(
                                    color: Colors.grey.shade500),
                                labelText: "Selectionner le restaurant",
                              ),
                              value: _selectedCanteen,
                              items: canteenOptions
                                  .map(
                                    (c) =>
                                    DropdownMenuItem<String>(
                                      value: c.id,
                                      child: Text(c.name),
                                    ),
                              )
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedCanteen = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      /// Text field nom du plat
                      TextFormField(
                        controller: _dishNameCtrl,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Color(0xFF4CAF50),
                              width: 2,
                            ),
                          ),
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          labelText: "Entrer le nom du plat",
                        ),
                      ),

                      const SizedBox(height: 12),

                      /// Dropdown type de plat
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
                                hintStyle: TextStyle(
                                    color: Colors.grey.shade500),
                                labelText: "Type de plat",
                              ),
                              value: _selectedDishType,
                              items: dishType
                                  .map(
                                    (type) =>
                                    DropdownMenuItem<String>(
                                      value: type,
                                      child: Text(type),
                                    ),
                              )
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedDishType = value;
                                });
                              },
                            ),
                          ),

                          const SizedBox(width: 12),
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
                                hintStyle: TextStyle(
                                    color: Colors.grey.shade500),
                                labelText: "Regime alimentaire",
                              ),
                              items: ["Végétarien", "Vegan", "Sans gluten"]
                                  .map(
                                    (diet) =>
                                    DropdownMenuItem(
                                      value: diet,
                                      child: Text(diet),
                                    ),
                              )
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedDiet = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _filterMenus,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4CAF50),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
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
                  : filteredMenus.isEmpty
                  ? Text("Aucun menu trouvé")
                  : ListView.builder(
                itemCount: filteredMenus.length,
                itemBuilder: (context, index) {
                  final item = filteredMenus[index];
                  return MenuCard(menu: item, onTap: () {});
                },
              ),
            ),
          ],
        ),
      );
    }
    }


