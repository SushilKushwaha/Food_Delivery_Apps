import 'package:flutter/cupertino.dart';

class ProductProvider with ChangeNotifier {
  String boyName;

  getBoyName(boyName) {
    this.boyName = boyName;
    notifyListeners();
  }
}
