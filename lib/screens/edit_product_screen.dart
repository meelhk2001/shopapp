import 'package:flutter/material.dart';

class EditProductScreen extends StatefulWidget {
  static const String routeName = '/editproduct';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _focusPrice = FocusNode();
  final _focusDescripsion = FocusNode();
  @override
  void dispose() {
    _focusPrice.dispose();
    _focusDescripsion.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            child: ListView(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Title'),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_focusPrice);
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Price'),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              focusNode: _focusPrice,
              onFieldSubmitted: (_){
                FocusScope.of(context).requestFocus(_focusDescripsion);
              },
              
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Descripsion'),
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              focusNode: _focusDescripsion,
              onFieldSubmitted: (_) {},
            ),
          ],
        )),
      ),
    );
  }
}
