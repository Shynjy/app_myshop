import 'package:app_myshop/providers/products.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Rotas
import '../utils/app_routes.dart';

// Widgets
import '../widgets/product_grid.dart';
import '../widgets/badge.dart';
import '../widgets/app_drawer.dart';

// Dados
import 'package:app_myshop/providers/cart.dart';

enum FilterOptions {
  Favorite,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showFavoriteOnly = false;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Carregar os produtos
    Provider.of<Products>(context, listen: false).loadProducts().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // final Products products = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha Loja'),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                selectedValue == FilterOptions.Favorite
                    ? _showFavoriteOnly = true
                    : _showFavoriteOnly = false;
              });
            },
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: const Text('Todos'),
                value: FilterOptions.All,
              ),
              PopupMenuItem(
                child: const Text('Somente Favoritos'),
                value: FilterOptions.Favorite,
              ),
            ],
          ),
          Consumer<Cart>(
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.CART);
              },
            ),
            builder: (_, cart, child) => Badge(
              value: cart.itemsCount.toString(),
              child: child,
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(_showFavoriteOnly),
    );
  }
}