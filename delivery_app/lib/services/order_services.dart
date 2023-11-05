import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:flutter/material.dart';

import 'firebase_services.dart';

class OrderServices {
  FirebaseServices _services = FirebaseServices();

  Color statusColor(DocumentSnapshot document) {
    if (document.data()['orderStatus'] == 'Accepted') {
      return Colors.blueGrey[400];
    }
    if (document.data()['orderStatus'] == 'Rejected') {
      return Colors.red;
    }
    if (document.data()['orderStatus'] == 'Picked Up') {
      return Colors.pink[900];
    }
    if (document.data()['orderStatus'] == 'On the way') {
      return Colors.purple[900];
    }
    if (document.data()['orderStatus'] == 'Delivered') {
      return Colors.green;
    }
    return Colors.orange;
  }

  Icon statusIcon(document) {
    if (document.data()['orderStatus'] == 'Accepted') {
      return Icon(
        Icons.assignment_turned_in_outlined,
        color: statusColor(document),
      );
    }
    if (document.data()['orderStatus'] == 'Picked Up') {
      return Icon(
        Icons.cases,
        color: statusColor(document),
      );
    }
    if (document.data()['orderStatus'] == 'On the way') {
      return Icon(
        Icons.delivery_dining,
        color: statusColor(document),
      );
    }
    if (document.data()['orderStatus'] == 'Delivered') {
      return Icon(
        Icons.shopping_bag_outlined,
        color: statusColor(document),
      );
    }
    return Icon(
      Icons.assignment_turned_in_outlined,
      color: statusColor(document),
    );
  }

  Widget statusContainer(document, context) {
    if (document.data()['deliveryBoy']['name'].length > 1) {
      if (document.data()['orderStatus'] == 'Accepted') {
        return Container(
          color: Colors.grey[300],
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(40.0, 8, 40, 8),
            child: TextButton(
              style: ButtonStyle(
                  backgroundColor: ButtonStyleButton.allOrNull<Color>(
                      statusColor(document))),
              child: Text(
                'Update Status to Picked Up',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                EasyLoading.show();
                _services
                    .updateStatus(id: document.id, status: 'Picked Up')
                    .then((value) {
                  EasyLoading.showSuccess('Order status is now Picked Up');
                });
              },
            ),
          ),
        );
      }
      if (document.data()['orderStatus'] == 'Picked Up') {
        return Container(
          color: Colors.grey[300],
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(40.0, 8, 40, 8),
            child: TextButton(
              style: ButtonStyle(
                  backgroundColor: ButtonStyleButton.allOrNull<Color>(
                      statusColor(document))),
              child: Text(
                'Update Status to On The Way',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                EasyLoading.show();
                _services
                    .updateStatus(id: document.id, status: 'On the way')
                    .then((value) {
                  EasyLoading.showSuccess('Order status is now On The Way');
                });
              },
            ),
          ),
        );
      }

      if (document.data()['orderStatus'] == 'On the way') {
        return Container(
          color: Colors.grey[300],
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(40.0, 8, 40, 8),
            child: TextButton(
              style: ButtonStyle(
                  backgroundColor: ButtonStyleButton.allOrNull<Color>(
                      statusColor(document))),
              child: Text(
                'Deliver Order',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                if (document.data()['cod'] == true) {
                  return showMyDialog(
                      'Recieve Payment', 'Delivered', document.id, context);
                } else {
                  EasyLoading.show();
                  _services
                      .updateStatus(id: document.id, status: 'Delivered')
                      .then((value) {
                    EasyLoading.showSuccess('Order status is now Delivered');
                  });
                }
              },
            ),
          ),
        );
      }

      return Container(
        color: Colors.grey[300],
        height: 35,
        width: MediaQuery.of(context).size.width,
        child: TextButton(
          style: ButtonStyle(
              backgroundColor:
                  ButtonStyleButton.allOrNull<Color>(Colors.green)),
          child: Text(
            'Order Completed',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {},
        ),
      );
    }

    return Container(
      color: Colors.grey[300],
      height: 50,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                color: Colors.blueGrey,
                child: Text(
                  'Accept',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  showMyDialog(
                      'Accept Order', 'Accepted', document.id, context);
                },
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AbsorbPointer(
                absorbing:
                    document.data()['orderStatus'] == 'Rejected' ? true : false,
                child: FlatButton(
                  color: document.data()['orderStatus'] == 'Rejected'
                      ? Colors.grey
                      : Colors.red,
                  child: Text(
                    'Reject',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    showMyDialog(
                        'Reject Order', 'Rejected', document.id, context);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  showMyDialog(title, status, documentId, context) {
    OrderServices _orderServices = OrderServices();
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text('Make sure you have recieved payment '),
            actions: [
              FlatButton(
                child: Text(
                  'RECIEVE',
                  style: TextStyle(
                      color: Colors.deepOrangeAccent,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  EasyLoading.show();
                  _services
                      .updateStatus(id: documentId, status: 'Delivered')
                      .then((value) {
                    EasyLoading.showSuccess('Order Status is now Delivered');
                    Navigator.pop(context);
                  });
                },
              ),
              FlatButton(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                      color: Colors.deepOrangeAccent,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  void launchMap(lat, long, name) async {
    final availableMaps = await MapLauncher.installedMaps;

    await availableMaps.first.showMarker(
      coords: Coords(lat, long),
      title: name,
    );
  }
}
