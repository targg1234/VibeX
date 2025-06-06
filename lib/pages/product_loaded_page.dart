import 'package:chat_mania/pages/widgets/product_card.dart';
import 'package:chat_mania/pages/widgets/slide_fade.transition.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductLoadedPage extends StatefulWidget {
  final List<Product> products;

  const ProductLoadedPage({
    super.key,
    required this.products,
  });

  @override
  State<ProductLoadedPage> createState() => _ProductLoadedPageState();
}

class _ProductLoadedPageState extends State<ProductLoadedPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sortedProducts = List<Product>.from(widget.products)
      ..sort(
        (a, b) => _parseDate(b.createdAt).compareTo(_parseDate(a.createdAt)),
      );

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedProducts.length,
      itemBuilder: (context, index) {
        final product = sortedProducts[index];
        return SlideFadeTransition(
          animation: _animationController,
          index: index,
          child: ProductCard(product: product),
        );
      },
    );
  }

  DateTime _parseDate(String? iso) {
    return DateTime.tryParse(iso ?? '') ?? DateTime(1970);
  }
}
