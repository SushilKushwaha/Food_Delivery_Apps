import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class ProductProvider with ChangeNotifier {
  String selectedCategory;
  String selectedSubCategory;
  String categoryImage;
  File image;
  String pickerError;
  String shopName;
  String productUrl;

  selectCategory(mainCategory, categoryImage) {
    this.selectedCategory = mainCategory;
    this.categoryImage = categoryImage; //need to bring image here
    notifyListeners();
  }

  selectSubCategory(selected) {
    this.selectedSubCategory = selected;
    notifyListeners();
  }

  getShopName(shopName) {
    this.shopName = shopName;
    notifyListeners();
  }

  resetProvider() {
    this.selectedCategory = null;
    this.selectedSubCategory = null;
    this.categoryImage = null;
    this.image = null;
    this.productUrl = null;
    notifyListeners();
  }

//upload product image

  Future<String> uploadProductImage(filepath, productName) async {
    File file = File(filepath);
    var timeStamp = Timestamp.now().millisecondsSinceEpoch;
    FirebaseStorage _storage = FirebaseStorage.instance;
    try {
      await _storage
          .ref('productImage/${this.shopName}/$productName$timeStamp')
          .putFile(file);
    } on FirebaseException catch (e) {
      print(e.code);
    }
    String downloadURL = await _storage
        .ref('productImage/${this.shopName}/$productName$timeStamp')
        .getDownloadURL();
    this.productUrl = downloadURL;
    notifyListeners();
    return downloadURL;
  }

  Future<File> getProductImage() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 20);
    if (pickedFile != null) {
      this.image = File(pickedFile.path);
      notifyListeners();
    } else {
      this.pickerError = 'No image selected';
      print('No image selected');
      notifyListeners();
    }
    return this.image;
  }

  alertDialog({context, title, content}) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              CupertinoDialogAction(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  //save product data to firestore

  Future<void> saveProductDataToDb(
      {productName,
      description,
      price,
      comparedPrice,
      collection,
      sku,
      tax,
      serviceCharge,
      ktchfoodiqty,
      lowqty,
      context}) {
    var timeStamp =
        DateTime.now().microsecondsSinceEpoch; //this will use as product id
    User user = FirebaseAuth.instance.currentUser;
    CollectionReference _products =
        FirebaseFirestore.instance.collection('products');
    try {
      _products.doc(timeStamp.toString()).set({
        'seller': {'shopName': this.shopName, 'sellerUid': user.uid},
        'productName': productName,
        'description': description,
        'price': price,
        'comparedPrice': comparedPrice,
        'collection': collection,
        'sku': sku,
        'category': {
          'mainCategory': this.selectedCategory,
          'subCategory': this.selectedSubCategory,
          'categoryImage': this.categoryImage
        },
        'tax': tax,
        'serviceCharge': serviceCharge,
        'ktchfoodiqty': ktchfoodiqty,
        'lowqty': lowqty,
        'published': false, //keep initial value as false
        'productId': timeStamp.toString(),
        'productImage': this.productUrl
      });

      this.alertDialog(
          context: context,
          title: 'SAVE DATA',
          content: 'Product Details saved successfully');
    } catch (e) {
      this.alertDialog(
        context: context,
        title: 'SAVE DATA',
        content: '${e.toString()}',
      );
    }
    return null;
  }

  Future<void> updateProduct({
    productName,
    description,
    price,
    comparedPrice,
    collection,
    sku,
    tax,
    serviceCharge,
    ktchfoodiqty,
    lowqty,
    context,
    productId,
    image,
    category,
    subCategory,
    categoryImage,
  }) {
    var timeStamp =
        DateTime.now().microsecondsSinceEpoch; //this will use as product id
    User user = FirebaseAuth.instance.currentUser;
    CollectionReference _products =
        FirebaseFirestore.instance.collection('products');
    try {
      _products.doc(productId).update({
        'productName': productName,
        'description': description,
        'price': price,
        'comparedPrice': comparedPrice,
        'collection': collection,
        'sku': sku,
        'category': {
          'mainCategory': category,
          'subCategory': subCategory,
          'categoryImage':
              this.categoryImage == null ? categoryImage : this.categoryImage
        },
        'tax': tax,
        'serviceCharge': serviceCharge,
        'ktchfoodiqty': ktchfoodiqty,
        'lowqty': lowqty,
        'productImage': this.productUrl == null ? image : this.productUrl
      });

      this.alertDialog(
          context: context,
          title: 'SAVE DATA',
          content: 'Product Details saved successfully');
    } catch (e) {
      this.alertDialog(
        context: context,
        title: 'SAVE DATA',
        content: '${e.toString()}',
      );
    }
    return null;
  }
}
