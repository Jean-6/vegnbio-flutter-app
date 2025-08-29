import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../domain/model/offer.dart';

class OfferCard extends StatelessWidget {
  final Offer offer;
  final VoidCallback? onTap;

  const OfferCard({Key? key, required this.offer, required this.onTap})
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
                offer.pictures.isNotEmpty
                    ? offer.pictures.first
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
            // Infos texte
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name et Type sur la même ligne
                  Text(
                    '${offer.name} - ${offer.type}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  // Catégorie
                  Text(
                    'Catégorie: ${offer.category}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  // Prix | Quantité | Origine sur la même ligne
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Prix: ${offer.unitPrice.toStringAsFixed(2)} € / ${offer.unit}',
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        'Qté: ${offer.quantity} ${offer.unit}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      Text(
                        'Origine: ${offer.origin}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Date de disponibilité
                  Text(
                    'Disponible le: ${offer.availabilityDate.day}/${offer.availabilityDate.month}/${offer.availabilityDate.year}',
                    style: TextStyle(fontSize: 14, color: Colors.green[700]),
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