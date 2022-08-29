import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart' show Orders;
import '../providers/products_provider.dart';
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future _ordersFuture;

  Future _obtainOrdersFuture(){
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState(){
    _ordersFuture = _obtainOrdersFuture();
    super.initState();
  }

  Future<void> _refreshOrders(BuildContext context) async {
    Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _ordersFuture,
        builder: (ctx, dataSnapShot) {
          if (dataSnapShot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapShot.error != null) {
              return Center(child: Text('An Error Occurred'));
            } else {
              return RefreshIndicator(
                  onRefresh: () => _refreshOrders(context),
                  child: Consumer<Orders>(builder: (ctx, orderData, child) =>
                      ListView.builder(
                        itemCount: orderData.orders.length,
                        itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
                      ),)
              );
            }
          }
        },
      ),
    );
  }
}
