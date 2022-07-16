import 'package:flutter/material.dart';
import '../Widgets/product_grid.dart';
import 'package:provider/provider.dart';
import '../Providers/products.dart';

enum filterOptions {
  Favrioute,
  All,
}

class ProductOveriewScreen extends StatefulWidget {
  @override
  State<ProductOveriewScreen> createState() => _ProductOveriewScreenState();
}

class _ProductOveriewScreenState extends State<ProductOveriewScreen> {
  var _showFavriouteOnly = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop app'),
        actions: [
          PopupMenuButton(
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Show favrioute only'),
                value: filterOptions.Favrioute,
              ),
              PopupMenuItem(
                child: Text('Show all'),
                value: filterOptions.All,
              )
            ],
            icon: Icon(Icons.more_vert),
            onSelected: (filterOptions selectedValue) {
              setState(() {
                if (selectedValue == filterOptions.Favrioute) { 
                _showFavriouteOnly = true;
              } else {
                _showFavriouteOnly = false;
              }
              });
            },
          ),
        ],
      ),
      body: ProductGrid(_showFavriouteOnly),
    );
  }
}
