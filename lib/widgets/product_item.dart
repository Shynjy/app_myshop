import 'package:app_myshop/exceptions/http_exception.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Dados
import '../providers/product.dart';
import '../providers/products.dart';

// Rotas
import '../utils/app_routes.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  ProductItem(this.product);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.title),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(AppRoutes.PRODUCT_FORM, arguments: product);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('Excluir Produto'),
                    content: Text('Tem certeza?'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('SIM'),
                        onPressed: () => Navigator.of(ctx).pop(true),
                      ),
                      FlatButton(
                        child: Text('NÃO'),
                        onPressed: () => Navigator.of(ctx).pop(false),
                      ),
                    ],
                  ),
                ).then(
                  (value) async {
                    if (value) {
                      try {
                        await Provider.of<Products>(context, listen: false)
                            .deleteProduct(product.id);
                      } on HttpException catch (error) {
                        scaffold.showSnackBar(
                          SnackBar(
                            content: Text(error.toString()),
                            action: SnackBarAction(
                              label: 'Fechar',
                              onPressed: () {
                                scaffold..hideCurrentSnackBar();
                              },
                            ),
                          ),
                        );
                      }
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
