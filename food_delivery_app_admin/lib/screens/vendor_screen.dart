import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:food_delivery_app_admin/services/sidebar.dart';
import 'package:food_delivery_app_admin/widgets/vendor/Vendor_datatable_widget.dart';


class VendorScreen extends StatefulWidget {
 static const String id = 'vendor-screen';
  @override
  State<VendorScreen> createState() => _VendorScreenState();
}

class _VendorScreenState extends State<VendorScreen> {
  @override
  Widget build(BuildContext context) {

    SideBarWidget _sideBar = SideBarWidget();

    return AdminScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        title: const Text('FoodiesHub App Dashboard'),
      ),
      sideBar: _sideBar.sideBarMenus(context,VendorScreen.id),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Manage Vendors',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                ),
              ),
              Text('Manage all the Vendors Activities'),
              Divider(thickness: 5,),
              VendorDataTable(),
              Divider(thickness: 5,),
            ],
          ),
        ),
      ),
    );
  }
}

