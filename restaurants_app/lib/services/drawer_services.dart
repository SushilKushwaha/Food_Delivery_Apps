


import 'package:flutter/cupertino.dart';
import 'package:restaurants_app/screens/add_edit_coupon_screen.dart';
import 'package:restaurants_app/screens/banner_screen.dart';
import 'package:restaurants_app/screens/coupon_screen.dart';
import 'package:restaurants_app/screens/dashboard_screen.dart';
import 'package:restaurants_app/screens/logout_screen.dart';
import 'package:restaurants_app/screens/order_screen.dart';
import 'package:restaurants_app/screens/product_screen.dart';

class DrawerServices{

  Widget drawerScreen(title){
    if(title == 'Dashboard'){
      return MainScreen();
    }
    if(title == 'Product'){
      return ProductScreen();
    }
    if(title == 'Banner'){
      return BannerScreen();
    }
    if(title == 'Coupons'){
      return CouponScreen();
    }
    if(title == 'Orders'){
      return OrderScreen();
    }
    if(title == 'Logout'){
      return LogOutScreen();
    }
    return MainScreen();
  }
}