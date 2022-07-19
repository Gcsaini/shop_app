import 'package:flutter/material.dart';
import '../Screens/add_edit_product_screen.dart';
import 'package:provider/provider.dart';
import '../Providers/products.dart';

class UserProductItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String id;
  const UserProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      title: Text(title),
      trailing: Container(
        width: 100,
        child: Row(children: [
          IconButton(
            icon: Icon(Icons.edit),
            color: Theme.of(context).primaryColor,
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(AddEditProductScreen.routeName, arguments: id);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            color: Theme.of(context).errorColor,
            onPressed: () async {
              try {
                await Provider.of<Products>(context, listen: false)
                    .deleteProduct(id);
              } catch (error) {
                scaffold.hideCurrentSnackBar();
                scaffold.showSnackBar(SnackBar(
                    content: Text(
                  'Failed deleting',
                  textAlign: TextAlign.center,
                )));
              }
            },
          ),
        ]),
      ),
    );
  }
}
