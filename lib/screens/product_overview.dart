import 'package:flutter/material.dart';
import '../widgets/product_item.dart';
import '../widgets/products_grid.dart';

 enum filter{
   favoriteOnly,
   showAll

 }
class ProductOverview extends StatefulWidget {
  @override
  _ProductOverviewState createState() => _ProductOverviewState();
}

class _ProductOverviewState extends State<ProductOverview> {
  @override
  var showFavorite = false;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (filter value){
              setState(() {
                if(value==filter.favoriteOnly){
                showFavorite = true;
              }
              else {showFavorite=false;}
              });
            },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                
                    PopupMenuItem(child: Text('Favorite only'), value: filter.favoriteOnly),
                    PopupMenuItem(child: Text('Show all'), value: filter.showAll),
                  ])
        ],
      ),
      body: ProductsGrid(showFavorite),
    );
  }
}
