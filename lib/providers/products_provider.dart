import 'package:flutter/material.dart';

import '../models/product.dart';

class Products with ChangeNotifier {
  //nombramos la variable con la _ para dejar claro que no debe ser accesible desde fuera de la clase.
  //no es final porque cambiará con el tiempo.
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  // un getter público (sin la _) el cual retorna una copia de _items.
  List<Product> get items {
    return [..._items];
  }

  // no queremos que se pueda modificar el valor de la variable en cualquier parte de la app
  // porque cuando cambie su valor, debemos avisar a todos los Listeners de que hay nueva información disponible.

  //nos aseguramos que sólo se modificará a través de estos métodos,
  // y en ellos nos ocupamos de avisar a los Listeners mediante el notifyListeners()

  void addProduct() {
    //_items.add(value);
    notifyListeners();
  }
}
