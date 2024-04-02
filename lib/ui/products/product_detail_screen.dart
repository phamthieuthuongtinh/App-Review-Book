import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ct484_project/ui/products/products_manager.dart';
import 'package:ct484_project/ui/products/products_search_screen.dart';
import 'package:ct484_project/ui/products/top_right_badge.dart';
import '../shared/app_drawer.dart';
import 'products_overview_screen.dart';
import '../../models/product.dart';

class ProductDetailScreen extends StatefulWidget {
  static const routeName = '/product-detail';
  const ProductDetailScreen(
    this.product, {
    Key? key,
  }) : super(key: key);

  final Product product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    isFavorite = Provider.of<ProductsManager>(context, listen: false)
        .isFavorite(widget.product.id.toString());
  }

  void addToFavorites(BuildContext context) {
    final productsManager = Provider.of<ProductsManager>(context, listen: false);
    productsManager.toggleFavoriteStatus(widget.product); // Thay đổi trạng thái yêu thích
    setState(() {
      isFavorite = !isFavorite;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isFavorite ? 'Đã bỏ yêu thích!' : 'Đã thêm yêu thích!'),
        duration: Duration(seconds: 2),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            addToFavorites(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.of(context).pushNamed(ProductSearchScreen.routeName);
            },
          ),
          HomeButton(
            onPressed: () {
              Navigator.of(context).pushNamed(ProductsOverviewScreen.routeName);
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                height: 520,
                width: double.infinity,
                child: Image.network(
                  widget.product.imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Tác giả: ${widget.product.author}",
              style: const TextStyle(
                color: Color.fromARGB(132, 37, 1, 73),
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              child: Row(
                children: [
                  SizedBox(width: 110),
                  SizedBox(width: 20),
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                    ),
                    iconSize: 25,
                    color: isFavorite ? Colors.red : Colors.grey[400],
                    onPressed: () {
                      addToFavorites(context);
                    },
                  ),
                  Text('Thêm yêu thích'),
                  SizedBox(width: 10),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                "Giới thiệu:\n\n ${widget.product.description}",
                textAlign: TextAlign.left,
                softWrap: true,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class HomeButton extends StatelessWidget {
  const HomeButton({Key? key, this.onPressed}) : super(key: key);
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.home),
      onPressed: onPressed,
    );
  }
}
