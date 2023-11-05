import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app_admin/services/firebase_services.dart';

class CreateNewBoyWidget extends StatefulWidget {
  @override
  State<CreateNewBoyWidget> createState() => _CreateNewBoyWidgetState();
}

class _CreateNewBoyWidgetState extends State<CreateNewBoyWidget> {
  FirebaseServices _services = FirebaseServices();
  var emailText = TextEditingController();
  var passwordText = TextEditingController();
  bool _visible = false;
  @override
  Widget build(BuildContext context) {
    ArsProgressDialog progressDialog = ArsProgressDialog(context,
        blur: 2,
        backgroundColor: Color(0xFF84c225).withOpacity(.3),
        animationDuration: Duration(milliseconds: 500));
    return Container(
      color: Colors.grey,
      width: MediaQuery.of(context).size.width,
      height: 80,
      child: Row(
        children: [
          Visibility(
            visible: _visible ? false : true,
            child: Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Container(
                child: FlatButton(
                    child: Text(
                      'Create New Delivery Boy',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      setState(() {
                        _visible = true;
                      });
                    },
                    color: Colors.black54),
              ),
            ),
          ),
          Visibility(
            visible: _visible,
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Container(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 200,
                        height: 30,
                        child: TextField(
                          //TODO: Email validator
                          controller: emailText,
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 1),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Email ID',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.only(left: 20)),
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        height: 30,
                        child: TextField(
                          controller: passwordText,
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.black, width: 1),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              hintText: 'Password',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.only(left: 20)),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      FlatButton(
                          child: Text(
                            'Save',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            if (emailText.text.isEmpty) {
                              return _services.showMyDialog(
                                  context: context,
                                  title: 'Email ID',
                                  message: 'Email ID not entered');
                            }
                            if (passwordText.text.isEmpty) {
                              return _services.showMyDialog(
                                  context: context,
                                  title: 'Password',
                                  message: 'password not entered');
                            }
                            if (passwordText.text.length < 6) {
                              return _services.showMyDialog(
                                  context: context,
                                  title: 'Password',
                                  message: 'Minimum 6 Characters');
                            }
                            progressDialog.show();
                            _services
                                .saveDeliveryBoys(
                                    emailText.text, passwordText.text)
                                .whenComplete(() {
                              emailText.clear();
                              passwordText.clear();
                              progressDialog.dismiss();
                              _services.showMyDialog(
                                  context: context,
                                  title: 'Save Delivery Boy',
                                  message: 'Saved Successfully');
                            });
                          },
                          color: Colors.black54),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
