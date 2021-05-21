# myshop

Shopping app made with Flutter.

## Following the course

This project was made following the 5th lection in the Flutter Course in Udemy

A few resources to get you started if this is your first Flutter project:

### Contents
- Inheritance ("extens") and Mixins ("with")
- State Management -> the provider package
<br> > Building the providers using the within ChangeNotifier and getters to get the data. Using the notifyListeners() functions to alert listeners at any change in the data.
<br> > Stablishing the Provider in the highest widget in the widget tree where we will need that data using the ChangeNotifierProvider() or ChangeNotifierProvider.value() and referencing the Class.
<br> > On Children of the Provider widget we can listen the provider in two ways:
<br>    -> With Provider.of<ClassName>(context). We rebuild the entire widget on every change in the provider data. unless we add the "listen: false" argument.
<br>    -> With Consumer<ClassName>(builder: (ctx, data, child) => widget), child: child. Here we only rerun wha'ts inside the Consumer widget.
<br> > Multiple providers.
<br>
- We will use StatefulWidget when the state (the data) only affect that widget or maybe his child
- We will use the provider package when the state affects all the app or multiple places around the widget tree.

