import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vegnbio/presentation/widget/offer_card.dart';
import '../../../domain/services/offer_service.dart';
import '../../../dto/offer_filter.dart';
import 'offer_details_screen.dart';
import '../../../core/constants/values.dart';
import '../../../domain/model/offer.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});
  @override
  MarketPlaceScreenState createState() => MarketPlaceScreenState();
}

class MarketPlaceScreenState extends State<MarketplaceScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  List<Offer> filteredOffers = [];

  // Controllers
  final _nameController = TextEditingController();
  final _minPriceController = TextEditingController();
  final _maxPriceController = TextEditingController();

  // Selectionned values
  String? _selectedType;
  String? _selectedCategory;
  String? _selectedOrigin;

  Future<void> _filterOffers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final filters = OfferFilter(
        type: _selectedType,
        name: _nameController.text,
        category: _selectedCategory,
        origin: _selectedOrigin,
        minPrice: _minPriceController.text.isNotEmpty
            ? double.tryParse(_minPriceController.text)
            : null,
        maxPrice: _maxPriceController.text.isNotEmpty
            ? double.tryParse(_maxPriceController.text)
            : null,
      );

      final offers = await OfferService().fetchWithFilters(filters: filters);

      setState(() {
        filteredOffers = offers;
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

  @override
  void initState() {
    super.initState();
    _filterOffers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Rechercher une offre",
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
                              labelText: "Type d'offre",
                              //border: const OutlineInputBorder(),
                            ),
                            value: _selectedType,
                            items: types.map((type) {
                              return DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              );
                            }).toList(),

                            onChanged: (val) {
                              setState(() {
                                _selectedType = val ?? "";
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            controller: _nameController,
                            keyboardType: TextInputType.text,
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
                              labelText: "Nom du produit",
                              hintText: "Entrez le nom du produit",
                              hintStyle: TextStyle(color: Colors.grey.shade500),
                            ),
                            validator: (val) =>
                                val == null || val.trim().isEmpty
                                ? "Nom du produit requis"
                                : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Ligne 2 : category + origin
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
                              labelText: "Catégorie",
                            ),
                            value: _selectedCategory,
                            items: categories.map((cat) {
                              return DropdownMenuItem(
                                value: cat,
                                child: Text(cat),
                              );
                            }).toList(),

                            onChanged: (val) =>
                                setState(() => _selectedCategory = val),
                            validator: (value) => value == null
                                ? "Sélectionnez une catégorie"
                                : null,
                          ),
                        ),
                        const SizedBox(width: 8),
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
                              labelText: 'Origine',
                            ),
                            value: _selectedOrigin,
                            items: countries.map((origin) {
                              return DropdownMenuItem(
                                value: origin,
                                child: Text(origin),
                              );
                            }).toList(),

                            onChanged: (val) {
                              setState(() {
                                _selectedOrigin = val!;
                              });
                            },
                            validator: (value) => value == null
                                ? "Veuillez sélectionner une origine"
                                : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Ligne 3 : minPrice + maxPrice
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _minPriceController,
                            keyboardType: TextInputType.number,
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
                              labelText: "Prix Min.",
                              hintText: "0.00",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return "Prix min. requis";
                              if (double.tryParse(value) == null)
                                return "Entrez un nombre valide";
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            controller: _maxPriceController,
                            keyboardType: TextInputType.number,
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
                              labelText: "Prix Max.",
                              hintText: "0.00",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return "Prix max. requis";
                              if (double.tryParse(value) == null)
                                return "Entrez un nombre valide";
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Bouton rechercher
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _filterOffers,
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

          Expanded(
            flex: 7,
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredOffers.isEmpty
                ? const Center(child: Text("Aucun événement trouvé"))
                : ListView.builder(
                    itemCount: filteredOffers.length,
                    itemBuilder: (context, index) {
                      final item = filteredOffers[index];
                      return OfferCard(
                        offer: item,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => OfferDetailScreen(offer: item),
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
