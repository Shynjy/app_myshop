import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Tipos
import '../models/product.dart';

// Widgets
import '../widgets/product_item.dart';

// Dados
import '../providers/products.dart';

class ProductGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Product> leadedProducts = Provider.of<Products>(context).items;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: leadedProducts.length, // Sempre passar a quantidade de itens
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        value: leadedProducts[index],
        child: ProductItem(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Quantidade de itens no Row
        childAspectRatio: 3 / 2, // Proporção do item
        crossAxisSpacing: 10, // Espaçamento
        mainAxisSpacing: 10, // Espaçamento
      ),
    );
  }
}