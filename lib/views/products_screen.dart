import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Widgets
import '../widgets/app_drawer.dart';
import '../widgets/product_item.dart';

// Rotas
import '../utils/app_routes.dart';

// Dados
import '../providers/products.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  Future<void> _refreshProducts(BuildContext context) {
    return Provider.of<Products>(context, listen: false).loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);
    final productsItems = products.items;
    return WillPopScope(
      onWillPop: () async {
        if (_key.currentState.isDrawerOpen) {
          Navigator.of(context).pop();
          return false;
        }
        Navigator.of(context).pushReplacementNamed(AppRoutes.AUTH_HOME);
        return true;
      },
      child: Scaffold(
        key: _key,
        appBar: AppBar(
          title: const Text('Gerenciar Produtos'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.PRODUCT_FORM);
              },
            ),
          ],
        ),
        drawer: AppDrawer(),
        body: RefreshIndicator(
          onRefresh: () => _refreshProducts(context),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: ListView.builder(
              itemCount: products.itemsCount,
              itemBuilder: (ctx, index) => Column(
                children: <Widget>[
                  ProductItem(productsItems[index]),
                  Divider(thickness: 1),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
