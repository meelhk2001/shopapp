import 'package:flutter/material.dart';
import 'package:shopapp/providers/product.dart';
import 'screens/user_products_screen.dart';
import './providers/cart.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/product_overview.dart';
import './screens/product_detail.dart';
import './providers/products.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import './providers/orders.dart';
import 'screens/edit_product_screen.dart';
import 'screens/auth_screen.dart';
import 'providers/auth.dart';

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    if (kReleaseMode) exit(1);
  };

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: Auth()),
          ChangeNotifierProxyProvider<Auth, Products>(
              update: (context, auth, previousProducts) => Products(auth.token,
                  previousProducts == null ? [] : previousProducts.items)),
          ChangeNotifierProvider.value(
            value: Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            update: (context, auth, previousOrders) => Orders(auth.token,
                previousOrders == null ? [] : previousOrders.orders),
          ),
        ],
        child: Consumer<Auth>(
          builder: (context, auth, _) => MaterialApp(
              title: 'MyShop',
              theme: ThemeData(
                primarySwatch: Colors.purple,
                accentColor: Colors.deepOrange,
                fontFamily: 'Lato',
              ),
              home: auth.isAuth ? ProductOverview() : AuthScreen(),
              routes: {
                ProductDetails.routeName: (_) => ProductDetails(),
                CartScreen.routeName: (_) => CartScreen(),
                OrdersScreen.routeName: (_) => OrdersScreen(),
                UserProductsScreen.routeName: (_) => UserProductsScreen(),
                EditProductScreen.routeName: (_) => EditProductScreen(),
              }),
        ));
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProductOverview();
  }
}