
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vegnbio/presentation/screen/supplier/place_offer_screen.dart';

import '../../../core/constants/strings.dart';
import '../../widget/content_card.dart';

class SupplierDash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stylish Dashboard',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        primarySwatch: Colors.blue,
      ),
      home: SupplierDashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SupplierDashScreen extends StatelessWidget {
  const SupplierDashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Member"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: "Messages"),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: "My"),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            Text(
              Strings.dashboardTitle,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
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
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(Strings.appName,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  Spacer(),
                  Row(
                    children: [
                      Icon(Icons.layers, color: Colors.white),
                      SizedBox(width: 8),
                      Text("PRODUCTS", style: TextStyle(color: Colors.white)),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _iconBox(Icons.upload_file, "Deposer une offre",(){
                  Navigator.push(
                      context,
                    MaterialPageRoute(builder: (_) => PlaceOfferScreen()),
                  );
                }),
                _iconBox(Icons.store, "Marché", (){

                }),
                _iconBox(Icons.history, "Transactions", (){

                }),
                _iconBox(Icons.bar_chart, "Stats", (){

                }),
              ],
            ),
            SizedBox(height: 30),
            Text("Newest", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            ContentCard(
                title: "Notre Dame de Paris",
                desc: "You can try to write a letter to yourself in the future.",
                rating: "4.9",
                imagePath: 'assets/images/logo.png',
                onTap: (){})
          ],
        ),
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