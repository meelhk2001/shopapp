import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;
  CartItem({this.id, this.title, this.quantity, this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};
  Map<String, CartItem> get items {
    return {..._items};
  }
 double get totalPrice{
    double total = 0;
    _items.forEach((key,ckt) =>
      total+= (ckt.price*ckt.quantity)
    );
    return total;
 }
 String get itemCount{
   return _items.length.toString();
 }
  void addItem(String id, double price, String title) {
    //print(_items[id].title);
    if (_items.containsKey(id)) {
      _items.update(
          id,
          (existing) => CartItem(
              id: existing.id,
              title: existing.title,
              price: existing.price,
              quantity: existing.quantity + 1));
    } else {
      _items.putIfAbsent(
          id,
          () => CartItem(
                id: DateTime.now().toString(),
                price: price,
                title: title,
                quantity: 1,
              ));
    }
    notifyListeners();
  
  }
  void removeItem(String id){
    _items.remove(id);
    notifyListeners();
  }
   void removeSingleItem(String id){
     if(!_items.containsKey(id)) {
       return;
     }
     if(_items[id].quantity>1)
     {
       _items.update(
          id,
          (existing) => CartItem(
              id: existing.id,
              title: existing.title,
              price: existing.price,
              quantity: existing.quantity - 1));
     }
     else{
       _items.remove(id);
     }
     notifyListeners();
   }
  void clear() {
    _items = {};
    notifyListeners();
  }
}
