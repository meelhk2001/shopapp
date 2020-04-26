import 'package:flutter/material.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';

class ProductDetails extends StatelessWidget {
  static const routeName = '/product_detail';
  @override
  Widget build(BuildContext context) {

    final id = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(id);
    return Scaffold(
      appBar: AppBar(title: Text(loadedProduct.title)),
    );
  }
}
