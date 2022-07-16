import 'package:flutter/material.dart';
import '../Widgets/product_grid.dart';

class ProductOveriewScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop app'),
      ),
      body: ProductGrid(),
    );
  }
}
