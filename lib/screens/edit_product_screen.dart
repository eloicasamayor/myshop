import 'package:flutter/material.dart';

import '../providers/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = 'edit-product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  // GlobalKey es una clase que nos permite interactuar con el State del widget Form
  // tenemos que crear la instancia de GlobalKey<FormState>() y asociarla al Form con el argumento key
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );

  @override
  void initState() {
    _imageUrlController.addListener(_updateImageUrl);
    super.initState();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

// el método dispose se llama cuando el widget se elimina del widget tree. nos sirve para liberar memoria de objetos que ya no necesitamos. y para resetear variables a su valor por defecto.
  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _saveForm() {
    //.validate() retornará true si no hay ningún error, y falso si hay alguno.
    final _isValid = _form.currentState.validate();
    if (!_isValid) {
      return;
    }
    // podemos acceder al estado del form a través de la globalkey que hemos creado y asociado al form
    _form.currentState.save();
    // .save() llamará el método onSaved en cada formField que hará lo que le digamos
    print(_editedProduct.title);
    print(_editedProduct.price);
    print(_editedProduct.description);
    print(_editedProduct.imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [IconButton(icon: Icon(Icons.save), onPressed: _saveForm)],
      ),
      // el widget Form() es invisible pero aporta muchas funcionalidades para manejar formularios
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onSaved: (value) {
                  // tenemos que crear una nueva instancia del product ya que todas las propiedades son finals
                  // con lo cual no podemos reasignar una propiedad una vez ya se ha creado
                  // pero podemos crear una nueva instancia de product y sobreescribir el valor de _editedProduct
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    title: value,
                    description: _editedProduct.description,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
                  );
                },
                // argumento validator -> definimos una función que valida el valor del input ( el cual lo pasamos como parámetro a la función)
                // si retorna null, significa que no hay ningún error
                // si retorna un string, este será el mensaje de error, el que queremos mostrar al usuario.
                // esta función se puede llamar:
                // -> Con el argumento auto validate en el widget Form, se lanzará en cada tecla que se presione en el input
                // -> Podemos llamar a todas las funciones de validación del Form mediante la globalkey: _form.currentState.validate()
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please provide a value';
                  }

                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    title: _editedProduct.title,
                    description: _editedProduct.description,
                    price: double.parse(value),
                    imageUrl: _editedProduct.imageUrl,
                  );
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please provide a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  if ((double.parse(value) <= 0) ||
                      (double.parse(value) >= 1000)) {
                    return 'Please provide a value between 0 and 10000';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.next,
                onSaved: (value) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    title: _editedProduct.title,
                    description: value,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
                  );
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please provide a value';
                  }
                  if (value.length < 10) {
                    return 'Please provide a longer description (10 characters)';
                  }
                  return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(
                      top: 8,
                      right: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                    ),
                    child: _imageUrlController.text.isEmpty
                        ? Text('Enter a URL')
                        : FittedBox(
                            child: Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      // cuando trabajamos con Form() no hace falta crear los controllers para cada input
                      // pero en este caso nos interesa para previsualizar la imagen antes del submit.
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                          imageUrl: value,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value';
                        }
                        if (!value.startsWith('http')) {
                          return 'Please provide a valid image URL';
                        }
                        if (!value.endsWith('png') &&
                            !value.endsWith('jpeg') &&
                            !value.endsWith('jpg')) {
                          return 'Please provide a valid image URL';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }
}
