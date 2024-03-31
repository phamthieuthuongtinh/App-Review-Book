import 'package:flutter/material.dart';
import 'product_detail_screen.dart';
import '../../models/product.dart';
import 'package:provider/provider.dart';
import 'products_manager.dart';

class ProductGridTile extends StatelessWidget {
  const ProductGridTile(
    this.product, {
    Key? key,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color.fromARGB(255, 9, 0, 0)), // Đặt màu và độ dày cho viền
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          footer: ProductGridFooter(
            product: product,
            onFavoritePressed: () {
              context.read<ProductsManager>().toggleFavoriteStatus(product);
              final isFavorite = product.isFavorite;
              final scaffold = ScaffoldMessenger.of(context);
              scaffold.hideCurrentSnackBar();
              scaffold.showSnackBar(
                SnackBar(
                  content: Text(
                    isFavorite ? 'Đã thêm yêu thích!' : 'Đã bỏ yêu thích!',
                  ),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      context
                          .read<ProductsManager>()
                          .toggleFavoriteStatus(product);
                    },
                  ),
                ),
              );
            },
          ),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                ProductDetailScreen.routeName,
                arguments: product.id,
              );
            },
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
              height: 250,
            ),
          ),
        ),
      ),
    );
  }
}

class ProductGridFooter extends StatelessWidget {
  const ProductGridFooter({
    Key? key,
    required this.product,
    this.onFavoritePressed,
    this.onAddToCartPressed,
  }) : super(key: key);

  final Product product;
  final void Function()? onFavoritePressed;
  final void Function()? onAddToCartPressed;

  @override
  Widget build(BuildContext context) {
    return GridTileBar(
      backgroundColor: Colors.black87,
      leading: ValueListenableBuilder<bool>(
        valueListenable: product.isFavoriteListenable,
        builder: (ctx, isFavorite, child) {
          return IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
            ),
            color: Theme.of(context).colorScheme.secondary,
            onPressed: onFavoritePressed,
          );
        },
      ),
      title: Text(
        product.title,
        textAlign: TextAlign.center,
      ),
    );
  }
}
