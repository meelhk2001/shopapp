import 'package:flutter/material.dart';
import '../widgets/cart_item.dart';
import '../providers/cart.dart' show Cart;
import 'package:provider/provider.dart';
import '../providers/orders.dart';

class CartScreen extends StatefulWidget {
  @override
  static const routeName = '/cart';
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Your Cart')),
      body: Column(children: <Widget>[
        Card(
            margin: EdgeInsets.all(15),
            child: Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Total'),
                    Spacer(),
                    Chip(
                      label: Text(
                        '\$${cart.totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                            color:
                                Theme.of(context).primaryTextTheme.title.color),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    FlatButton(
                      onPressed: () {
                        Provider.of<Orders>(context, listen: false).addOrder(
                          cart.items.values.toList(),
                          cart.totalPrice,
                        
                        );
                        cart.clear();
                      },
                      child: Text('Order Now'),
                      textColor: Theme.of(context).primaryColor,
                    )
                  ],
                ))),
        SizedBox(height: 15),
        Expanded(
            child: ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (context, i) => CartItem(
                      cart.items.values.toList()[i].id,
                      cart.items.keys.toList()[i],
                      cart.items.values.toList()[i].price,
                      cart.items.values.toList()[i].quantity,
                      cart.items.values.toList()[i].title,
                    )))
      ]),
    );
  }
}
