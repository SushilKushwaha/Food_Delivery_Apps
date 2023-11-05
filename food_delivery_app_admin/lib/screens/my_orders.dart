import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app_admin/widgets/orders/boys_details.dart';
import 'package:food_delivery_app_admin/widgets/orders/customer_detials.dart';
import 'package:food_delivery_app_admin/widgets/orders/food_details.dart';
import 'package:food_delivery_app_admin/widgets/orders/payment_details.dart';
import 'package:food_delivery_app_admin/widgets/orders/restaurant_details.dart';

import 'package:food_delivery_app_admin/services/firebase_services.dart';

class MyOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  FirebaseServices _services = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(
          thickness: 5,
        ),
        StreamBuilder(
          stream: _services.orders.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                showBottomBorder: true,
                dataRowHeight: 60,
                headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
                //table headers
                columns: <DataColumn>[
                  DataColumn(
                    label: Text('OrderId'),
                  ),
                  DataColumn(
                    label: Text('Foods'),
                  ),
                  DataColumn(
                    label: Text('Restaurant/Hotel'),
                  ),
                  DataColumn(
                    label: Text('Customer'),
                  ),
                  DataColumn(
                    label: Text('Payment Type'),
                  ),
                  DataColumn(
                    label: Text('Price Details'),
                  ),
                  DataColumn(
                    label: Text('Order Time'),
                  ),
                  DataColumn(
                    label: Text('Order Status'),
                  ),
                  DataColumn(
                    label: Text('Delivery Boy'),
                  ),
                ],
                rows: _vendorDetailsRows(snapshot.data, _services),
              ),
            );
          },
        ),
      ],
    );
  }

  List<DataRow> _vendorDetailsRows(
    QuerySnapshot snapshot,
    FirebaseServices services,
  ) {
    List<DataRow> newList = snapshot.docs.map((DocumentSnapshot document) {
      List<dynamic> products = document.data()['products'];
      List<String> productNames =
          products.map((product) => product['productName'] as String).toList();

      String displayedNames = '';
      if (productNames.length <= 3) {
        displayedNames = productNames.join(', ');
      } else {
        displayedNames = productNames.sublist(0, 3).join(', ') + '...';
      }

      return DataRow(cells: [
        DataCell(
          Text(document.data()['orderId']),
        ),
        DataCell(
          Row(
            children: [
              IconButton(
                  icon: Icon(Icons.restaurant),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return FoodDetails(document.data()['orderId']);
                        });
                  }),
              Expanded(
                child: Text(displayedNames),
              ),
            ],
          ),
        ),
        DataCell(Row(
          children: [
            IconButton(
                icon: Icon(Icons.home_outlined),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return RestaurantDetails(document.data()['orderId']);
                      });
                }),
            Expanded(child: Text(document.data()['shopName'])),
          ],
        )),
        DataCell(Row(
          children: [
            IconButton(
                icon: Icon(Icons.person_outlined),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CustomerDetails(document.data()['orderId']);
                      });
                }),
            Expanded(child: Text(document.data()['userId'])),
          ],
        )),
        DataCell(Row(
          children: [
            IconButton(
                icon: Icon(Icons.payments_outlined),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return PaymentDetails(document.data()['orderId']);
                      });
                }),
            Expanded(child: Text('payment')),
          ],
        )),
        DataCell(Row(
          children: [
            IconButton(
                icon: Icon(Icons.attach_money_outlined),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return FoodDetails(document.data()['orderId']);
                      });
                }),
            Expanded(child: Text(document.data()['total'].toString())),
          ],
        )),
        DataCell(Row(
          children: [
            Icon(Icons.access_time_outlined),
            Expanded(child: Text(document.data()['timestamp'].toString())),
          ],
        )),
        DataCell(Row(
          children: [
            Expanded(child: Text(document.data()['orderStatus'])),
          ],
        )),
        DataCell(Row(
          children: [
            IconButton(
                icon: Icon(Icons.person_outline_outlined),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return BoysDetails(document.data()['orderId']);
                      });
                }),
            Expanded(child: Text(document.data()['deliveryBoy']['name'])),
          ],
        )),
      ]);
    }).toList();

    return newList;
  }
}
