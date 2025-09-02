import 'package:flutter/material.dart';
import 'package:vegnbio/dto/menu.dart';

class MenuCard extends StatelessWidget {
  final Menu menu;
  final VoidCallback? onTap;

  const MenuCard({
    Key? key,
    required this.menu,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {},
        child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  menu.dishes.isNotEmpty && menu.dishes.first.pictures.isNotEmpty
                      ? menu.dishes.first.pictures.first
                      : 'https://via.placeholder.com/100',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image, size: 40),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),

              //Infos
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            menu.name,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      menu.desc,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),

                    // Structure du menu
                    const Text(
                      "Entrée + Plat + Dessert",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black45,
                      ),
                    ),

                    /*Row(
                      children: menu.dishes
                          .expand((dish) => dish.dietType)
                          .toSet()
                          .map((dietType) {
                        switch (dietType) {
                          case "VEGAN":
                            return Icon(Icons.eco, color: Colors.green, size: 18);
                          case "VEGETARIAN":
                            return Icon(Icons.grass, color: Colors.green, size: 18);
                          case "GLUTEN_FREE":
                            return Icon(Icons.no_food, color: Colors.orange, size: 18);
                          default:
                            return const SizedBox();
                        }
                      })
                          .toList(),
                    )*/
                  ],
                ),
              ),
            ],
          ),
    )
    );
  }
}