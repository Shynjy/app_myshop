import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Dados
import '../providers/cart.dart';
import '../providers/orders.dart';

// Widget
import '../widgets/cart_item_widget.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of<Cart>(context);
    final cartItems = cart.items.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Carrinho'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: Column(
          children: <Widget>[
            Card(
              margin: EdgeInsets.only(top: 15),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      'Total',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Chip(
                      label: Text(
                        'R\$ ${cart.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .headline6
                              .color,
                        ),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    Spacer(),
                    FlatButton(
                      child: const Text('COMPRAR'),
                      textColor: Theme.of(context).primaryColor,
                      onPressed: () {
                        // Não permite a compra zerada
                        if (cart.totalAmount <= 0.0) return;
                        Provider.of<Orders>(context, listen: false)
                            .addOrder(cart); // Adiciona
                        cart.clear(); // Limpa o carrinho
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: cart.itemsCount,
                itemBuilder: (ctx, index) => CartItemWidget(cartItems[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
