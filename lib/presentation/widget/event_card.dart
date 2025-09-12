import 'package:flutter/material.dart';

import '../../dto/event.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback? onTap;

  const EventCard({
    Key? key,
    required this.event,
    required this.onTap,
  }) : super(key: key);

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
                event.pictures.isNotEmpty
                    ? event.pictures.first
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
                          event.title,
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
                    event.desc,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  /*Place*/
                  /*Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                    children: [
                      const Icon(Icons.location_on, size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text('${event.location.address}, ${event.location.city}'+'(${event.location.postalCode})', overflow: TextOverflow.ellipsis)
                      ),
                    ],
                  ),*/
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.label, size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      Expanded(
                          child:  Text(event.type,style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87)),
                      ),

                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
