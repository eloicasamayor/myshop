# myshop flutter app: learning to build flutter apps
Shopping app made with Flutter. This was done following a great [Flutter course in Udemy](https://www.udemy.com/course/learn-flutter-dart-to-build-ios-android-apps/)
Here I have been writing down the concepts learned in the course.

## Deployment
You can see the web app deployed at [GitHub Pages](https://eloicasamayor.github.io/myshop/#/)

## Inheritance
When we use the key "extends" in the class definition, followed by the name of another class we are saying that this new class inherits all properties and methods of the father class. A class can extend maximum from another class. We can override methods and properties, indicating it with the decorator "@override".
```dart
  class Mamifero {
    void respirar() {
      print ('Inhala... exhala...');
    }
  }
  class Person extends Mamifero {
    String name;
    int age;

    Person(this.name, this.age);
  }
```
> In this case, every instance of Person will be of type Person and also of type Mamifero.
  

## Mixins
We define a mixin with the key mixin. And we can use this mixin with the key "with" followed by the mixin name in a class definition. When using a mixin, that class will have the methods and properties of the mixin. It is a lot like inheritance, but with mixins the intances of the class are not of mixin' type. It must be used when the connection with the elements is not that strong. We can use multiple mixins at the same time. 

## State Management: using the provider package
<br> - Building the providers using the within ChangeNotifier and getters to get the data. Using the notifyListeners() functions to alert listeners at any change in the data.
<br> - Stablishing the Provider in the highest widget in the widget tree where we will need that data using the ChangeNotifierProvider() or ChangeNotifierProvider.value() and referencing the Class.
<br> - On Children of the Provider widget we can listen the provider in two ways:

### The Provider.of<T>(context) method
With Provider.of<ClassName>(context). We rebuild the entire widget on every change in the provider data. unless we add the "listen: false" argument.

### The Consumer() widget 
With Consumer<ClassName>(builder: (ctx, data, child) => widget), child: child. Here we only rerun wha'ts inside the Consumer widget.
### Multiple providers.
- We will use **StatefulWidget** when the state (the data) only affect that widget or maybe his child<br>
- We will use the **provider package** when the state affects all the app or multiple places around the widget tree.
<br>

## User inputs and Forms
- Using the **Snackbar** widget and adding the opction to UNDO.
- Using the **Alert** widget and do something depending on the user response.
- Using **Forms** 
- --- Validation
- --- Saving the data
- --- Using the same form for creating and editing a product

## HTTP Requests

### Async code in Flutter: the Future class

One logic executes while other function is still running. Its convenient when we don't know how much time it will take or if it posibly result in an error. There are two ways of managing it on Flutter: Future + .then() + .catchError() or async + wait
-  http.post() method returns a Future with the server response.
-  Future in general, can return nothing. In that case,  we should accept an argument in the then() method anyway, even if we don't use it.
-  All .then() returns a Future, so we can chain .then().then().then()... and they will run in order, as soon as they finish. So we can use .then() after http.post(). This will run when the server responds and we can handle that response on it. 
- In this case firebase returns as a response as a map with the random id { name: id }. We take it to save it in local memory as well.

## Error handling
- .catchError will run if there is an error in http.post() or in .then(). If there were an error in http.post(), it will no run the .then() so it will go directly to the .catchError()
- we can handle here the error, and we can throw it again with the "throw" key. Then, the place where we called addProduct(), who is waiting for the response of the Future, will receive the error with the  .catchError() (it would also catch the error if we wouldn't do the .catchError here). So, the error is only catched with the first .catchError in line.
- HTTP Request example using Future<>, .then() and .catchError()

```dart
Future<void> addProduct(Product product) {
    const url ='https://url.firebasedatabase.app/products.json';
    return http.post(
      Uri.parse(url),
      body: json.encode(
        {'map defining the product'},
      ),
    ).then((response) {
      print(json.decode(response.body));
      final newProduct = Product(
        'product body',
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      notifyListeners();
    }).catchError((error) {
      print(error);
      throw error;
    });
  }
```
<br>HTTP Request example using async & await and try{}catch{}

```dart
  Future<void> addProduct(Product product) async {
    const url ='https://url.firebasedatabase.app/products.';
    // con la key "await" le decimos a Dart que tiene que 'esperarse' a que termine. podemos usar "await" porque estamos dentro de una funcion o método async
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(
           {'map defining the product'},
        ),
      );
      final newProduct = Product(
        'product body',
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
```
<br>With the try-catch, it will try to run the code inside "try", and if it fails, the "catch" will be executed. The code inside "finally" should execute no matters there was an error or not.
<br>The async method or function returns a Future.

### We cannot use initState in some cases
- **We cannot use .of(context) inside the initState() method**. That's because here the widget is not fully loaded yet. There are 3 posible workarrounds:
<br> A) when using Provider.of<class>(context), it will work when we don't want to listen, like this: 

```dart
Provider.of<ClassOfTheProvider>(context, listen: false)
```
<br> B) Create a Future (with the helper constructor Future.delayed()) with zero duration and inside it use the Provider.of(context)
```dart
Future.delayed(Duration.zero).then(_){
  Provider.of<ClassOfTheProvider>(context).methodWeWantToCall()
}
```
<br> C) Use it inside didChangeDependencies(). This method runs multiple times, that's why we have to work with a flag variable when using this approach:

```dart
var _isInit = true;
@override
void didChangeDependencies() {
  if(_isInit){
    Provider.of<ClassOfTheProvider>(context).methodWeWantToCall()
  }
  _isInit = false;
}
```
- **RefreshIndicator**: widget to implement te tipical pattern of "pull to refresh". It takes a child (with the singleChildScrollView or whatever) and a pointer to a function (that should return a Future)

### HTTP Patch
http.patch is a request type supported by firebase that will tell the server to **merge the data which is incoming with the existing data** at that address. It takes two arguments: the url and the body (which will be the new data in json format). It will override the data that exists and will add the data that does not coincide. Normally we would implement it on a Future:

```dart
  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://url.firebasedatabase.app/products/$id.json';
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
```
### HTTP Delete
http.delete is a request type supported by firebase that will tell the server to **delete the data at that address**. We can do the operation in a Future or using the **optimistic updating** method. It consists on saving the old data in memory (in a variable), then try to update the db with the new values and finally to go back to the old data, saved in memory, in case it fails to update the db.

```dart
void deleteProduct(String id) {
    final url =
        'https://url.firebasedatabase.app/products/$id.json';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];    _items.removeAt(existingProductIndex);    http.delete(Uri.parse(url)).then((_) {
      existingProduct = null;
    }).catchError((error) {
            _items.insert(existingProductIndex, existingProduct);
    });
    notifyListeners();
  }
```

### Creating custom Exceptions
When we use the "implements" keyname followed by a ClassName, in the declaration of a class, we are signing a contract: **we compromise to implement all functions this class has**. In Dart, every class invisibly extends Object, **every class is an object**, and that's why every class has the method .toString()

### Managing errors in http requests
The HTTP package only throws its own errors for GET and POST requests if the server returns an error status code.
<br>For PATCH, PUT, DELETE, **it doesn't throw error** for error responses from server. So in theese cases a simple try-catch is not enought, we have to get the server response and compare the status code.

```dart
final response = await http.patch(
        Uri.parse(url),
        body: json.encode({'isFavorite': isFavorite}),
      );
      if (response.statusCode >= 400) {
        _setFavValue(oldValue);
      }
```
### FutureBuilder widget
It takes a Future and allow us to build different content depending on the temporal state of that Future. It takes two arguments:
- The future, a Future function the widget will take into account.
- The builder, an annonymous function that takes the context and a dataSnapshot of the Future (an object that contains the info of the state of the Future.) In this anonymous function we can access the dataSnapshot data and build widgets depending on that.

```dart
utureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (dataSnapshot.error != null) {
              return Center(
                child: Text('There was an error'),
              );
            } else {
              return Consumer<Orders>(
                builder: (ctx, orderData, child) => ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
                ),
              );
            }
          }
        },
      ),
```

## GitHub Actions