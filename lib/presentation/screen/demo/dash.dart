
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:vegnbio/presentation/screen/supplier/marketplace_screen.dart';
import 'package:vegnbio/presentation/screen/supplier/my_product_screen.dart';

import '../../../core/constants/strings.dart';
import '../../../core/services/secure_storage_service.dart';

import '../../../domain/services/event_service.dart';
import '../../../dto/event.dart';
import '../../widget/event_card.dart';
import '../customer/bookings_screen.dart';
import '../customer/canteen_screen.dart';
import '../customer/event_details_screen.dart';
import '../customer/events_screen.dart';
import '../customer/menus_screen.dart';
import '../customer/my_screen.dart';
import '../supplier/place_product_screen.dart';

class Dash extends StatefulWidget {
  const Dash({super.key});

  @override
  State<StatefulWidget> createState() => _DashState();
}


class _DashState extends State<Dash> {
  int _currentIndex = 0;
  String? userName;
  String? email;
  List<String> roles = [];
  List<Event> latestEvents =[];

  final logger = Logger();

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchLatestEvents();
  }

  bool _isLoading = true;

  Future<void> _fetchLatestEvents() async {
    // Exemple: récupère via ton service
    final events = await EventService().fetchLastEvents();
    setState(() {
      latestEvents = events ?? [];
    });
  }

  Future<void> _loadUserData() async {
    final storedName = await SecureStorageService.getUsername();
    final storedEmail = await SecureStorageService.getUserEmail();
    final storedRoles = await SecureStorageService.getUserRoles();

    setState(() {
      userName = storedName;
      email = storedEmail;
      roles = storedRoles ?? [];
      _isLoading = false;
    });
    logger.d("Username récupérés depuis le stockage : $userName");
    logger.d("Roles récupérés depuis le stockage : $roles");
  }


  bool get isSupplier => roles.contains("SUPPLIER");
  bool get isCustomer => roles.contains("CUSTOMER");
  

  List<Widget> _buildGridIcons() {
    List<Widget> icons = [];
    
    if (roles.contains("SUPPLIER") || roles.contains("CUSTOMER")) {
      icons.add(_iconBox(Icons.store, "Market", () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => MarketplaceScreen()),
        );
      }));
    }

    // Icônes réservées aux fournisseurs
    if (roles.contains("SUPPLIER")) {
      icons.add(_iconBox(Icons.inventory_2_outlined, "Mes articles", () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => MyProductScreen()),
        );
      }));
      icons.add(_iconBox(Icons.upload_file, "Vendre", () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PlaceProductScreen()),
        );
      }));
    }

    // Icônes réservées aux clients (CUSTOMER)
    if (roles.contains("CUSTOMER")) {
      icons.add(_iconBox(Icons.storefront_outlined, "Restos", () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CanteenScreen()),
        );
      }));
      icons.add(_iconBox(Icons.calendar_today, "Résa", () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BookingsScreen()),
        );
      }));
      icons.add(_iconBox(Icons.restaurant_menu, "Menus", () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MenusScreen()),
        );
      }));
      icons.add(_iconBox(Icons.event, "Événements", () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const EventsScreen()),
        );
      }));
    }

    return icons;
  }
  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      _buildHomePage(),
      const Center(child: Text("Member Page")),
      //const Center(child: Text("Communauté Page")),
      MyScreen(userName: userName ?? '', email: email ?? ''),
    ];
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Member"),
          //BottomNavigationBarItem(icon: Icon(Icons.message), label: "Messages"),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: "My"),
        ],
      ),
    );
  }

  Widget _buildHomePage() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            Strings.dashboardTitle,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Container(
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [Colors.blue.shade800, Colors.blue.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Strings.appName,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                const Spacer(),
                const Row(
                  children: [
                    Icon(Icons.layers, color: Colors.white),
                    SizedBox(width: 8),
                    Text("PRODUCTS", style: TextStyle(color: Colors.white)),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 20),

          GridView.count(
            crossAxisCount: 3, // nombre de colonnes (3x3) ; mets 4 pour 4x4
            shrinkWrap: true,   // pour qu'il prenne seulement la hauteur nécessaire
            physics: const NeverScrollableScrollPhysics(), // évite le scroll interne
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            childAspectRatio: 1.0,
            children:  _buildGridIcons()
          ),

          //const SizedBox(height: 5),
          const Text(
            "Nouveautés",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),

        // Section événements
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (latestEvents.isEmpty)
            const Center(child: Text("Aucun événement récent trouvé"))
          else
            ListView.builder(
              shrinkWrap: true, 
              physics: const NeverScrollableScrollPhysics(), 
              itemCount: latestEvents.length,
              itemBuilder: (context, index) {
                final event = latestEvents[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: EventCard(
                    event: event,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EventDetailScreen(event: event),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _iconBox(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
        onTap:onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:Colors.blue.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon,size: 30,color: Colors.blue),
            ),
            SizedBox(height:8),
            Text(label)
          ],
        )
    );
  }
}