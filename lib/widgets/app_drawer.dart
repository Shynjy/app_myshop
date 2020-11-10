import 'package:flutter/material.dart';

// Rotas
import '../utils/app_routes.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String isSettingPage;

    Navigator.popUntil(context, (route) {
      isSettingPage = route.settings.name;
      return true;
    });

    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: const Text('Bem vindo Usúario!'),
            centerTitle: true,
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Loja'),
            onTap: () {
              isSettingPage == AppRoutes.HOME
                  ? Navigator.of(context).pop()
                  : Navigator.of(context).pushReplacementNamed(AppRoutes.HOME);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Pedidos'),
            onTap: () {
              isSettingPage == AppRoutes.ORDERS
                  ? Navigator.of(context).pop()
                  : Navigator.of(context).pushReplacementNamed(AppRoutes.ORDERS);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Gerenciar Produtos'),
            onTap: () {
              isSettingPage == AppRoutes.PRODUCTS
                  ? Navigator.of(context).pop()
                  : Navigator.of(context).pushReplacementNamed(AppRoutes.PRODUCTS);
            },
          ),
        ],
      ),
    );
  }
}
