import 'package:flutter/material.dart';
import '../providers/product.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';
class EditProductScreen extends StatefulWidget {
  static const String routeName = '/editproduct';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _focusPrice = FocusNode();
  final _focusDescripsion = FocusNode();
  var _imageUrlController = TextEditingController();
  final _focusImageUrl = FocusNode();
  var _form = GlobalKey<FormState>();
  var editedProduct =
      Product(id: null, title: '', price: 0, description: '', imageUrl: '');
  @override
  void initState() {
    _focusImageUrl.addListener(_focusChange);
    super.initState();
  }
  void dispose() {
    _focusImageUrl.removeListener(_focusChange);
    _imageUrlController.dispose();
    _focusPrice.dispose();
    _focusDescripsion.dispose();
    _focusImageUrl.dispose();
    super.dispose();
  }

  void _focusChange() {
     if (!_focusImageUrl.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    var validate = _form.currentState.validate();
    if (!validate) {
      return;
    }
    _form.currentState.save();
    Provider.of<Products>(context, listen: false).addProduct(editedProduct);
   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save), onPressed: _saveForm)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            key: _form,
            child: ListView(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Title'),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please provide the title';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_focusPrice);
                  },
                  onSaved: (value) {
                    editedProduct = Product(
                        id: null,
                        title: value,
                        description: '',
                        imageUrl: '',
                        price: 0.0);
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Price'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _focusPrice,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please provide the price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please provide valid price';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_focusDescripsion);
                  },
                  onSaved: (value) {
                    editedProduct = Product(
                        id: null,
                        title: editedProduct.title,
                        description: '',
                        imageUrl: '',
                        price: double.parse(value));
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Descripsion'),
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  focusNode: _focusDescripsion,
                  onFieldSubmitted: (_) {},
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please provide the Descripsion';
                    }
                    if (value.length < 10) {
                      return 'Too Short Descripsion';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    editedProduct = Product(
                        id: null,
                        title: editedProduct.title,
                        description: value,
                        imageUrl: '',
                        price: editedProduct.price);
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(
                        top: 8,
                        right: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        ),
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
                        controller: _imageUrlController,
                        focusNode: _focusImageUrl,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide the valid image url';
                          }
                          if ((!_imageUrlController.text.startsWith('http') &&
        !_imageUrlController.text.startsWith('https')) ||
        (!_imageUrlController.text.endsWith('png') &&
        !_imageUrlController.text.endsWith('jpg') &&
        !_imageUrlController.text
            .endsWith('jpeg'))){return 'Please type correct image url';}
                          return null;
                        },
                        onSaved: (value) {
                          editedProduct = Product(
                              id: null,
                              title: editedProduct.title,
                              description: editedProduct.description,
                              imageUrl: value,
                              price: editedProduct.price);
                        },
                        onFieldSubmitted: (_) {
                          _saveForm();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
