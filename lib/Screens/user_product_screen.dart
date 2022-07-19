import 'package:flutter/material.dart';
import './add_edit_product_screen.dart';
import '../Widgets/app_drawer.dart';
import '../Widgets/user_product_item.dart';
import 'package:provider/provider.dart';
import '../Providers/products.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-product-screen';
  const UserProductScreen({Key key}) : super(key: key);

  Future<void> _fetchProducts(BuildContext context) async {
    await Provider.of<Products>(context).getProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manage Products',
          style: TextStyle(fontSize: 20),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AddEditProductScreen.routeName);
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _fetchProducts(context),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: ListView.builder(
            itemBuilder: (_, i) => Column(
              children: [
                UserProductItem(productData.items[i].id,
                    productData.items[i].title, productData.items[i].imageUrl),
                Divider(),
              ],
            ),
            itemCount: productData.items.length,
          ),
        ),
      ),
    );
  }
}
