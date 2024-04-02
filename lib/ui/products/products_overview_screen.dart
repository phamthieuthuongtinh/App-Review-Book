import 'package:ct484_project/ui/products/products_search_screen.dart';
import 'package:flutter/material.dart';
import 'package:ct484_project/ui/products/products_manager.dart';
import '../shared/app_drawer.dart';
import 'products_grid.dart';
import 'package:provider/provider.dart';
// import 'products_manager.dart';

enum FilterOptions { favorites, all }

class ProductsOverviewScreen extends StatefulWidget {
  static const routeName = '/product-overview';
  const ProductsOverviewScreen({super.key});

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  final _showOnlyFavorites = ValueNotifier<bool>(false);
  String _searchKeyword = '';
  late Future<void> _fetchProducts;
  @override
  void initState(){
    super.initState();
    _fetchProducts= context.read<ProductsManager>().fetchProducts();
  }
void _navigateToProductSearchScreen(BuildContext context) {
    Navigator.pushNamed(context, ProductSearchScreen.routeName);
  }

  Widget _buildSearchButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.search),
      onPressed: () {
        _navigateToProductSearchScreen(context);
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang chủ'),
        actions: <Widget>[
          _buildSearchButton(context),
          ProductFilterMenu(
            onFilterSelected: (filter) {
              if(filter==FilterOptions.favorites){
                _showOnlyFavorites.value= true;
              }else{
                _showOnlyFavorites.value=false;
              }
            },
          ),
           
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: _fetchProducts,
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            return ValueListenableBuilder<bool>(
              valueListenable:  _showOnlyFavorites,
              builder: (context, onlyFavorites,child){
                return ProductsGrid(onlyFavorites);
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class ProductFilterMenu extends StatelessWidget {
  const ProductFilterMenu({super.key, this.onFilterSelected});
  final void Function(FilterOptions selectedValue)? onFilterSelected;
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: onFilterSelected,
      icon: const Icon(
        Icons.more_vert,
      ),
      itemBuilder: (ctx) => [
        const PopupMenuItem(
          value: FilterOptions.favorites,
          child: Text('Yêu thích'),
        ),
        const PopupMenuItem(
          value: FilterOptions.all,
          child: Text('Tất cả'),
        ),
      ],
    );
  }
}

