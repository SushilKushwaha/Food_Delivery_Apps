import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app_admin/services/firebase_services.dart';

class PaymentDetails extends StatefulWidget {
  final String orderId;

  PaymentDetails(this.orderId);

  @override
  State<PaymentDetails> createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<PaymentDetails> {
  FirebaseServices _services = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _services.orders
          .where('orderId', isEqualTo: widget.orderId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final documents = snapshot.data.docs;

        if (documents.isEmpty) {
          return Center(
            child: Text('Order not found'),
          );
        }

        final orderData = documents[0].data();
        final cod = orderData['cod'] as bool;

        return Builder(
          // Wrap Dialog with Builder
          builder: (context) {
            return Dialog(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        child: Container(
                          height: 100,
                          width: 250,
                          child: Column(
                            children: [
                              ListView(
                                shrinkWrap: true, // Add shrinkWrap property
                                physics:
                                    NeverScrollableScrollPhysics(), // Disable scrolling
                                children: [
                                  SizedBox(height: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Payment Type: ',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            cod ? 'Cash on Delivery' : 'Online',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
