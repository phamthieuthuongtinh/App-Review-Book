import 'package:ct484_project/ui/products/products_search_screen.dart';
import 'package:flutter/material.dart';
// import 'package:ct484_project/ui/cart/cart_screen.dart';
import 'package:ct484_project/ui/products/top_right_badge.dart';
// import '../cart/cart_manager.dart';
import '../shared/app_drawer.dart';
import 'products_overview_screen.dart';
import '../../models/product.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';
  const ProductDetailScreen(
    this.product, {
    super.key,
  });
  final Product product;

  @override
  Widget build(BuildContext context) {
    final TextEditingController quantityController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search), // Thêm icon tìm kiếm
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
                  product.imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Tác giả: ${product.author}",
              style: const TextStyle(
                  color: Color.fromARGB(132, 37, 1, 73), fontSize: 20),
            ),
            const SizedBox(height: 10),
            Container(
              child: Row(
                children: [
                  SizedBox(width: 110),
                  SizedBox(width: 20),
                  IconButton(
                    icon: const Icon(Icons.favorite_border),
                    iconSize: 25,
                    color: Colors.grey[400],
                    onPressed: () {
                      const snackBar =
                          SnackBar(content: Text('Đã thêm yêu thích'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                "Giới thiệu:\n\n ${product.description}",
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
  const HomeButton({super.key, this.onPressed});
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.home),
      onPressed: onPressed,
    );
  }
}
