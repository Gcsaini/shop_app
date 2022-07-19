import 'package:flutter/material.dart';
import './cart_screen.dart';
import '../Widgets/product_grid.dart';
import 'package:provider/provider.dart';
import '../Widgets/badge.dart';
import '../Providers/cart.dart';
import '../Widgets/app_drawer.dart';
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
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<Products>(context).getProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My shop',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              color: Colors.red,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
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
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(_showFavriouteOnly),
    );
  }
}
