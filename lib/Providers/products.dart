import 'package:flutter/material.dart';
import './product.dart';
import 'dart:convert';
import '../Models/http_exception.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  final String authToken;
  final String user_id;

  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  Products(
    this.authToken,
    this.user_id,
    this._items,
  );

  List<Product> get items {
    return [..._items];
  }

  List<Product> get showFavrioutes {
    return _items.where((item) => item.isFavrioute).toList();
  }

  Future<void> getProducts([bool filtrByUser = false]) async {
    final filterString =
        filtrByUser ? 'orderBy="user_id"&equalTo="$user_id"' : '';
    var url = Uri.parse(
        'https://flutter-app-b12b6-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString');
    try {
      final response = await http.get(url);
      final fetchedData = json.decode(response.body) as Map<String, dynamic>;
      if (fetchedData == null) {
        return;
      }
      url = Uri.parse(
          'https://flutter-app-b12b6-default-rtdb.firebaseio.com/userFavrioutes/$user_id.json?auth=$authToken');
      final favriouteResponse = await http.get(url);
      final favriouteData = json.decode(favriouteResponse.body);

      final List<Product> loadedPorducts = [];
      fetchedData.forEach((prodId, productData) {
        loadedPorducts.add(Product(
            id: prodId,
            title: productData['title'],
            description: productData['description'],
            imageUrl: productData['imageUrl'],
            isFavrioute:
                favriouteData == null ? false : favriouteData[prodId] ?? false,
            price: productData['price']));
      });
      _items = loadedPorducts;

      notifyListeners();
    } catch (error) {}
  }

  Future<void> addProduct(Product product) async {
    var url = Uri.parse(
        'https://flutter-app-b12b6-default-rtdb.firebaseio.com/products.json?auth=$authToken');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'user_id': user_id,
          'title': product.title,
          'price': product.price,
          'description': product.description,
          'imageUrl': product.imageUrl,
        }),
      );

      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          imageUrl: product.imageUrl,
          price: product.price);

      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  void updateProduct(String id, Product newProduct) async {
    final productIndex = _items.indexWhere((product) => product.id == id);
    if (productIndex >= 0) {
      var url = Uri.parse(
          'https://flutter-app-b12b6-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken');
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'price': newProduct.price,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
          }));
      _items[productIndex] = newProduct;
      notifyListeners();
    } else {
      print('....');
    }
  }

  Future<void> deleteProduct(String productId) async {
    _items.removeWhere((product) => product.id == productId);
    var url = Uri.parse(
        'https://flutter-app-b12b6-default-rtdb.firebaseio.com/products/$productId.json?auth=$authToken');
    //for rollback if not delete from local memory
    final existingProductIndex =
        _items.indexWhere((prod) => prod.id == productId);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Has an error');
    }
    existingProduct == null;
  }
}
