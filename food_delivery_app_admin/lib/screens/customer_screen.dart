import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:food_delivery_app_admin/services/sidebar.dart';
import 'package:food_delivery_app_admin/widgets/customer/customer_datatable.dart';

class CustomerScreen extends StatelessWidget {
  static const String id = 'customer-screen';

  @override
  Widget build(BuildContext context) {
    SideBarWidget _sideBar = SideBarWidget();
    return AdminScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text('FoodiesHub App Dashboard'),
      ),
      sideBar: _sideBar.sideBarMenus(context, CustomerScreen.id),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Manage Customers',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                ),
              ),
              Text('Manage all the Customer Activities'),
              Divider(
                thickness: 5,
              ),
              CustomerDatable(),
              Divider(
                thickness: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
