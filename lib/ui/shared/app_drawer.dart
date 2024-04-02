import 'package:ct484_project/ui/products/products_category_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../products/products_manager.dart';
import '../auth/auth_manager.dart';
import '../products/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key});

  @override
  Widget build(BuildContext context) {
    final productManager = Provider.of<ProductsManager>(context, listen: false);

    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: const Text('Xin chào !!'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.library_books),
            title: const Text('Tất cả sách'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          const Divider(),
          FutureBuilder<List<String>>(
            future: productManager.getCategories(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Trạng thái đang chờ
                return CircularProgressIndicator(); // Hiển thị biểu tượng loading
              } 
                // Trạng thái đã hoàn thành và có dữ liệu
                List<String> categories = snapshot.data ?? [];
                return ExpansionTile(
                  leading: const Icon(Icons.category),
                  title: const Text('Thể loại'),
                  trailing: const Icon(Icons.arrow_drop_down),
                  children: categories.map((category) {
                    return ListTile(
                      title: Text(category),
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          ProductsCategoryScreen.routeName,
                          arguments: category, // Truyền thể loại được chọn dưới dạng tham số
                        );
                      },
                    );
                  }).toList(),
                );
              }
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Quản lý'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Đăng xuất'),
            onTap: () {
              Navigator.of(context)
                ..pop()
                ..pushReplacementNamed('/');
              context.read<AuthManager>().logout();
            },
          ),
        ],
      ),
    );
  }
}
