import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavrioute;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.imageUrl,
      @required this.price,
      this.isFavrioute = false});

  void _setFavValue(bool newValue) {
    isFavrioute = newValue;
    notifyListeners();
  }

  void toggleFavrioute() async {
    final oldStatus = isFavrioute;
    isFavrioute = !isFavrioute;
    notifyListeners();
    var url = Uri.parse(
        'https://flutter-app-b12b6-default-rtdb.firebaseio.com/products/$id.json');
    try {
      final response = await http.patch(url,
          body: json.encode({
            'isFavrioute': isFavrioute,
          }));
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
}
