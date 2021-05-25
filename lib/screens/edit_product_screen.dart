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
