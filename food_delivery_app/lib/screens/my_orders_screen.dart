import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/providers/order_provider.dart';
import 'package:food_delivery_app/services/order_services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MyOrders extends StatefulWidget {
  static const String id = 'my-orders';

  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  OrderServices _orderServices = OrderServices();
  User user = FirebaseAuth.instance.currentUser;

  int tag = 0;
  List<String> options = [
    'All Orders',
    'Ordered',
    'Accepted',
    'Picked Up',
    'On the way',
    'Delivered',
  ];

  String formatTimestamp(String timestamp) {
    // Convert timestamp string to DateTime
    DateTime dateTime = DateTime.parse(timestamp);

    // Define the date and time format you desire
    DateFormat dateFormat = DateFormat('yyyy MMMM dd');
    DateFormat timeFormat = DateFormat('hh:mm a');

    // Format the date and time using the defined format
    String formattedDate = dateFormat.format(dateTime);
    String formattedTime = timeFormat.format(dateTime);

    // Return the formatted date and time string
    return '$formattedDate, $formattedTime';
  }

  @override
  Widget build(BuildContext context) {
    var _orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          'My Orders',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              CupertinoIcons.search,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 56,
            width: MediaQuery.of(context).size.width,
            child: ChipsChoice<int>.single(
              choiceStyle: C2ChoiceStyle(
                  borderRadius: BorderRadius.all(Radius.circular(3))),
              value: tag,
              onChanged: (val) {
                if (val == 0) {
                  setState(() {
                    _orderProvider.status = null;
                  });
                }
                setState(() {
                  tag = val;
                  _orderProvider.status = options[val];
                });
              },
              choiceItems: C2Choice.listFrom<int, String>(
                source: options,
                value: (i, v) => i,
                label: (i, v) => v,
              ),
            ),
          ),
          Container(
            child: StreamBuilder<QuerySnapshot>(
              stream: _orderServices.orders
                  .where('userId', isEqualTo: user.uid)
                  .where('orderStatus',
                      isEqualTo: tag > 0 ? _orderProvider.status : null)
                  .orderBy('timestamp',
                      descending:
                          true) // Added orderBy for timestamp in ascending order
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.data.size == 0) {
                  return Center(
                      child: Text(tag > 0
                          ? 'No ${options[tag]} orders'
                          : 'No Orders. Continue Shopping'));
                }

                return Expanded(
                  child: ListView(
                    children:
                        snapshot.data.docs.map((DocumentSnapshot document) {
                      return Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            ListTile(
                              horizontalTitleGap: 0,
                              leading: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 14,
                                child: _orderServices.statusIcon(document),
                              ),
                              title: Text(
                                document.data()['orderStatus'],
                                style: TextStyle(
                                    fontSize: 12,
                                    color: _orderServices.statusColor(document),
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                '  On ${formatTimestamp(document.data()['timestamp'])}',
                                style: TextStyle(fontSize: 12),
                              ),
                              trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Payment Type : ${document.data()['cod'] == true ? 'Cash on delivery' : 'Paid Online'}',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Amount : \Rs. ${document.data()['total'].toStringAsFixed(0)}',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            //TODO: delivery boy thing
                            if (document.data()['deliveryBoy']['name'].length >
                                2)
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: ListTile(
                                  tileColor: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(.2),
                                  leading: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Image.network(
                                        document.data()['deliveryBoy']['image'],
                                        height: 24,
                                      )),
                                  title: Text(
                                    document.data()['deliveryBoy']['name'],
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  subtitle: Text(
                                    _orderServices.StatusComment(document),
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ),
                            ExpansionTile(
                              title: Text(
                                'Order Details',
                                style: TextStyle(
                                    fontSize: 10, color: Colors.black),
                              ),
                              subtitle: Text(
                                'View order details',
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: Image.network(
                                            document.data()['products'][index]
                                                ['productImage']),
                                      ),
                                      title: Text(
                                        document.data()['products'][index]
                                            ['productName'],
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      subtitle: Text(
                                        '${document.data()['products'][index]['qty']}'
                                        ' x \Rs. ${document.data()['products'][index]['price'].toStringAsFixed(0)} = \Rs. ${document.data()['products'][index]['total'].toStringAsFixed(0)}',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 12),
                                      ),
                                    );
                                  },
                                  itemCount: document.data()['products'].length,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12, right: 12, top: 8, bottom: 8),
                                  child: Card(
                                    elevation: 4,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Seller : ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12),
                                              ),
                                              Text(
                                                document.data()['shopName'],
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          if (int.parse(
                                                  document.data()['discount']) >
                                              0)
                                            Container(
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Discount : ',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 12),
                                                      ),
                                                      Text(
                                                        '\Rs. ${document.data()['discount']}',
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 12),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Discount Code : ',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 12),
                                                      ),
                                                      Text(
                                                        '\Rs. ${document.data()['discountCode']}',
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 12),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Delivery Fee : ',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12),
                                                    ),
                                                    Text(
                                                      '\Rs. ${document.data()['deliveryFee']}',
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Service charge : ',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12),
                                                    ),
                                                    Text(
                                                      '\Rs. ${document.data()['servicecharge']}',
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              height: 3,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}
