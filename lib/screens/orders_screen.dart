import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import 'package:provider/provider.dart';

import '../widgets/order_item.dart';
import '../providers/orders.dart' show Orders;

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {

    Future<void> _refreshProducts(BuildContext context) async {
      await Provider.of<Orders>(context).fetchAndSetOrders();
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
          onRefresh: () => _refreshProducts(context),
          child: FutureBuilder(
            future:
                Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
            builder: (ctx, dataSnapShot) {
              if (dataSnapShot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (dataSnapShot.error != null) {
                  // Do error handling stuff
                  return Center(
                    child: Text('An error occured'),
                  );
                } else {
                  return Consumer<Orders>(
                      builder: (ctx, orderData, child) => ListView.builder(
                            itemCount: orderData.orders.length,
                            itemBuilder: (ctx, i) => OrderItem(
                              orderData.orders[i],
                            ),
                          ));
                }
              }
            },
          )),
    );
  }
}
