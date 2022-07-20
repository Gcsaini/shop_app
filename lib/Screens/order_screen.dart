import 'package:flutter/material.dart';
import '../Providers/orders.dart' show Orders;
import 'package:provider/provider.dart';
import '../Widgets/order_item.dart';
import '../Widgets/app_drawer.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = 'order-screen';

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Future _ordersFuture;

  Future _getOrders() {
    return _ordersFuture =
        Provider.of<Orders>(context, listen: false).getOrders();
  }

  @override
  void initState() {
    _ordersFuture = _getOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Order'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: _ordersFuture,
          builder: ((ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.error != null) {
                return Center(
                  child: Text('some error'),
                );
              } else {
                return Consumer<Orders>(
                  builder: (ctx, orderData, child) => ListView.builder(
                    itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
                    itemCount: orderData.orders.length,
                  ),
                );
              }
            }
          }),
        ));
  }
}
