import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Tipos
// import '../providers/product.dart';

// Widgets
import '../widgets/product_grid_item.dart';

// Dados
import '../providers/products.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavoriteOnly;

  const ProductGrid(this.showFavoriteOnly);

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<Products>(context);
    final products = showFavoriteOnly ? productsProvider.favoriteItems : productsProvider.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length, // Sempre passar a quantidade de itens
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        value: products[index],
        child: ProductGridItem(),
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
