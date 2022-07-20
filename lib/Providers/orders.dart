import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../Providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> getOrders() async {
    var url = Uri.parse(
        'https://flutter-app-b12b6-default-rtdb.firebaseio.com/orders.json');
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extraxtedData = json.decode(response.body) as Map<String, dynamic>;
    if (extraxtedData == null) {
      return;
    }
    extraxtedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['date-time']),
          products: (orderData['products'] as List<dynamic>)
              .map(
                (item) => CartItem(
                    id: item['id'],
                    title: item['title'],
                    price: item['price'],
                    quantity: item['quantity']),
              )
              .toList(),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  void addOrder(List<CartItem> cartProducts, double total) async {
    var url = Uri.parse(
        'https://flutter-app-b12b6-default-rtdb.firebaseio.com/orders.json');
    final timestamp = DateTime.now();
    try {
      final response = await http.post(url,
          body: json.encode({
            'amount': total,
            'date-time': timestamp.toIso8601String(),
            'products': cartProducts
                .map((cp) => {
                      'id': cp.id,
                      'title': cp.title,
                      'quantity': cp.quantity,
                      'price': cp.price,
                    })
                .toList(),
          }));
      _orders.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['time'],
            amount: total,
            products: cartProducts,
            dateTime: timestamp),
      );
      notifyListeners();
    } catch (error) {}
  }

  void removeItem(String productId) {
    _orders.remove(productId);
    notifyListeners();
  }

  void clear() {
    _orders = {} as List<OrderItem>;
    notifyListeners();
  }
}
