import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app_admin/services/firebase_services.dart';
import '../../constants.dart';

class FoodDetails extends StatefulWidget {
  final String orderId;

  FoodDetails(this.orderId);

  @override
  State<FoodDetails> createState() => _FoodDetailsState();
}

class _FoodDetailsState extends State<FoodDetails> {
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

        final products = orderData['products'];
        final totalPrice = orderData['total'];
        final serviceCharge = orderData['servicecharge'];
        final deliveryFee = orderData['deliveryFee'];

        int totalQuantity = 0;
        double totalSum = 0.0;
        List<Widget> productWidgets = [];

        for (var product in products) {
          final productId = product['productId'];
          final productName = product['productName'];
          final productImage = product['productImage'];
          final price = product['price'];
          final qty = product['qty'];
          final sku = product['sku'];

          final subtotal = price * qty;
          totalSum += subtotal;
          totalQuantity += qty;

          final productWidget = Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(
                      productImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Food ID: $productId',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Food Name: $productName',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Food SKU: $sku',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Food Qty: $qty',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Price: $price',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Subtotal: $subtotal',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          );

          productWidgets.add(productWidget);
        }

        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.width,
                width: MediaQuery.of(context).size.width * .3,
                child: Column(
                  children: [
                    ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: products.length,
                      separatorBuilder: (context, index) => Divider(
                        thickness: 1,
                        color: Colors.grey,
                      ),
                      itemBuilder: (context, index) {
                        return productWidgets[index];
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 450,
                      color: Colors.deepOrangeAccent,
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Qty: $totalQuantity',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Total Subtotal: $totalSum',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Service Charge: $serviceCharge',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Delivery Fee: $deliveryFee',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Total Price: $totalPrice',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
