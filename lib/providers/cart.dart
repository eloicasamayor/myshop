import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  // cada cart item estará directamente relacionado con un producto
  // para ello creamos un map (privado) donde se relaciona cada cart item con la id del producto
  Map<String, CartItem> _items = {};

  // y un getter para poder acceder al map desde fuera (solo leerlo, no alterarlo)
  Map<String, CartItem> get items {
    return {..._items};
  }

  // y un getter que devuelva la cantidad de productos en la cart
  int get itemCount {
    var quantity = 0;
    _items.forEach((key, cartItem) {
      quantity += cartItem.quantity;
    });
    return quantity;
  }

  //método para eliminar un item de la cart
  void removeItem(String productId) {
    // .remove() es un método de Map al cual le pasamos la key y elimina el item asociado a esa key.
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }

  //método para remover un solo elemento (restar candidad -1 )
  void removeSingleItem(String productId) {
    //primero comprobamos que este producto esté en el map. Si no está, no hace nada
    if (!_items.containsKey(productId)) {
      return;
    }
    // si la cantidad es mayor que 1, actualizamos la cantidad restándole 1
    if (_items[productId].quantity > 1) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          quantity: existingCartItem.quantity - 1,
          price: existingCartItem.price,
        ),
      );
    }
    // si la cantidad es 0, borramos ese item del mapa.
    else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  //getter para calcular el coste total del cart
  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  // y una función para agregar un cartItem
  // por ahora, solo podremos agregar un producto a la vez, con lo cual quantity será 1
  void addItem(
    String productId,
    double price,
    String title,
  ) {
    // .contaninsKey() es un método de Map que nos devuelve si contiene una key (true/false)
    if (_items.containsKey(productId)) {
      // change quantity
      // .update() es un método de Map para actualizar un item del map
      // requiere que le pasemos la key en la cual queremos actualizar el valor
      // y una funcion, que automáticamente obtiene el valor actual
      // y retorna el valor nuevo actualizado. En este caso, creamos una nueva instancia de CartItem con los valores actualizados (basados en el objeto anterior)
      _items.update(
          productId,
          (existingCartItem) => CartItem(
                id: existingCartItem.id,
                title: existingCartItem.title,
                price: existingCartItem.price,
                quantity: existingCartItem.quantity + 1,
              ));
    } else {
      // putIfAbsent es un método de Map para agregar un elemento al map
      // requiere que le pasemos una función que retorna el nuevo item
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }
}
