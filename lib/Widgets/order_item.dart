import 'package:flutter/material.dart';
import '../Providers/orders.dart' as ord;
import 'package:intl/intl.dart';
import 'dart:math';

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;
  const OrderItem(this.order, {Key key}) : super(key: key);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(children: [
        ListTile(
          title: Text('\$${widget.order.amount}'),
          subtitle: Text(
            DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime),
          ),
          trailing: IconButton(
            onPressed: () {
              setState(() {
                _expanded = !_expanded;
              });
            }, 
            icon: Icon(_expanded ? Icons.expand_less: Icons.expand_more),),
        ),
        if(_expanded)
        Container(
          padding: EdgeInsets.symmetric(vertical: 5,horizontal: 14),
          height: min(widget.order.products.length*20.0+10, 180),
          child: ListView(
            children: widget.order.products.map((prod) =>
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(prod.title,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                Text('\₹${prod.price}',style: TextStyle(fontSize: 18,color: Colors.grey),)
              ],
            ),).toList(),
          ),
        ),
      ]),
    );
  }
}
