import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './product_item.dart';
import '../providers/products_provider.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;

  ProductsGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
    // Definimos el Listener mediante la clase provider + el método .of + <ClaseDelDataProvider> + (context)
    // accedemos a la instancia de la clase mediante el getter definido en el provider, que le hemos llamado items.
    final productsData = Provider.of<Products>(context);
    final products = showFavs ? productsData.favoriteItems : productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      // crossAxisCount -> cantidad de columnas que quiero tener.
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: ProductItem(
            //products[i].id,
            //products[i].title,
            //products[i].imageUrl,
            ),
      ),
    );
  }
}
/*
Para establecer el State Management necesitamos:
- En todos los archivos donde queremos usarlo, debemos importar el provider package. (import 'package:provider/provider.dart';)

- Crear el modelo: Clase que "obtiene las habilidades de ChangeNotifier" mediante "with ChangeNotifier".
    class Products with ChangeNotifier {}
  Normalmente la ubicaremos en la carpeta /models.
  Clase que es un objeto que queremos guardar y que queremos que avise a los listeners cada vez que haya algún cambio en esa clase.

- Usar el widget ChangeNotifierProvider en el padre de donde estarán todos los Listeners, 
  o sea, que en el widget tree esté arriba de cualquier widget donde se va a usar esta información.
  En este caso queremos tener un provider para cada producto, 
  entonces usamos el loop que nos ofrece el argumento itemBuilder de GridView.builder() 
  para crear un ChangeNotifierProvider y dentro de él, el widget ProductItem.

- El Listener:

Hay 2 opciones:
A)En el widget donde necesitamos acceder a la información, usamos Provider.of<NombreDeLaClase>(context);
  Por ejemplo, si la clase se llama products:
    final productsData = Provider.of<Products>(context);
  Cuando cambie algo de la clase que estamos escuchando, se ejecutará el método build() a menos que le pasemos el atributo listen: false 
    final productsData = Provider.of<Products>(context, listen: false);

B)Envolvemos la parte específica donde queremos usar la información del provider con el widget Consumer()
  - detrás del nombre Consumer tenemos que agregar la clase que queremos escuchar entre <>
      Consumer<Product>()
  Y le tenemos que aportar un atributo builder que quiere una función, la cual recibe:
    - recibe el context, la instancia de la clase que está escuchando y un child
        > el atributo child se usa cuando hay una parte de este widget que no depende de los cambios en la info del provider.
        En este caso, podemos pasar un widget y usarlo dentro del objeto que retorna la función.
    - retorna los hijos que estarán dentro de este widget
  Consumer<Product>(
    builder: (ctx, product, child) => hijos del widget (...)
  )

*/
