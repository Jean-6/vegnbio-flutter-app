import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import '../../../dto/menu.dart';

class MenuDetailScreen extends StatefulWidget {
  final Menu menu;

  const MenuDetailScreen({super.key, required this.menu});

  @override
  State<MenuDetailScreen> createState() => _MenuDetailScreenState();
}

class _MenuDetailScreenState extends State<MenuDetailScreen>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  // Keys pour les ancres
  final _presentationKey = GlobalKey();
  final _dishListKey = GlobalKey();
  final _dietKey = GlobalKey();
  final _allergensKey = GlobalKey();
  final _avisKey = GlobalKey();

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
    _tabController = TabController(length: 5, vsync: this);
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
    final menu = widget.menu;
    final allPictures = menu.dishes.expand((dish) => dish.pictures).toList();

    // Récupérer tous les régimes distincts
    final allDiets = menu.dishes.expand((d) => d.diet).toSet().toList();

    // Récupérer tous les allergènes distincts
    final allAllergens = menu.dishes.expand((d) => d.allergens).toSet().toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          menu.name,
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
          if (allPictures.isNotEmpty)
            SizedBox(
              height: 220,
              child: CarouselSlider.builder(
                itemCount: allPictures.length,
                unlimitedMode: true,
                enableAutoSlider: true,
                autoSliderDelay: const Duration(seconds: 3),
                slideBuilder: (int index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.zero,
                    child: Image.network(
                      allPictures[index],
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
                    _scrollTo(_dishListKey);
                    break;
                  case 2:
                    _scrollTo(_dietKey);
                    break;
                  case 3:
                    _scrollTo(_allergensKey);
                    break;
                  case 4:
                    _scrollTo(_avisKey);
                    break;
                }
              },
              tabs: const [
                Tab(text: "Infos"),
                Tab(text: "Plats"),
                Tab(text: "Regime "),
                Tab(text: "Allergènes"),
                Tab(text: "Avis"),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Container(key: _presentationKey),
                  _sectionTitle("Présentation", Icons.info),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      menu.desc,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.4,
                        color: Color(0xFF555555),
                      ),
                    ),
                  ),

                  /*Dish list*/
                  Container(key: _dishListKey),
                  _sectionTitle("Plats du menu", Icons.restaurant_menu),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: menu.dishes.length,
                    itemBuilder: (context, index) {
                      final dish = menu.dishes[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image du plat
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                bottomLeft: Radius.circular(16),
                              ),
                              child: dish.pictures.isNotEmpty
                                  ? Image.network(
                                dish.pictures.first,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              )
                                  : Container(
                                width: 100,
                                height: 100,
                                color: Colors.grey[300],
                                child: const Icon(Icons.fastfood, size: 40, color: Colors.grey),
                              ),
                            ),

                            // Infos du plat
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      dish.name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF333333),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      dish.desc,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF666666),
                                        height: 1.3,
                                      ),
                                    ),
                                    const SizedBox(height: 8),

                                    // Si tu veux afficher le prix :
                                    // Text("${dish.price.toStringAsFixed(2)} €",
                                    //   style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  /*Container(key: _dishListKey),
                  _sectionTitle("Plats du menu", Icons.restaurant_menu),
                  ...menu.dishes.map((dish) => Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading: dish.pictures.isNotEmpty
                          ? Image.network(dish.pictures.first,
                          width: 50, height: 50, fit: BoxFit.cover)
                          : const Icon(Icons.fastfood, color: Colors.grey),
                      title: Text(dish.name),
                      subtitle: Text(dish.desc),
                      //trailing: Text("${dish.price.toStringAsFixed(2)} €"),
                    ),
                  )),*/


                  Container(key: _dietKey),
                  _sectionTitle("Regime alimentaire", Icons.eco),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: allDiets.isNotEmpty
                        ? Wrap(
                      spacing: 8,
                      children: allDiets.map((diet) => Chip(
                        label: Text(diet.label),
                        backgroundColor: Colors.green[100],
                      )).toList(),
                    )
                        : const Text("Aucun régime particulier"),
                  ),

                  Container(key: _allergensKey),
                  _sectionTitle("Liste des allergènes", Icons.warning_amber),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: allAllergens.isNotEmpty
                        ? Wrap(
                      spacing: 8,
                      children: allAllergens.map((allergen) => Chip(
                        label: Text(allergen),
                        backgroundColor: Colors.red[100],
                      )).toList(),
                    )
                        : const Text("Aucun allergène"),
                  ),

                  Container(key: _avisKey),
                  _sectionTitle("Avis", Icons.rate_review),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
