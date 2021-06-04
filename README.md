# myshop flutter app: learning to build flutter apps
Shopping app made with Flutter. This was done following a great [Flutter course in Udemy](https://www.udemy.com/course/learn-flutter-dart-to-build-ios-android-apps/)

## Deployment
You can see the web app deployed at [GitHub Pages](https://eloicasamayor.github.io/myshop/#/)

# Learning notes
>Here I have been writing down the concepts I learned in the course.
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

## Interfaces
When we use the "implements" keyname followed by a ClassName, in the declaration of a class, we are signing a contract: **we compromise to implement all functions this class has**. In Dart, every class invisibly extends Object, **every class is an object**, and that's why every class has the method .toString()


## State Management: using the provider package
- We will use **StatefulWidget** when the state (the data) only affect that widget or maybe his child<br>
- We will use the **provider package** when the state affects all the app or multiple places around the widget tree.
<br> - Building the providers using the within ChangeNotifier and getters to get the data. Using the notifyListeners() functions to alert listeners at any change in the data.
<br> - Stablishing the Provider in the highest widget in the widget tree where we will need that data using the ChangeNotifierProvider() or ChangeNotifierProvider.value() and referencing the Class.
<br> - On Children of the Provider widget we can listen the provider in two ways:

### A) The Provider.of<T>(context) method
With Provider.of<ClassName>(context). We rebuild the entire widget on every change in the provider data. unless we add the "listen: false" argument.

### B) The Consumer() widget 
With Consumer<ClassName>(builder: (ctx, data, child) => widget), child: child. Here we only rerun wha'ts inside the Consumer widget.
```dart
Consumer<Auth>(builder: (ctx, data, _) => MaterialApp(
  //This MaterialApp widget will rebuild on every change in the Auth() provider (as far as we call NotifyListeners inside Auth, when the change occurs)
  ),
),
```

### Multiple providers.
- We can define multiple providers using the MultiProvider.
- If we have a provider that depends on another provider, then we will use Change ChangeNotifierProxyProvider<>(). Between <> we have to pass the provider class that it depends on, and the class we want to provide. Then, there is a "create" argument with a function that must return the object we want to provide and an "update" provide, which will fulfill it using the info from the other provider it depends on.

```dart
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (ctx) => Products(null, []),
          update: (ctx, auth, previousProducts) => Products(
            auth.token,
            previousProducts == null ? [] : previousProducts.items,
          ),
          // inicializamos la lista de productos con los productos anteriores si los había, y si no con una lista vacía.
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Orders(),
        ),
      ],
```

## User inputs and Forms
- Using the **Snackbar** widget and adding the opction to UNDO.
- Using the **Alert** widget and do something depending on the user response.
- The **Form()** widget helps us with collecting user input and with validation as well, so we don't have to create a TextEditingController for every input and validate the inputs in custom functions. The Form widget itself is invisible, but inside it we can use special input widgets that can be validated and saved together in a simple way. It takes a child argument where you put the widget tree.
We have to asign another argument: the key, declared as:
```dart
final _form = GlobalKey<FormState>();
```

- TextFormField() can be used inside a Form and are directly connected to that parent form.
- **Saving the data**: globalKeyInstance.currentState.save() will trigger every "onSave" method in every TextFormField widget in the form. The function of the onSaved argument gets the value entered on the input.
```dart
void _saveForm(){
  _form.currentState.save();
}
```
- **Validating**: globalKeyInstance.currentState.validate() will trigger every "validator" method in every TextFormField in the form.
in every TextFormField in the form we can add a "validator:" argument. "validator" takes a function with takes a value (the value entered in the textFormField by the user) and returns something.
If it return null, it would be as "there is no error". It it returns a text, this text is treated as the error text = the message you want to show to the user.


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

We can create type of errors creating a class that use the interface Exception. To do that, we will define the class with the "class" keyname with the class name, and then the keyword "implements" and then the name of the Exception class.
```dart
class HttpException implements Exception {
  final String message;

  HttpException(this.message);

  @override
  String toString() {
    return message;
  }
}
```
We could filter an error of this custom type like this:
```dart
try {
  // some code that could fail
} on HttpException catch (error) {
  // we go here when an HttpException occurs
} catch (error){
  // we go here when other types of errors occur
}
```
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
## Dart operators
### Spread operator
Provide a concise way to insert multiple values into a collection.

```dart
var list = [1, 2, 3];
var list2 = [0, ...list];
assert(list2.length == 4);
```
### Cascade operator
Allow you to make a sequence of operations on the same object. In addition to function calls, you can also access fields on that same object. This often saves you the step of creating a temporary variable and allows you to write more fluid code.

```dart
final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
transformConfig.translate(-10.0);
// it is the same as:
Matrix4.rotationZrotationZ(-8 * pi / 180)..translate(-10.0);
```
### Null-aware operator
The ?? operator returns the expression on its left unless that expression’s value is nul

## Authentication
In flutter we use **Tokens** to admin the authentication of users. When a user logs in, a token is generated on the server with an algorithm and a private key only known by the server, so the token can't be faked. This token is a long string that is sent to the app and stored on de device. It is stored in the "hard drive", and that allow us to keep the token when the app restarts. In the server it's defined certain endpoints whereas the request must have a token attached, and it won't respond if it is the valid token.

## Timers
The timer counts down from the specified duration to 0. When the timer reaches 0, the timer invokes the specified callback function. For example, we can use it to count the time when the auth token expires and when it does, call a logout() function.

```dart
void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
```

## Saving data in device memory
We use the shared_preferences package to save simple data to the device memory. It can be use to save the auth token, userID and the token expiry date.

```dart
// saving some variables in the device memory
Future<void> _saveAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode({
      'token': _token,
      'userId': _userId,
      'expiryDate': _expiryDate.toIso8601String(),
    });
    prefs.setString('userData', userData);
}
// check if the auth token is valid
Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    } else {
      final extractedUserData = json.decode(prefs.getString('userData')) as Map<String, Object>;
      DateTime expiryDate = DateTime.parse(extractedUserData['expiryDate']);
      if (expiryDate.isBefore(DateTime.now())) {
        return false;
      }
      _token = extractedUserData['token'];
      _userId = extractedUserData['userId'];
      _expiryDate = expiryDate;
      return true;
    }
  }

// removing data
Future<void> _removeAuthData() async {
    //remove a specific data
    prefs.remove('userData');
    // remove all data
    prefs.clear();
}
```

## Animations
### First approach: controlling an animation from scratch
- We need to be in a **StatefulWidget** using the mixin **SingleTickerProviderStateMixin** (it will allow us to use the "this" keywork to configure vsync parameter in the controller)
- We create an **AnimationController** that we will use to start or revert the animation. It takes 2 arguments:
  - **vsync**: we have to provide "this". (it is provided by the SingleTickerProviderStateMixin mixin)
  - **duration**: we can provide 2 durations, for forward and reversed, or one for both. We have to provide a Duration() object.
- We set up an **Animation**. This is a generic type, so we have to add a <type> on the right to tell flutter what we want to animate. This object will have all the configurations of the animation.
  - We use an instance of the **Tween()** class, with provides an object that knows how to animate between 2 values. It's also a generic class, so we should provide what to animate. I takes 2 arguments:
    - **begin**: we provide the object to animate with the properties in the beginning
    - **end**: the object to animate with the properties in the ending of the animation 
  - We call **.animate()** to create the Animation object we have to provide. We will pass an
    - Animation Object, for example, the CurvedAnimation() constructor. We provide:
        - **parent**: a pointer to the controller
        - **curve**: we can choose between the properties of **Curves**: linear, easeIn, easeOut...
- Both objects have to be configured when the State object is created, so in the **initState()**.
- We have to add a Listener to listen for any changes on the Animation Object and **call setState()** every time it changes, so build() is called, so the screen is redrawed.

```dart
  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _heightAnimation = Tween<Size>(
      begin: Size(
        double.infinity,
        260,
      ),
      end: Size(
        double.infinity,
        320,
      ),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );
    // when it changes, it needs to call setState
    _heightAnimation.addListener(() => setState(() {}));
  }
```

- We connect the animation with the widget by assigning the animation to some parameter, for example the height.

```dart
height: _heightAnimation.value.height,
```
- To trigger the animation, we call **_controller.forward()** or **_controller.reverse()**.

### The AnimatedBuilder widget
- It allows us to rebuild only the part of the widget tree that we want to animate, not all the screen, so it's more efficient than call setState() for every animation frame. It takes some arguments:
  - animation: we provoide the animation created in the initState
  - builder: an annonymous function that
    - takes 2 arguments: context and child (this child won't be rebuilt)
    - returns a widget (or widget tree) that we want to animate
  - child: a widget tree that it will not be rebuilt.

```dart
AnimatedBuilder(
        animation: _heightAnimation,
        builder: (ctx, ch) => Container(
          height: _heightAnimation.value.height,
          child: ch,
        ),
        child: Form(
              //the widget tree that won't rebuild with the animation
            ),
          ),
```

### The AnimatedContainer widget
- AnimatedContainer has all the logic built in and it **automatically transitions between changes in its configuration**.
- So in any change in hight, width, padding... it will not make a hard switch between the old and the new value, but it will smoothly animate between them.
- We **don't need to create a Controller neither an Animation object**.
- We have to provide:
  - **duration**: a Duration() object
  - **curve**: Curves.easeIn, etc

```dart
AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
        height: _authMode == AuthMode.Signup ? 320 : 260,
        constraints: BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: //the widget tree inside the container
        ),
```

### Other Animation widgets
- **FadeTransition** allow us to animate the opacity of a widget. We have to provide an Animation<double> object to the opacity attribute.
```dart
FadeTransition(
                    opacity: _opacityAnimation,
                    child: //the childs will also fade
),
```
- **SlideTransition** allow us to animate the offset of a widget. We have to provide an Animation<Offset> object to the opacity attribute.