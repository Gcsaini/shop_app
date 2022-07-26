import 'package:flutter/material.dart';
import '../helpers/custom_route_transition.dart';
import './Screens/splash_screen.dart';
import './Providers/auth.dart';
import './Screens/auth_screen.dart';
import '../Screens/add_edit_product_screen.dart';
import '../Screens/user_product_screen.dart';
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
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => Products('', '', []),
          update: (ctx, auth, previousProducts) => Products(
              auth.token,
              auth.user_id,
              previousProducts != null ? previousProducts.items : []),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
            create: (_) => Orders('', '', []),
            update: (ctx, auth, previousOrder) => Orders(
                auth.token,
                auth.user_id,
                previousOrder != null ? previousOrder.orders : [])),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
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
            ),
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                TargetPlatform.android: CustomPageTransitionBuilder(),
                TargetPlatform.iOS: CustomPageTransitionBuilder(),
              },
            ),
          ),
          home: auth.isAuth
              ? ProductOveriewScreen()
              : FutureBuilder(
                  future: auth.autoLogin(),
                  builder: (ctx, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen()),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrderScreen.routeName: (ctx) => OrderScreen(),
            UserProductScreen.routeName: (ctx) => UserProductScreen(),
            AddEditProductScreen.routeName: (ctx) => AddEditProductScreen(),
          },
        ),
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
