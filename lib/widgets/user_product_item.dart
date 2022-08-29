import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/edit_product_screen.dart';
import '../providers/products_provider.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageurl;

  UserProductItem(this.id, this.title, this.imageurl);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageurl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
              icon: Icon(Icons.edit),
              color: Colors.black54,
            ),
            IconButton(
              onPressed: () async {
                try {
                  await Provider.of<productsProviders>(context, listen: false)
                      .deleteProduct(id);
                } catch (error) {
                  scaffold.showSnackBar(
                      SnackBar(content: Text('Deleting Failed!',textAlign: TextAlign.center,)));
                }
              },
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
