import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './providers/products_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // envolvemos MaterialApp con el widget ChangeNotifierProvider
    // nos permite definir una clase, y cuando esa clase cambie, todos los hijos que estén escuchando (no todos los hijos, solo los que están escuchando) ejecutarán build()
    return ChangeNotifierProvider(
      // en el argumento create, se crea una instancia de la clase del Data Provider.
      create: (ctx) => Products(),
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
        },
      ),
    );
  }
}
