
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:vegnbio/presentation/screen/supplier/marketplace_screen.dart';
import 'package:vegnbio/presentation/screen/supplier/place_offer_screen.dart';

import '../../../core/constants/strings.dart';
import '../../../core/services/secure_storage_service.dart';

import '../../widget/content_card.dart';
import '../customer/bookings_screen.dart';
import '../customer/canteen_screen.dart';
import '../customer/events_screen.dart';
import '../customer/menus_screen.dart';
import '../supplier/my_supplier_screen.dart';

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

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final storedName = await SecureStorageService.getUsername();
    final storedEmail = await SecureStorageService.getUserEmail();
    final storedRoles = await SecureStorageService.getUserRoles();

    setState(() {
      userName = storedName;
      email = storedEmail;
      roles = storedRoles ?? [];
    });
  }


  bool get isSupplier => roles.contains("SUPPLIER");
  bool get isCustomer => roles.contains("CUSTOMER");


  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      _buildHomePage(),
      const Center(child: Text("Member Page")),
      const Center(child: Text("Communauté Page")),
      MySupplierScreen(userName: userName ?? '', email: email ?? ''),
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
          BottomNavigationBarItem(icon: Icon(Icons.message), label: "Messages"),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: "My"),
          /*
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          //BottomNavigationBarItem(icon: Icon(Icons.person), label: "Member"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Communauté"),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: "My"),
           */
        ],
      ),
    );
  }

  Widget _buildHomePage() {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [

              if(isSupplier)...[
                _iconBox(Icons.upload_file, "Deposer une offre",(){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => PlaceOfferScreen()),
                  );
                }),
                _iconBox(Icons.store, "Marché", (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => MarketplaceScreen()),
                  );
                }),
                _iconBox(Icons.history, "Transactions", (){

                }),
                _iconBox(Icons.bar_chart, "Stats", (){
                }),
                
              ],

              if(isCustomer)...[
                _iconBox(Icons.restaurant, "Restaurants", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CanteenScreen()),
                  );
                }),
                _iconBox(Icons.menu_book, "Mes réservations", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const BookingsScreen()),
                  );
                }),
                _iconBox(Icons.category, "Menus", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MenusScreen()),
                  );
                }),
                _iconBox(Icons.card_giftcard, "Événements", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EventsScreen()),
                  );
                }),
              ],
            ],
          ),
          const SizedBox(height: 30),
          const Text("Newest",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ContentCard(
              title: "Notre Dame de Paris",
              desc: "You can try to write a letter to yourself in the future.",
              rating: "4.9",
              imagePath: 'assets/images/logo.png',
              onTap: () {}),
          ContentCard(
              title: "Notre Dame de Paris",
              desc: "You can try to write a letter to yourself in the future.",
              rating: "4.9",
              imagePath: 'assets/images/logo.png',
              onTap: () {}),
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