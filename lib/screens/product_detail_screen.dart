import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = 'product-detail';

  /*
  State: información que afecta a la UI, y que puede variar en el tiempo
  UI: es la forma en la que se muestra esta información al usuario. Si State cambia, la UI tiene que cambiar.

  App-wide State: afecta toda la app, o una gran parte. Autenticación, productos cargados...
  Widget (Local) State: sólo afecta a este widget. isLoading (gif cargando), form input...

  >The Provider Package & Pattern
  Creamos un "Data Provider" global que adjuntamos a un widget de la app. No tiene porque ser el widget principal.
  Una vez hemos adjuntado el Data Provider al widget, todos los hijos de éste pueden "escucharlo".
  No es necesario pasar la infomrmación a los hijos, sino que desde ellos cremos un "Listener", el cual se relaciona internamente con el Data Provider mediante el ".of(context)"
  Cuando tenemos el Listener en un widget, se ejecutará build() cuando cambie el State del Data Provider relacionado.

  Pueden haber múltiples Data Providers en la app, y múltiples Listeners.

  ------

  -> Inheritance

  class Mamifero {
    void respirar() {
      print ('Inhala... exhala...');
    }
  }
  class Person extends Mamífero {
    String name;
    int age;

    Person(this.name, this.age);
  }
  Cuando usamos la palabra clave "extends" en la definición de la clase, seguida del nombre de otra clase
  Estamos diciendo que esta nueva clase hereda todas las propiedades y métodos de la clase padre
  Podemos sobreescribir métodos o propiedades de la clase de la que heredamos, indicándolo con el "@override"
  Si creamos una instancia de la nueva clase con un constructor, esta instancia será de tipo Person y también de tipo Mamifero
  

  -> Mixins
  Podemos definir un mixin con la palabra clase mixin

  mixin Agility {
    var speed = 10;
    void sitDown() {
      print('Sitting down');
    }
  }
  Y desde cualquier clase podemos usarlo mediante la palabra clave "with" seguida del nombre del mixin
  De esta manera podemos usar los métodos y propiedades del mixin.
  Es muy parecido a la inheritance (herencia), pero:
  - Se debe usar cuando la conexión no es tan fuerte entre las 2 clases. Sólo agrega ciertas utilidades, pero no "es" de ese tipo
  - Se pueden usar varios mixins al mismo tiempo, a diferencia del extends, que solo puede heredar de un solo padre.
  */

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct = Provider.of<Products>(
      context,
      listen: false,
      //el método .of() nos prové de una opción listen:. Por defecto es true, significa que cuando cambie algo de la clase que estamos escuchando, llamará al build()
      // si ponemos listen: false, entonces no hará rebuild con cualquier cambio.
    ).findById(productId);
    //siempre es mejor tener widgets livianos, y trasladar la lógica en la clase Provider.

    return Scaffold(
      appBar: AppBar(
        title: Text(
          loadedProduct.title,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Hero(
                tag: loadedProduct.id,
                child: Image.network(
                  loadedProduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              '\$${loadedProduct.price}',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  loadedProduct.description,
                  textAlign: TextAlign.center,
                  softWrap: true,
                ))
          ],
        ),
      ),
    );
  }
}
