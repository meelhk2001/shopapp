import 'package:flutter/material.dart';
import '../screens/product_detail.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/cart.dart';

class ProductItem extends StatelessWidget {
  void productDetails(BuildContext ctx, String id) {
    Navigator.of(ctx).pushNamed(ProductDetails.routeName, arguments: id);
  }
  @override
  Widget build(BuildContext context) {
    final pdt = Provider.of<Product>(context,listen: false);
    final cart = Provider.of<Cart>(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () => productDetails(context, pdt.id),
                  child: Image.network(
            pdt.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(
            pdt.title,
            textAlign: TextAlign.center,
          ),
          leading: Consumer<Product>(
                      builder: (context,pdt, child) => IconButton(
              icon: Icon( pdt.isFavorite ?
                Icons.favorite : Icons.favorite_border,
              ),
              color: Theme.of(context).accentColor,
              onPressed: pdt.setFavorite,
            ),
          ),
          trailing: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              color: Theme.of(context).accentColor,
              onPressed: ()=>cart.addItem(pdt.id, pdt.price, pdt.title),)
        ),
      ),
    );
  }
}