import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail-screen';
  const ProductDetailScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final filteredProduct = Provider.of<Products>(context,listen: false).findById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(filteredProduct.title),
      ),
    );
  }
}
