import 'package:flutter/material.dart';
import '../shared/app_drawer.dart';
import 'user_product_list_tile.dart';
import 'products_manager.dart';
import 'package:provider/provider.dart';
import 'edit_product_screen.dart';


class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';
  const UserProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your products'),
        actions: <Widget>[
          AddUserProductButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                EditProductScreen.routeName,
              );
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: context.read<ProductsManager>().fetchUserProducts(),
        builder: (ctx, snapshot){
          if(snapshot.connectionState== ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return RefreshIndicator(
            onRefresh: ()=>
              context.read<ProductsManager>().fetchUserProducts(),
            child: const UserProductList(),
          );
        },
      ),
    );
  }
}

class UserProductList extends StatelessWidget {
  const UserProductList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductsManager>(
      builder: (ctx, productsManager, child) {
        return ListView.builder(
          itemCount: productsManager.itemCount,
          itemBuilder: (ctx, i) => Column(
            children: [
              UserProductListTile(
                productsManager.items[i],
              ),
              const Divider(),
            ],
          ),
        );
      },
    );
  }
}

class AddUserProductButton extends StatelessWidget {
  const AddUserProductButton({
    super.key,
    this.onPressed,
  });
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add),
      onPressed: onPressed,
    );
  }
}
