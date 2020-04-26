import 'package:flutter/material.dart';
import 'package:shopapp/providers/cart.dart';
import './screens/product_overview.dart';
import './screens/product_detail.dart';
import './providers/products.dart';
import 'package:provider/provider.dart';
import './providers/cart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers:[
       ChangeNotifierProvider(
          create: (ctx) => Products()),
          ChangeNotifierProvider(
          create: (ctx) => Cart(),)
    ],
       
          child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: MyHomePage(),
        routes: {ProductDetails.routeName : (_) =>ProductDetails(),}
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProductOverview();
  }
}
