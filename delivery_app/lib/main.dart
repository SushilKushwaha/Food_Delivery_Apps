import 'package:delivery_app/providers/auth_provider.dart';
import 'package:delivery_app/providers/product_provider.dart';
import 'package:delivery_app/screens/home_screen.dart';
import 'package:delivery_app/screens/order_screen.dart';
import 'package:delivery_app/screens/login_screen.dart';
import 'package:delivery_app/screens/register_screen.dart';
import 'package:delivery_app/screens/reset_password_screen.dart';
import 'package:delivery_app/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

void main() async {
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => AuthProvider()),
        Provider(create: (_) => ProductProvider()),
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
      title: 'FoodiesHub Delivery App',
      theme: ThemeData(primaryColor: Color(0xFFFF6E40), fontFamily: 'Lato'),
      builder: EasyLoading.init(),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        OrderScreen.id: (context) => OrderScreen(),
        ResetPassword.id: (context) => ResetPassword(),
        RegisterScreen.id: (context) => RegisterScreen(),
        HomeScreen.id: (context) => HomeScreen(),
      },
    );
  }
}
