import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class ProductProvider with ChangeNotifier {
  String categoryImage;
  File image;
  String pickerError;
  String customerName;
  String productUrl;

  resetProvider() {
    this.categoryImage = null;
    this.image = null;
    this.productUrl = null;
    notifyListeners();
  }

//upload product image

  Future<String> uploadProfileImage(filepath) async {
    File file = File(filepath);
    var timeStamp = Timestamp.now().millisecondsSinceEpoch;
    FirebaseStorage _storage = FirebaseStorage.instance;
    try {
      await _storage
          .ref('profileImage/${this.customerName}/$timeStamp')
          .putFile(file);
    } on FirebaseException catch (e) {
      print(e.code);
    }
    String downloadURL = await _storage
        .ref('profileImage/${this.customerName}/$timeStamp')
        .getDownloadURL();
    this.productUrl = downloadURL;
    notifyListeners();
    return downloadURL;
  }

  Future<File> getProfileImage() async {
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
}
