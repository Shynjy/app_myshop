import 'package:flutter/material.dart';

// Tipo
import '../models/product.dart';

// Dados
import '../data/dummy_data.dart';

// Widgets
import '../widgets/product_item.dart';

class ProductsOverviewScreen extends StatelessWidget {
  final List<Product> leadedProducts = DUMMY_PRODUCTS;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minha Loja'),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: leadedProducts.length, // Sempre passar a quantidade de itens
        itemBuilder: (ctx, index) => ProductItem(leadedProducts[index]),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Quantidade de itens no Row
          childAspectRatio: 3 / 2, // Proporção do item
          crossAxisSpacing: 10, // Espaçamento
          mainAxisSpacing: 10, // Espaçamento
        ),
      ),
    );
  }
}
