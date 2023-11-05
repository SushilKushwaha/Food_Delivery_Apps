
import 'package:flutter/material.dart';
import 'package:food_delivery_app_admin/services/firebase_services.dart';



class LoginScreen extends StatefulWidget {
  static const String id = 'login-screen';


  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  String email, password;
  final _formKey = GlobalKey<FormState>();

  checkFields(){
    final form = _formKey.currentState;
    if(form.validate()){
      return true;
    }else{
      return false;
    }
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }



  @override
  Widget build(BuildContext context) {




    return Scaffold(

        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.deepOrangeAccent,
                Colors.white
              ],
              stops: [1.0,1.0],
              begin: Alignment.topCenter,
              end: Alignment(0.0,0.0),
            ),
          ),
          child: Center(
              child: Container(
                  height: 540.0,
                  width: 420.0,
                  child: Card(
                    elevation: 6,
                    shape: Border.all(color: Colors.deepOrangeAccent,width: 2),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0,
                                      right: 25.0,
                                      top: 20.0,
                                      bottom: 5.0),
                                  child: Container(

                                    child: Column(
                                      children: [
                                        Image.asset('images/logo.webp'),

                                        Text('FoodiesHub App Admin',style: TextStyle(fontWeight: FontWeight.w900,fontSize: 20),),
                                        SizedBox(height: 20,),
                                        TextFormField(

                                          validator: (value) => value.isEmpty
                                              ? 'Email is required'
                                              : validateEmail(value.trim()),
                                          onChanged: (value) {
                                            this.email = value;
                                          },
                                          decoration: InputDecoration(
                                            labelText: 'Username',
                                            prefixIcon: Icon(Icons.person),
                                            hintText: 'Username',
                                            contentPadding: EdgeInsets.only(left: 20,right: 20),
                                            border: OutlineInputBorder(),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Theme.of(context).primaryColor,
                                                )
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0,
                                      right: 25.0,
                                      top: 20.0,
                                      bottom: 5.0),
                                  child: Container(

                                    child: Column(
                                      children: [
                                        SizedBox(height: 0,),
                                        TextFormField(
                                          validator: (value) => value.isEmpty
                                              ? 'Password is required'
                                              : null,
                                          onChanged: (value) {
                                            this.password = value;
                                          },
                                          obscureText: true,
                                          decoration: InputDecoration(
                                            labelText: 'Minimum 6 Characters',
                                            prefixIcon: Icon(Icons.vpn_key_sharp),
                                            hintText: 'Password',
                                            contentPadding: EdgeInsets.only(left: 20,right: 20),
                                            border: OutlineInputBorder(),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Theme.of(context).primaryColor,
                                                ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                              SizedBox(height: 10,),
                              InkWell(
                                  onTap: () {
                                    if (checkFields()) {
                                      AuthService().signIn(email, password);
                                    }

                                  },

                                  child: Container(

                                      height: 35.0,
                                      width: 100.0,
                                      decoration: BoxDecoration(
                                        color: Colors.deepOrangeAccent,
                                      ),
                                      child: Center(child: Text('Sign in'))))
                            ],
                          ),
                      ),
                    ),
                  ),
              ),
          ),
        ),

    );
  }





}