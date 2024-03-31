import 'package:flutter/material.dart';
import 'package:ct484_project/ui/products/products_manager.dart';
import '../shared/app_drawer.dart';
import 'products_grid.dart';
import 'top_right_badge.dart';
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
  late Future<void> _fetchProducts;
  @override
  void initState(){
    super.initState();
    _fetchProducts= context.read<ProductsManager>().fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: <Widget>[
          ProductFilterMenu(
            onFilterSelected: (filter) {
              if(filter==FilterOptions.favorites){
                _showOnlyFavorites.value= true;
              }else{
                _showOnlyFavorites.value=false;
              }
            },
          ),
          // ShoppingCartButton(
          //   onPressed: () {
          //     Navigator.of(context).pushNamed(CartScreen.routeName);
          //   },
          // ),
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
          child: Text('Only Favorites'),
        ),
        const PopupMenuItem(
          value: FilterOptions.all,
          child: Text('Show all'),
        ),
      ],
    );
  }
}

// class ShoppingCartButton extends StatelessWidget {
//   const ShoppingCartButton({super.key, this.onPressed});
//   final void Function()? onPressed;

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<CartManager>(
//       builder: (ctx, cartManager, child) {
//         return TopRightBadge(
//           data: cartManager.productCount,
//           child: IconButton(
//             icon: const Icon(
//               Icons.shopping_cart,
//             ),
//             onPressed: onPressed,
//           ),
//         );
//       },
//     );
//   }
// }
