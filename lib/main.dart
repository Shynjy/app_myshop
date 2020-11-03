import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Pages
import './views/products_overview_screen.dart';
import './views/product_detail_screen.dart';

// Rotas
import './utils/app_routes.dart';

// Dados
import './providers/products.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Products(),
      child: MaterialApp(
        title: 'Minha Loja',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        // home: ProductsOverviewScreen(),
        initialRoute: AppRoutes.HOME,
        routes: {
          AppRoutes.HOME: (ctx) => ProductsOverviewScreen(),
          AppRoutes.PRODUCT_DETAIL: (ctx) => ProductDetailScreen(),
        },
        onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (_) {
          return ProductsOverviewScreen();
        });
      },
      ),
    );
  }
}
