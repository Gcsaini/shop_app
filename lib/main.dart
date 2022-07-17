import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/Screens/user_product_screen.dart';
import './Screens/order_screen.dart';
import './Screens/cart_screen.dart';
import '../Providers/cart.dart';
import 'package:provider/provider.dart';
import './Screens/product_detail_screen.dart';
import './Screens/product_overview_screen.dart';
import 'Providers/products.dart';
import 'Providers/orders.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx)=>Products(),
        ),
         ChangeNotifierProvider(
          create: (ctx)=>Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx)=>Orders(),
        ),
      ],
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: const TextTheme(
              headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
              headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
              bodyText1: TextStyle(
                fontSize: 18.0,
              ),
              bodyText2: TextStyle(fontSize: 14.0),
            )),
        home: ProductOveriewScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartScreen.routeName:(ctx)=>CartScreen(),
          OrderScreen.routeName:(ctx)=>OrderScreen(),
          UserProductScreen.routeName:(ctx)=>UserProductScreen(),
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
      ),
      body: Center(
        child: Text('Let\'s build a shop!'),
      ),
    );
  }
}
