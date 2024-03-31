import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'ui/products/products_manager.dart';

import 'ui/products/product_detail_screen.dart';

import 'ui/products/products_overview_screen.dart';

import 'ui/products/user_products_screen.dart';
import 'ui/products/edit_product_screen.dart';

import 'package:provider/provider.dart';
import 'ui/screens.dart';

Future<void> main() async{
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: Color.fromARGB(255, 166, 23, 23),
      secondary: Colors.deepOrange,
      background: Colors.white,
      surfaceTint: Colors.grey[200],
    );
    final themeData = ThemeData(
      //Hieu ung chuyen trang
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CustomPageTransitionsBuilder(),
          TargetPlatform.iOS: CustomPageTransitionsBuilder(),
        },
      ),
      //Ket thuc hieu ung chuyen trang
      fontFamily: 'Lato',
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 4,
        shadowColor: colorScheme.shadow,
      ),
      dialogTheme: DialogTheme(
        titleTextStyle: TextStyle(
          color: colorScheme.onBackground,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: TextStyle(
          color: colorScheme.onBackground,
          fontSize: 20,
        ),
      ),
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context)=> AuthManager(),
        ),
         ChangeNotifierProxyProvider<AuthManager, ProductsManager>(
          create: (ctx) => ProductsManager(),
          update: (ctx, authManager, productsManager) {
          // Khi authManager có báo hiệu thay đổi thì đọc lại authToken
          // cho productManager
          productsManager!.authToken = authManager.authToken;
          return productsManager;
          },
        ),
      //  ChangeNotifierProxyProvider<AuthManager, CartManager>(
      //     create: (ctx) => CartManager(),
      //     update: (ctx, authManager, CartManager) {
      //     // Khi authManager có báo hiệu thay đổi thì đọc lại authToken
      //     // cho productManager
      //     CartManager!.authToken = authManager.authToken;
      //     return CartManager;
      //     },
      //   ),
        // ChangeNotifierProxyProvider<AuthManager, OrdersManager>(
        //   create: (ctx) => OrdersManager(),
        //   update: (ctx, authManager, OrdersManager) {
        //   // Khi authManager có báo hiệu thay đổi thì đọc lại authToken
        //   // cho productManager
        //   OrdersManager!.authToken = authManager.authToken;
        //   return OrdersManager;
        //   },
        // ),
      ],
      child: Consumer<AuthManager>(
        builder: (context, authManager, child) {
          return MaterialApp(
            title: 'Giới Thiệu Sách',
            debugShowCheckedModeBanner: false,
            theme: themeData,
            home: authManager.isAuth ?  const ProductsOverviewScreen() : FutureBuilder(
              future: authManager.tryAutoLogin(),
              builder: (ctx,snapshot){
                return snapshot.connectionState==ConnectionState.waiting 
                    ? const SafeArea(child:SplashScreen())  
                    : const SafeArea(child:AuthScreen());
              },
            ),
            routes: {
              // CartScreen.routeName: (ctx) => const SafeArea(
              //       child: CartScreen(),
              //     ),
              // OrdersScreen.routeName: (ctx) => const SafeArea(
              //       child: OrdersScreen(),
              //     ),
              UserProductsScreen.routeName: (ctx) => const SafeArea(
                    child: UserProductsScreen(),
                  ),
              ProductsOverviewScreen.routeName: (ctx) => const SafeArea(
                    child: ProductsOverviewScreen(),
                  ),
            },
            onGenerateRoute: (settings) {
              if (settings.name == ProductDetailScreen.routeName) {
                final productId = settings.arguments as String;
                return MaterialPageRoute(
                  builder: (ctx) {
                    return SafeArea(
                      child: ProductDetailScreen(
                        ctx.read<ProductsManager>().findById(productId)!,
                      ),
                    );
                  },
                );
              }
              if (settings.name == EditProductScreen.routeName) {
                final productId = settings.arguments as String?;
                return MaterialPageRoute(
                  builder: (ctx) {
                    return SafeArea(
                      child: EditProductScreen(
                        productId != null
                            ? ctx.read<ProductsManager>().findById(productId)
                            : null,
                      ),
                    );
                  },
                );
              }
              return null;
            },
          );
        }
      ),
    );
  }
}

//class hieu ung chuyen trang
class CustomPageTransitionsBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const begin = Offset(1.0, 0.0);
    const end = Offset.zero;
    const curve = Curves.easeInOutSine; // Chọn curve tùy ý
    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    var offsetAnimation = animation.drive(tween);

    return SlideTransition(
      position: offsetAnimation,
      child: child,
    );
  }
}
