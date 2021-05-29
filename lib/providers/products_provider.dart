import 'package:flutter/material.dart';
// importamos la librería http con un prefijo para evitar posibles nombres de clases duplicados
import 'package:http/http.dart' as http;
//librería de dart para convertir tipos de datos.
import 'dart:convert';
import './product.dart';

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

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite == true).toList();
  }

  // Es mejor mover la lógica afuera de los widgets, por ejemplo dejarla en la clase Provider
  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  // no queremos que se pueda modificar el valor de la variable en cualquier parte de la app
  // porque cuando cambie su valor, debemos avisar a todos los Listeners de que hay nueva información disponible.

  //nos aseguramos que sólo se modificará a través de estos métodos,
  // y en ellos nos ocupamos de avisar a los Listeners mediante el notifyListeners()

  // queremos que retorne un Future cuando termine de añadir el producto, pero no queremos que retorne nada en el then
  // por eso definimos el future así: Future<void>
  Future<void> addProduct(Product product) {
    // código asíncrono (asynchronous, "async") -> significa que ejecuta una lógica mientras otro código continua ejecutándose
    const url =
        'https://myshop-flutter-51303-default-rtdb.europe-west1.firebasedatabase.app/products.json';
    // el método http.post retorna un Future, y el .then() que usamos después retorna otro future.
    // por eso, con el return http.post(......) retornará la respuesta cuando termine del último .then
    return http
        .post(
      Uri.parse(url),
      body: json.encode(
        {
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'isFavorite': product.isFavorite,
        },
      ),
    )
        // Código Asíncrono "ASYNC"-> poder ejecutar funciones mientras se ejecutan otras órdenes que pueden tardar mas o que no sabemos cuánto tardarán.
        // el método post() retorna un Future con la respuesta del servidor.
        // los Future en general, pueden no devolver nada. En ese caso, igualmente hay que aceptar un argumento en el then, aunque luego no lo usamos
        // cualquier .then() retorna un Future, con lo cual podemos encadenar .then().then... y se ejecutarán por orden, a medida que los vaya ejecutando
        // lo cual significa que podemos usar el método .then() después de él, y éste se ejecutará cuando el servidor nos devuelva la respuesta.
        .then((response) {
      print(json.decode(response.body));
      // firebase nos devuelve la response, la cual, el body es un map { name: id }
      // es muy recomendado usar la misma id para la información local y la bbdd para el flujo de información
      // normalmente se usa la id generada por el backend porque es mas fácil de generar ahí
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      notifyListeners();
    })
        // el .catchError se ejecutará si hubo algún error ya sea en el http.post() o en el .then()
        // si hubiera un error en http.post(), no se ejecutaría el .then() e iría directamente al .catchError()
        .catchError((error) {
      print(error);
      // podemos gestionar qué hacer con el error, y tamien podemos crearlo de nuevo, con throw + el error
      // entonces, el lugar donde llamamos al addProduct(), que está esperando la respuesta de este Future, captará el error con un .catchError()
      // también lo captaría con .catchError si no hiciéramos catchError aquí.
      throw error;
    });
  }

  void updateProduct(String id, Product newProduct) {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    // para asegurarnos que realmente vamos a actualizar un producto que existe, que está en la lista
    if (prodIndex >= 0) {
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('este producto no existe');
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }
}
