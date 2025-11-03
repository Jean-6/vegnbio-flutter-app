import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';

import '../../../domain/model/product.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _OfferDetailScreenState();
}

class _OfferDetailScreenState extends State<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  // Keys pour les ancres
  final _presentationKey = GlobalKey();
  final _priceKey = GlobalKey();
  final _expirationKey = GlobalKey();
  final _supplierKey = GlobalKey();
  //final _avisKey = GlobalKey();

  late TabController _tabController;

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  Widget _sectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF4CAF50)),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          product.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF4CAF50),
        centerTitle: true,
        elevation: 4,
      ),
      body: Column(
        children: [
          if (product.pictures.isNotEmpty)
            SizedBox(
              height: 220,
              child: CarouselSlider.builder(
                itemCount: product.pictures.length,
                unlimitedMode: true,
                enableAutoSlider: true,
                autoSliderDelay: const Duration(seconds: 3),
                slideBuilder: (int index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.zero,
                    child: Image.network(
                      product.pictures[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.broken_image, size: 40),
                        );
                      },
                    ),
                  );
                },
              ),
            ),


          Material(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.blue,
              onTap: (index) {
                switch (index) {
                  case 0:
                    _scrollTo(_presentationKey);
                    break;
                  case 1:
                    _scrollTo(_priceKey);
                    break;
                  case 2:
                    _scrollTo(_expirationKey);
                    break;
                  case 3:
                    _scrollTo(_supplierKey);
                    break;
                  //case 4:
                  //  _scrollTo(_avisKey);
                  //  break;
                }
              },
              tabs: const [
                Tab(text: "Infos"),
                Tab(text: "Prix"),
                Tab(text: "Expiration"),
                Tab(text: "Fournisseur"),
                //Tab(text: "Avis"),
              ],
            ),
          ),

          // Contenu scrollable
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Infos
                  Container(key: _presentationKey),
                  _sectionTitle("Présentation", Icons.info),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "${product.desc}\n\n"
                          "Type : ${product.type}\n"
                          "Catégorie : ${product.category}\n"
                          "Origine : ${product.origin}",
                      style: const TextStyle(fontSize: 16, height: 1.4),
                    ),
                  ),

                  // Prix
                  Container(key: _priceKey),
                  _sectionTitle("Prix", Icons.euro),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Quantité : ${product.quantity} ${product.unit}\n"
                          "Prix unitaire : ${product.unitPrice.toStringAsFixed(2)} €",
                      style: const TextStyle(fontSize: 16, height: 1.4),
                    ),
                  ),

                  // Disponibilité
                  /*Container(key: _expirationKey),
                  _sectionTitle("Disponibilité", Icons.calendar_today),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Disponible à partir du : ${dateFormat.format(offer.availabilityDate)}\n"
                          "Expiration : ${dateFormat.format(offer.expirationDate)}",
                      style: const TextStyle(fontSize: 16, height: 1.4),
                    ),
                  ),*/

                  // Fournisseur
                  Container(key: _supplierKey),
                  _sectionTitle("Fournisseur", Icons.store),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Identifiant fournisseur : ${product.supplierId}",
                      style: const TextStyle(fontSize: 16, height: 1.4),
                    ),
                  ),

                  // Avis
                  /*Container(key: _avisKey),
                  _sectionTitle("Avis", Icons.rate_review),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text("Aucun avis pour le moment."),
                  ),*/
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
