import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../domain/model/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final bool showApproval;

  const ProductCard({Key? key,
    required this.product,
    required this.onTap,
    this.showApproval = true,
  })
    : super(key: key);


  IconData _getStatusIcon(Status? status) {
    switch (status) {
      case Status.APPROVED:
        return Icons.check_circle;
      case Status.PENDING:
        return Icons.hourglass_top;
      case Status.REJECTED:
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }
  Color _getStatusColor(Status? status) {
    switch (status) {
      case Status.APPROVED:
        return Colors.green;
      case Status.PENDING:
        return Colors.orange;
      case Status.REJECTED:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

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
                product.pictures.isNotEmpty
                    ? product.pictures.first
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
                    '${product.name} - ${product.type}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  // Catégorie
                  Text(
                    'Catégorie: ${product.category}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  // Prix | Quantité | Origine sur la même ligne
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Prix: ${product.unitPrice.toStringAsFixed(2)} € / ${product.unit}',
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        'Qté: ${product.quantity} ${product.unit}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      Text(
                        'Origine: ${product.origin}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  if (showApproval && product.approval != null) // affichage conditionnel
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              _getStatusIcon(product.approval!.status),
                              color: _getStatusColor(product.approval!.status),
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              product.approval!.status.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _getStatusColor(product.approval!.status),
                              ),
                            ),
                          ],
                        ),
                        // Affiche les raisons si rejeté
                        if (product.approval!.status == Status.REJECTED && product.approval!.reasons != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              'Raisons: ${product.approval!.reasons}',
                              style: const TextStyle(color: Colors.red, fontStyle: FontStyle.italic),
                            ),
                          ),
                      ],
                    ),

                  /*if (showApproval && product.approval != null)
                  Row(
                    children: [
                      Icon(
                        _getStatusIcon(product.approval!.status),
                        color: _getStatusColor(product.approval!.status),
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        product.approval!.status.name ,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _getStatusColor(product.approval!.status),
                        ),
                      ),
                    ],
                  ),*/
                  const SizedBox(height: 4),
                  // Date de disponibilité
                  Text(
                    'Disponible le: ${product.availabilityDate.day}/${product.availabilityDate.month}/${product.availabilityDate.year}',
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