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
            // ShoppingCartButton(
            //   onPressed: () {
            //     Navigator.of(context).pushNamed(CartScreen.routeName);
            //   },
            // ),
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
                  product.author,
                  style: const TextStyle(color: Colors.grey,fontSize:  20),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: Text(
                    product.description,
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  
                ),
                const SizedBox(height: 10),
                Container(
                  
                  child: Row(
                    children: [
                      SizedBox(width:20),
                      IconButton(
                        icon: const Icon(Icons.favorite_border),
                        iconSize: 25,
                        color: Colors.grey[400],
                        onPressed: (){
                          const snackBar=SnackBar(content: Text('Favorite pressed'));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      
                        },
                      ),
                      Text('Add favorite'),
                      SizedBox(width:20),
                      Text(
                        'Nhập số lượng:'
                      ),
                      SizedBox(width: 10),
                      Container(
                        width: 50,
                        height: 30, 
                        child: TextField(
                          controller: quantityController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: '0',
                            contentPadding: EdgeInsets.all(5),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                       SizedBox(width: 10),
                      //  IconButton(
                        
                      //   icon: const Icon(Icons.shopping_cart),
                      //   onPressed: (){
                      //      final cart = context.read<CartManager>();
                      //      int quantity = int.tryParse(quantityController.text) ?? 0;
                      //      cart.addItemWithQuantity(product,quantity);
                      //       ScaffoldMessenger.of(context)
                      //         ..hideCurrentSnackBar()
                      //         ..showSnackBar(
                      //           SnackBar(
                      //             content: const Text(
                      //               'Item added to cart',
                      //             ),
                      //             duration: const Duration(seconds: 2),
                      //             action: SnackBarAction(
                      //               label: 'UNDO',
                      //               onPressed: () {
                      //                 // Xóa product nếu undo
                      //                 cart.removeItem(product.id!);
                      //               },
                      //             ),
                      //           ),
                      //       );
                      
                      //     }, 
                      //   ),
                        
                    ],

                  ),
                  
                ),
                
            ],
          ),
        ),
      );
    }
}


class HomeButton extends StatelessWidget {
  const HomeButton({super.key,this.onPressed});
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context){
    return IconButton(
      icon: Icon(Icons.home),
      onPressed: onPressed,
      
    );
  }
}
