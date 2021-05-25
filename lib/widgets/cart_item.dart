import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  CartItem({
    this.id,
    this.productId,
    this.price,
    this.quantity,
    this.title,
  });
  @override
  Widget build(BuildContext context) {
    // Dismissable es un widget de Flutter que ya está preparado para ser un elemento de una lista que se pueda eliminar con un gesto.
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      // argumento confirmDismiss -> nos pide una función. Obtenemos la DismissDirection y tenemos que retornar un Future.
      confirmDismiss: (direction) {
        // showDialog retorna un Futuro, que es la respuesta escojida por el usuario
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to remove the item from the cart?'),
            actions: [
              FlatButton(
                  child: Text('No'),
                  onPressed: () {
                    // Navigator .pop() cierra el diálogo y podemos enviar un valor como resultado del Future.
                    Navigator.of(ctx).pop(false);
                  }),
              FlatButton(
                  child: Text('Yes'),
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
                  }),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 30,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      child: Card(
          margin: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 4,
          ),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: ListTile(
              leading: CircleAvatar(
                child: Padding(
                    padding: EdgeInsets.all(5),
                    child: FittedBox(child: Text('\$$price'))),
              ),
              title: Text(title),
              subtitle: Text('Total: \$${(price * quantity)}'),
              trailing: Text('$quantity x'),
            ),
          )),
    );
  }
}
