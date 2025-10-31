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
                      ...canteen.equipments.map((e) {
                        final equip = e.toLowerCase();
                        switch (equip) {
                          case "Animation":
                            return Row(
                              children: [
                                Icon(Icons.theater_comedy, size: 18, color: Colors.purple),
                                SizedBox(width: 4),
                                Text("Animation"),
                                SizedBox(width: 12),
                              ],
                            );
                          case "espace de méditation":
                            return Row(
                              children: [
                                Icon(Icons.self_improvement, size: 18, color: Colors.green),
                                SizedBox(width: 4),
                                Text("Méditation"),
                                SizedBox(width: 12),
                              ],
                            );
                          case "MeetingRoom":
                            return Row(
                              children: [
                                Icon(Icons.meeting_room, size: 18, color: Colors.blue),
                                SizedBox(width: 4),
                                Text("Salle de réunion"),
                                SizedBox(width: 12),
                              ],
                            );
                          default:
                            return SizedBox.shrink();
                        }
                      }).toList(),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 18, color: Colors.red),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          "${canteen.location.address}, ${canteen.location.city}",
                          style: const TextStyle(fontSize: 14, color: Colors.black87),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
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
