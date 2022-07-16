import 'package:flutter/material.dart';
import '../Providers/products.dart';
import 'package:provider/provider.dart';
import '../Widgets/product_item.dart';

class ProductGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prodcutsData = Provider.of<Products>(context);
    final products = prodcutsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 3 / 2,
      ),
      itemBuilder: (ctx, i) =>ChangeNotifierProvider.value(
        value: products[i],
        child:ProductItem(
          // products[i].id, 
          // products[i].title, 
          // products[i].imageUrl
        ),
      )
    );
  }
}
