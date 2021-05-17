import 'package:flutter/material.dart';

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
  */

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'title',
        ),
      ),
    );
  }
}
