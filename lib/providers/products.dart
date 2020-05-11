import 'dart:convert';
import 'package:flutter/material.dart';
import 'product.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class Products with ChangeNotifier {
  String authToken;
  String userId;
  List<Product> _item = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  Products(this.authToken, this.userId, this._item);
  List<Product> get items {
    return [..._item];
  }

  Future<void> fetchAndSetProducts([bool filters=false]) async {
    String filter = filters ? '&orderBy="createrId"&equalTo="$userId"' : '';
    try {
      var url =
          'https://shop-app-meelhk.firebaseio.com/products.json?auth=$authToken$filter';
      var response = await http.get(url);
      var extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      url =
          'https://shop-app-meelhk.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);
      List<Product> loadedProduct = [];
      extractedData.forEach((id, pdtData) {
        loadedProduct.add(Product(
            id: id,
            description: pdtData["description"],
            imageUrl: pdtData["imageUrl"],
            price: pdtData["price"],
            title: pdtData["title"],
            isFavorite:
                favoriteData == null ? false : favoriteData[id] ?? false));
        _item = loadedProduct;
        notifyListeners();
      });
    } catch (error) {
      throw error;
    }
  }

  Product findById(String id) {
    return _item.firstWhere((pdt) => pdt.id == id);
  }

  List<Product> get fav {
    return _item.where((pdt) => pdt.isFavorite).toList();
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _item.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://shop-app-meelhk.firebaseio.com/products/$id.json?auth=$authToken';
      try {
        await http.patch(url,
            body: json.encode({
              'title': newProduct.title,
              'price': newProduct.price,
              'description': newProduct.description,
              'imageUrl': newProduct.imageUrl,
            }));
      } catch (error) {
        throw error;
      }
      _item[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  void deleteProduct(String id) async {
    final index =
        _item.indexWhere((exiestingProduct) => exiestingProduct.id == id);
    var existingProduct = _item[index];
    _item.removeAt(index);
    notifyListeners();
    final url =
        'https://shop-app-meelhk.firebaseio.com/products/$id.json?auth=$authToken';
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _item.insert(index, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://shop-app-meelhk.firebaseio.com/products.json?auth=$authToken';
    try {
      var response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'price': product.price,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'isFavorite': false,
            'createrId': userId
          }));
      var newProduct = Product(
          id: json.decode(response.body)["name"],
          title: product.title,
          description: product.description,
          imageUrl: product.imageUrl,
          price: product.price);
      _item.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
