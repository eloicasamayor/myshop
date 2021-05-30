# myshop

Shopping app made with Flutter.

## Following the course

This project was made following the 5th and 6th lection in the Flutter Course in Udemy

### What I've learned
#### State Management
- **Inheritance** ("extens") and **Mixins** ("with")
- State Management: using the provider package
<br> - Building the providers using the within ChangeNotifier and getters to get the data. Using the notifyListeners() functions to alert listeners at any change in the data.
<br> - Stablishing the Provider in the highest widget in the widget tree where we will need that data using the ChangeNotifierProvider() or ChangeNotifierProvider.value() and referencing the Class.
<br> - On Children of the Provider widget we can listen the provider in two ways:
<br>    --- With Provider.of<ClassName>(context). We rebuild the entire widget on every change in the provider data. unless we add the "listen: false" argument.
<br>    --- With Consumer<ClassName>(builder: (ctx, data, child) => widget), child: child. Here we only rerun wha'ts inside the Consumer widget.
<br> - Multiple providers.
<br>
- We will use **StatefulWidget** when the state (the data) only affect that widget or maybe his child<br>
- We will use the **provider package** when the state affects all the app or multiple places around the widget tree.
<br>
<br>

#### User inputs and Forms
- Using the **Snackbar** widget and adding the opction to UNDO.
- Using the **Alert** widget and do something depending on the user response.
- Using **Forms** 
- --- Validation
- --- Saving the data
- --- Using the same form for creating and editing a product

#### HTTP Requests
- Creating a simple firebase realtime database
- **Async code**: one logic executes while other function is still running. Its convenient when we don't know how much time it will take or if it posibly result in an error. There are two ways of managing it on Flutter: Future + .then() + .catchError() or async + wait
<br> http.post() method returns a Future with the server response.
<br> Future in general, can return nothing. In that case,  we should accept an argument in the then() method anyway, even if we don't use it.
<br> All .then() returns a Future, so we can chain .then().then().then()... and they will run in order, as soon as they finish. So we can use .then() after http.post(). This will run when the server responds and we can handle that response on it. 
<br>In this case firebase returns as a response as a map with the random id { name: id }. We take it to save it in local memory as well.
<br>.catchError will run if there is an error in http.post() or in .then(). If there were an error in http.post(), it will no run the .then() so it will go directly to the .catchError()
<br>we can handle here the error, and we can throw it again with the "throw" key. Then, the place where we called addProduct(), who is waiting for the response of the Future, will receive the error with the  .catchError() (it would also catch the error if we wouldn't do the .catchError here). So, the error is only catched with the first .catchError in line.
<br>HTTP Request example using Future<>, .then() and .catchError()

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

- We cannot use .of(context) inside the initState() method. That's because here the widget is not fully loaded yet. There are 3 posible workarrounds:
- A) when using Provider.of<class>(context), it will work when we don't want to listen, like this: 
```dart
Provider.of<ClassOfTheProvider>(context, listen: false)
```
- B) Create a Future (with the helper constructor Future.delayed()) with zero duration and inside it use the Provider.of(context)
```dart
Future.delayed(Duration.zero).then(_){
  Provider.of<ClassOfTheProvider>(context).methodWeWantToCall()
}
```
- C) Use it inside didChangeDependencies(). This method runs multiple times, that's why we have to work with a flag variable when using this approach:
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

