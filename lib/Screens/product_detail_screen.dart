import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail-screen';
  const ProductDetailScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final filteredProduct =
        Provider.of<Products>(context, listen: false).findById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(filteredProduct.title, style: TextStyle(fontSize: 16)),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            height: 250,
            width: double.infinity,
            child: Image.network(
              filteredProduct.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            '\₹${filteredProduct.price}',
            style: TextStyle(
              fontSize: 18,
              color: Colors.blueGrey,
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            child: Text(
              filteredProduct.description,
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          )
        ],
      )),
    );
  }
}
