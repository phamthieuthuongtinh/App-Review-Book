import 'package:ct484_project/ui/products/product_grid_tile.dart';
import 'package:ct484_project/ui/shared/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:ct484_project/ui/products/products_search_screen.dart';
import 'package:ct484_project/ui/products/products_manager.dart';
import 'package:ct484_project/models/product.dart';
import 'package:provider/provider.dart'; // Import Product model

class ProductsCategoryScreen extends StatefulWidget {
  static const routeName = '/products-category';

  final String category;

  ProductsCategoryScreen({required this.category});

  @override
  _ProductsCategoryScreenState createState() => _ProductsCategoryScreenState();
}

class _ProductsCategoryScreenState extends State<ProductsCategoryScreen> {
  late Future<List<Product>> _futureProducts; // Change the type to List<Product>

  @override
  void initState() {
    super.initState();
    _futureProducts = _fetchProductsByCategory(widget.category);
  }

  Future<List<Product>> _fetchProductsByCategory(String category) async {
    final productsManager = Provider.of<ProductsManager>(context, listen: false);
    final List<Product> products = await productsManager.fetchProductsByCategory(category); 
    return products;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.category}'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.of(context).pushNamed(ProductSearchScreen.routeName);
            },
          ),
        ],
      ),
       drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 16.0), // Khoảng trắng giữa AppBar và sản phẩm
            FutureBuilder<List<Product>>(
              future: _futureProducts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  final List<Product> products = snapshot.data ?? [];
                  return GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3 / 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final Product product = products[index];
                      return ProductGridTile(product);
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
