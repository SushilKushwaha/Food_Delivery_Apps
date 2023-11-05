import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:restaurants_app/services/firebase_services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:restaurants_app/services/order_services.dart';
import 'package:url_launcher/url_launcher.dart';

class DeliveryBoysList extends StatefulWidget {
  final DocumentSnapshot document;
  DeliveryBoysList(this.document);

  @override
  _DeliveryBoysListState createState() => _DeliveryBoysListState();
}

class _DeliveryBoysListState extends State<DeliveryBoysList> {
  FirebaseServices _services = FirebaseServices();
  OrderServices _orderServices = OrderServices();
  GeoPoint _shopLocation;

  @override
  void initState() {
    _services.getShopDetails().then((value) {
      if (value != null) {
        if (mounted) {
          setState(() {
            _shopLocation = value.data()['location'];
          });
        }
      } else {
        print('no data');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              title: Text(
                'Select Delivery Boy',
                style: TextStyle(color: Colors.white),
              ),
              iconTheme: IconThemeData(color: Colors.white),
            ),
            Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: _services.boys
                    .where('accVerified', isEqualTo: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return ListView(
                    shrinkWrap: true,
                    children:
                        snapshot.data.docs.map((DocumentSnapshot document) {
                      GeoPoint location = document.data()['location'];
                      double distanceInMeters = _shopLocation == null
                          ? 0.0
                          : Geolocator.distanceBetween(
                                  _shopLocation.latitude,
                                  _shopLocation.longitude,
                                  location.latitude,
                                  location.longitude) /
                              1000;
                      if (distanceInMeters > 10) {
                        return Container();
                        //it will show only nearest delivery boy. that within 10km radius
                      }
                      return Column(
                        children: [
                          ListTile(
                            onTap: () {
                              EasyLoading.show(status: 'Assigning Boys');
                              _services
                                  .selectBoys(
                                      orderId: widget.document.id,
                                      boyid: document.data()['uid'],
                                      phone: document.data()['mobile'],
                                      email: document.data()['username'],
                                      name: document.data()['name'],
                                      address: document.data()['address'],
                                      image: document.data()['imageUrl'])
                                  .then((value) {
                                EasyLoading.showSuccess(
                                    'Assigned Delivery Boys');
                                Navigator.pop(context);
                              });
                            },
                            leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Image.network(document.data()['imageUrl']),
                            ),
                            title: Text(document.data()['name']),
                            subtitle: Text(
                                '${distanceInMeters.toStringAsFixed(0)} Km'), //need to find
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.map,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  onPressed: () {
                                    GeoPoint location =
                                        document.data()['location'];
                                    _orderServices.launchMap(
                                        location, document.data()['location']);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.phone,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  onPressed: () {
                                    launch('tel:${document.data()['mobile']}');
                                  },
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            height: 2,
                            color: Colors.grey,
                          )
                        ],
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
