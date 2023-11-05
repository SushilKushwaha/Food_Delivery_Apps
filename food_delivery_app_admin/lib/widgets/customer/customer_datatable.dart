import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app_admin/services/firebase_services.dart';
import 'package:food_delivery_app_admin/widgets/customer/customer_details.dart';

class CustomerDatable extends StatefulWidget {
  @override
  State<CustomerDatable> createState() => _CustomerDatableState();
}

class _CustomerDatableState extends State<CustomerDatable> {
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
            stream: _services.users.snapshots(),
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
                      label: Text('Customer ID'),
                    ),
                    DataColumn(
                      label: Text('Customer Name'),
                    ),
                    DataColumn(
                      label: Text('Customer Gender'),
                    ),
                    DataColumn(
                      label: Text('Customer Address'),
                    ),
                    DataColumn(
                      label: Text('Customer Mobile'),
                    ),
                    DataColumn(
                      label: Text('Customer Email'),
                    ),
                    DataColumn(
                      label: Text('Customer Details'),
                    ),
                  ],
                  rows: _customerDetailsRows(snapshot.data, _services),
                ),
              );
            }),
      ],
    );
  }

  List<DataRow> _customerDetailsRows(
      QuerySnapshot snapshot, FirebaseServices services) {
    List<DataRow> newList = snapshot.docs.map((DocumentSnapshot document) {
      final data = document.data();
      return DataRow(cells: [
        DataCell(
          Text(data['id'] ?? ''),
        ),
        DataCell(
          Row(
            children: [
              Text(data['firstName'] ?? ''),
              SizedBox(
                width: 5,
              ),
              Text(data['lastName'] ?? ''),
            ],
          ),
        ),
        DataCell(
          Text(data['gender'] ?? ''),
        ),
        DataCell(
          Text(data['address'] ?? ''),
        ),
        DataCell(
          Text(data['number'] ?? ''),
        ),
        DataCell(
          Text(data['email'] ?? ''),
        ),
        DataCell(IconButton(
          icon: Icon(Icons.info_outline),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CustomerDetails(data['id']);
                });
          },
        )),
      ]);
    }).toList();
    return newList;
  }
}
