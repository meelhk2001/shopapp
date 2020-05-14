import 'package:flutter/material.dart';
import '../screens/product_detail.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  void productDetails(BuildContext ctx, String id) {
    Navigator.of(ctx).pushNamed(ProductDetails.routeName, arguments: id);
  }

  @override
  Widget build(BuildContext context) {
    final pdt = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context);
    final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () => productDetails(context, pdt.id),
          child: Hero(
            tag: pdt.id,
                      child: FadeInImage(
                placeholder: AssetImage('assets/images/product-placeholder.png'),
                image: NetworkImage(pdt.imageUrl),
                fit: BoxFit.cover,
                ),
          ),
        ),
        footer: GridTileBar(
            backgroundColor: Colors.black87,
            title: Text(
              pdt.title,
              textAlign: TextAlign.center,
            ),
            leading: Consumer<Product>(
              builder: (cntx, pdt, child) => IconButton(
                  icon: Icon(
                    pdt.isFavorite ? Icons.favorite : Icons.favorite_border,
                  ),
                  color: Theme.of(cntx).accentColor,
                  onPressed: () {
                    pdt.setFavorite(authData.token, authData.userId);
                  }),
            ),
            trailing: IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                ),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  cart.addItem(pdt.id, pdt.price, pdt.title);
                  Scaffold.of(context).removeCurrentSnackBar();
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text('Item added to cart'),
                    action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {
                          cart.removeSingleItem(pdt.id);
                        }),
                  ));
                })),
      ),
    );
  }
}
