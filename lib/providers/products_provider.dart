import 'package:flutter/material.dart';
// importamos la librería http con un prefijo para evitar posibles nombres de clases duplicados
import 'package:http/http.dart' as http;
//librería de dart para convertir tipos de datos.
import 'dart:convert';
import './product.dart';
import '../models/http_exception.dart';

class Products with ChangeNotifier {
  //nombramos la variable con la _ para dejar claro que no debe ser accesible desde fuera de la clase.
  //no es final porque cambiará con el tiempo.
  List<Product> _items = [
    /*Product(
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
    ),*/
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

  Future<void> fetchAndSetProducts() async {
    const url =
        'https://myshop-flutter-51303-default-rtdb.europe-west1.firebasedatabase.app/products.json';
    // como estamos dentro de "async", podemos usar "await" para esperar por la respuesta
    // almacenamos la respuesta en una variable porque la respuesta contendrá los datos
    try {
      final response = await http.get(Uri.parse(url));
      // sabemos que el map contiene un map para cada string, pero Flutter daría error si lo ponemos. hay que poner "dynamic"
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          isFavorite: prodData['isFavorite'],
          imageUrl: prodData['imageUrl'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  // queremos que retorne un Future cuando termine de añadir el producto, pero no queremos que retorne nada en el then
  // por eso definimos el future así: Future<void>
  Future<void> addProduct(Product product) async {
    // código asíncrono (asynchronous, "async") -> significa que ejecuta una lógica mientras otro código continua ejecutándose
    const url =
        'https://myshop-flutter-51303-default-rtdb.europe-west1.firebasedatabase.app/products.json';
    // con la key "await" le decimos a Dart que tiene que 'esperarse' a que termine. podemos usar "await" porque estamos dentro de una funcion o método async
    try {
      final response = await http.post(
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
      );
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://myshop-flutter-51303-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json';
      try {
        await http.patch(
          Uri.parse(url),
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }),
        );
      } catch (error) {
        print("could not update product");
      }
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('this product does not exist');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://myshop-flutter-51303-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json';
    // optimistic updating -> esta tecnica de actualizar datos sin usar Future
    // guardamos el valor antiguo
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];

    // lo eliminamos de la lista en memoria local (pero sigue estando en la variable existingProduct)
    _items.removeAt(existingProductIndex);
    notifyListeners();
    // intentamos eliminarlo de la base de datos
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete the product.');
    }
    existingProduct = null;
    // si no se ha podido actualizar por un error, volvemos a insertar el dato en la lista en memoria local
  }
}
