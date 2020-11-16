import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Widgets
import '../widgets/app_drawer.dart';
import '../widgets/order_widget.dart';

// Rotas
import '../utils/app_routes.dart';

// Tipos
import '../providers/orders.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_key.currentState.isDrawerOpen) {
          Navigator.of(context).pop();
          return false;
        }
        Navigator.of(context).pushReplacementNamed(AppRoutes.HOME);
        return true;
      },
      child: Scaffold(
        key: _key,
        appBar: AppBar(
          title: Text('Meus Pedidos'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: Provider.of<Orders>(context, listen: false).loadOrders(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.error != null ){
              return Center(
                child: Text('Ocorreu um erro!'),
              );
            } else {
              return Consumer<Orders>(
                builder: (ctx, orders, child) {
                  return ListView.builder(
                    itemCount: orders.itemsCount,
                    itemBuilder: (ctx, index) =>
                        OrderWidget(orders.items[index]),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
