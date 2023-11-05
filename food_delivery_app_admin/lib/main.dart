import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app_admin/screens/HomeScreen.dart';
import 'package:food_delivery_app_admin/screens/admin_users.dart';
import 'package:food_delivery_app_admin/screens/category_screen.dart';
import 'package:food_delivery_app_admin/screens/customer_screen.dart';
import 'package:food_delivery_app_admin/screens/deliver_boy_screen.dart';
import 'package:food_delivery_app_admin/screens/login_screen.dart';
import 'package:food_delivery_app_admin/screens/manage_banners.dart';
import 'package:food_delivery_app_admin/screens/notification_screen.dart';
import 'package:food_delivery_app_admin/screens/order_screen.dart';
import 'package:food_delivery_app_admin/screens/settings_screen.dart';
import 'package:food_delivery_app_admin/screens/vendor_screen.dart';
import 'package:food_delivery_app_admin/services/firebase_services.dart';
import 'package:provider/provider.dart';

import 'providers/order_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => OrderProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FoodiesHub App Admin DashBoard',
      theme: ThemeData(
        primaryColor: Colors.deepOrangeAccent,
      ),
      home: AuthService().handleAuth(),
      routes: {
        HomePage.id: (context) => HomePage(),
        LoginScreen.id: (context) => LoginScreen(),
        BannerScreen.id: (context) => BannerScreen(),
        CategoryScreen.id: (context) => CategoryScreen(),
        OrderScreen.id: (context) => OrderScreen(),
        NotificationScreen.id: (context) => NotificationScreen(),
        AdminUsers.id: (context) => AdminUsers(),
        SettingScreen.id: (context) => SettingScreen(),
        VendorScreen.id: (context) => VendorScreen(),
        DeliveryBoyScreen.id: (context) => DeliveryBoyScreen(),
        CustomerScreen.id: (context) => CustomerScreen(),
      },
    );
  }
}
