import 'package:ct484_project/ui/shared/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'products_manager.dart';
import 'product_grid_tile.dart';
import '../../models/product.dart';
import 'product_detail_screen.dart';

class ProductSearchScreen extends StatefulWidget {
  static const routeName = '/product-search';

  @override
  _ProductSearchScreenState createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends State<ProductSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> _searchResults = [];
  bool _isDataLoaded = false; // Biến đánh dấu dữ liệu đã được tải xuống

  @override
  void initState() {
    super.initState();
    _searchResults = [];
    final _productsManager = Provider.of<ProductsManager>(context, listen: false);
    _productsManager.fetchProducts().then((_) {
      setState(() {
        _isDataLoaded = true; // Đặt biến là true khi dữ liệu đã được tải xuống
      });
    });
  }

  void _searchProducts(String keyword) {
    final products = Provider.of<ProductsManager>(context, listen: false).items;
    final searchResults = products.where((product) =>
        product.title.toLowerCase().contains(keyword.toLowerCase())).toList();

    setState(() {
      _searchResults = searchResults;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Tìm kiếm...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white),
          ),
          style: TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          autofocus: true,
          textInputAction: TextInputAction.search,
          onChanged: _searchProducts,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.cancel),
            onPressed: () {
              _searchController.clear();
              setState(() {
                _searchResults = [];
              });
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: _isDataLoaded
          ? SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  if (_searchResults.isNotEmpty)
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Kết quả tìm kiếm',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3 / 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: _searchResults.length,
                    itemBuilder: (ctx, index) {
                      return ProductGridTile(_searchResults[index]);
                    },
                  ),
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(), // Hiển thị indicator khi đang tải
            ),
    );
  }
}
