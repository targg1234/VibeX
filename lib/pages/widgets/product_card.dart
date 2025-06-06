import 'package:chat_mania/models/product.dart';
import 'package:flutter/material.dart';
import 'product_popup_menu.dart';
import 'date_time_formatter.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = theme.colorScheme.primary;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: isDark ? Colors.grey[900] : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isDark ? const BorderSide(color: Colors.white) : BorderSide.none,
      ),
      elevation: 2,
      shadowColor: isDark ? Colors.white : Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: product.avatar != null
                      ? NetworkImage(product.avatar!)
                      : null,
                  child:
                      product.avatar == null ? const Icon(Icons.person) : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name ?? 'No Name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.access_time,
                              size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            product.createdAt.formatDateTime(),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ProductPopupMenu(product: product),
              ],
            ),
            const SizedBox(height: 12),
            Text(product.description ?? 'No Description'),
          ],
        ),
      ),
    );
  }
}
