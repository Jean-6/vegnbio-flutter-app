import 'package:flutter/material.dart';

import '../../dto/canteen.dart';

class CanteenCard extends StatelessWidget {
  final Canteen canteen;
  final VoidCallback? onTap;

  const CanteenCard({Key? key, required this.canteen, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
                canteen.pictures.isNotEmpty
                    ? canteen.pictures.first
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
                          canteen.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  Text(
                    canteen.desc,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.chair, size: 18, color: Colors.green),
                      SizedBox(width: 4),
                      Text("${canteen.seats} places"),
                      SizedBox(width: 12),
                      Icon(Icons.wifi, size: 18, color: Colors.blue),
                      SizedBox(width: 4),
                      Text("Wi-Fi"),
                      SizedBox(width: 12),
                      Icon(Icons.deck, size: 18, color: Colors.orange),
                      //SizedBox(width: 4),
                      //Text("Terrasse"),
                    ],
                  ),

                  SizedBox(height: 8),
                  Text(
                    "Aujourd'hui : 10:00 - 23:00",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),

                  SizedBox(height: 8),
                  Text("📍 3 Promenade des Anglais, Nice"),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          // Action pour la réservation
                          print("Réserver cliqué !");
                        },
                        icon: Icon(Icons.calendar_today),
                        label: Text("Réserver"),
                      ),
                      TextButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.phone),
                        label: Text("Appeler"),
                      ),
                      TextButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.map),
                        label: Text("Carte"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
