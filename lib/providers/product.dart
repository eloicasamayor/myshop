import 'package:flutter/foundation.dart';
//foundation.dart nos permite usar el decorator @required

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  // isFavorite no es final porque podrá ir cambiando despues de ser creada
  // indicará si el artículo está marcada por el usuario como favorito.
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  //método para invertir el valor de isFavorite. Si era true será false, y si era false será true.
  void toggleFavoriteStatus() {
    isFavorite = !isFavorite;
    //avisamos a todos los listeners con el notifyListeners()
    notifyListeners();
  }
}
