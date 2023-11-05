import 'package:flutter/cupertino.dart';

import 'package:delivery_app/screens/dashboard_screen.dart';
import 'package:delivery_app/screens/logout_screen.dart';
import 'package:delivery_app/screens/order_screen.dart';

class DrawerServices {
  Widget drawerScreen(title) {
    if (title == 'Dashboard') {
      return MainScreen();
    }
    if (title == 'Orders') {
      return OrderScreen();
    }
    if (title == 'Logout') {
      return LogOutScreen();
    }
    return MainScreen();
  }
}
