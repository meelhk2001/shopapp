import 'package:flutter/material.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/widgets/badge.dart';
import '../widgets/products_grid.dart';
import 'package:provider/provider.dart';
import 'cart_screen.dart';
import '../widgets/app_drawer.dart';
import '../providers/products.dart';
enum filter { favoriteOnly, showAll, }

class ProductOverview extends StatefulWidget {
  @override
  _ProductOverviewState createState() => _ProductOverviewState();
}

class _ProductOverviewState extends State<ProductOverview> {
  @override
  var _isInit = true;
  var _isLoading = false;
  void didChangeDependencies() {
    if(_isInit){
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_){
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }
  @override
  var _showFavorite = false;
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('My Shop'),
        actions: <Widget>[
          Badge(
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
              ),
              value: cart.itemCount),
          PopupMenuButton(
              onSelected: (filter value) {
                setState(() {
                  if (value == filter.favoriteOnly) {
                    _showFavorite = true;
                  } else {
                    _showFavorite = false;
                  }
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    PopupMenuItem(
                        child: Text('Favorite only'),
                        value: filter.favoriteOnly),
                    PopupMenuItem(
                        child: Text('Show all'), value: filter.showAll),
                  ])
        ],
      ),
      body: _isLoading ? Center(child: CircularProgressIndicator(),) : ProductsGrid(_showFavorite),
    );
  }
}
