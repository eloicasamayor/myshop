import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_detail_screen.dart';
import '../providers/product.dart';
import '../providers/products_provider.dart';
import '../providers/cart.dart';

class ProductItem extends StatefulWidget {
  //final String id;
  //final String title;
  //final String imageUrl;

  //ProductItem(this.id, this.title,this.imageUrl);

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context, listen: false);
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    var _patchingFavorite = false;
    // obtengo la info del provider que nececito para crear los widgets, pero le digo que no esté escuchando a los cambios
    // porque lo único que puede cambiar es el icono de favorito, y ahí crearé un Consumer
    // El Consumer sí escuchará los cambios en Product, pero no rehará todo el widget sino solo lo que está dentro de él.
    return ClipRRect(
      // ClipRRect -> fuerza su hijo a tener cierta forma
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          leading: Consumer<Product>(
            builder: (
              ctx,
              product,
              child,
            ) =>
                IconButton(
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
              onPressed: () async {
                setState(() {
                  _patchingFavorite = true;
                });
                _patchingFavorite = true;
                await product.toggleFavoriteStatus();
                setState(() {
                  _patchingFavorite = false;
                });
              },
              color: Theme.of(context).accentColor,
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(product.id, product.price, product.title);
              // con Scaffold.of(context) establecemos una conexión con el Scaffold mas cercano ( que controla la página donde estamos)
              // .hideCurrentSnackBar() borra la snackbar si la hubiera.
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Added item to cart',
                  ),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                  ),
                ),
              );
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
