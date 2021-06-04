import 'package:flutter/material.dart';
import 'package:myshop/providers/auth.dart';
import 'package:provider/provider.dart';

import './providers/cart.dart';
import './providers/orders.dart';
import './providers/products_provider.dart';
import './providers/auth.dart';

import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
import './screens/splash_screen.dart';
import './helpers/custom_route.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // envolvemos MaterialApp con el widget ChangeNotifierProvider
    // nos permite definir una clase, y cuando esa clase cambie, todos los hijos que estén escuchando (no todos los hijos, solo los que están escuchando) ejecutarán build()

    // Tambien podemos definir múltiples clases como providers, mediante el widget MultiProvider
    // en el atributo providers ponemos todos los providers en una lista.
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (ctx) => Products(null, null, []),
          update: (ctx, auth, previousProducts) => Products(
            auth.token,
            auth.userId,
            previousProducts == null ? [] : previousProducts.items,
          ),
          // inicializamos la lista de productos con los productos anteriores si los había, y si no con una lista vacía.
        ),
        ChangeNotifierProxyProvider<Auth, Cart>(
          create: (ctx) => Cart(null, {}),
          update: (ctx, auth, previousCartItems) => Cart(
            auth.token,
            previousCartItems == null ? [] : previousCartItems.items,
          ),
          // inicializamos la lista de productos con los productos anteriores si los había, y si no con una lista vacía.
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (ctx) => Orders(null, null, []),
          update: (ctx, auth, previousOrderData) => Orders(
            auth.token,
            auth.userId,
            previousOrderData == null ? [] : previousOrderData.orders,
          ),
          // inicializamos la lista de productos con los productos anteriores si los había, y si no con una lista vacía.
        ),
      ],

      //return ChangeNotifierProvider.value(
      // en el argumento create, se crea una instancia de la clase del Data Provider.

      //value: Products(),
      //return ChangeNotifierProvider(
      //create: (ctx) => Products(),
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MyShop',
          theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato',
              pageTransitionsTheme: PageTransitionsTheme(builders: {
                TargetPlatform.android: CustomPageTransitionBuilder(),
                TargetPlatform.iOS: CustomPageTransitionBuilder(),
              })),
          home: auth.isAuth
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}

/*
ChangeNotifierProvider()
  -> en el argumento create le pasamos una función anónima que recibe el context y retorna la instancia de la funcion que queremos proveer
  -> se recomienda usarlo cuando provemos al ChangeNotifierProvider con una nueva instancia de la clase

Si usamos ChangeNotifierProvider.value()
  -> en el argumeto value le pasamos directamente la clase que queremos proveer.abstract
  -> se recomienda usarlo cuando provemos al ChangeNotifierProvider con un objeto reusado (por ejemplo products[i] )

Por eso, si no necesitamos el context, es mas simple usar el ChangeNotifierProvider()

Cuando el provider está como hijo de ListView o GridView, debemos usar ChangeNotifierProvider.value()
ya que Flutter recicla los widgets que salen fuera de la pantalla, y se pierde la conexión entre cada widget y su provider.
*/
