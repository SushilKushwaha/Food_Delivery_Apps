
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:restaurants_app/provider/product_provider.dart';
import 'package:restaurants_app/widgets/category_list.dart';

class AddNewProduct extends StatefulWidget {
  static const String id = 'addnewproduct-screen';

  @override
  _AddNewProductState createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct> {

  final _formKey = GlobalKey<FormState>();

  List<String> _collections = [
    'Featured Products',
    'Best Selling',
    'Recently Added'
  ];
  String dropdownValue;


  var _categoryTextController = TextEditingController();
  var _subCategoryTextController = TextEditingController();
  var _comparedPriceTextController = TextEditingController();
  var _lowqtyTextController = TextEditingController();
  var _ktcfoodiqtyTextController = TextEditingController();

  File _image;
  bool _visible= false;
  bool _track=false;
  String productName;
  String description;
  double price;
  double comparedPrice;
  String sku;
  double tax;
  double serviceCharge;


  @override
  Widget build(BuildContext context) {

    var _provider = Provider.of<ProductProvider>(context);


    return DefaultTabController(
      length: 2,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Material(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Container(
                          child: Text('Products / Add'),
                        ),
                      ),
                      FlatButton.icon(
                        color: Theme.of(context).primaryColor,
                        icon: Icon(Icons.save,color: Colors.white,),
                        label: Text('Save',style: TextStyle(color: Colors.white),),
                        onPressed: () {
                          if(_formKey.currentState.validate()){
                           if(_categoryTextController.text.isNotEmpty){
                             if(_subCategoryTextController.text.isNotEmpty){
                               if(_image!=null){
                                 EasyLoading.show(status: 'Saving....');
                                 _provider.uploadProductImage(_image.path, productName).then((url){
                                   if(url!=null){
                                     //upload product data to firestore
                                     EasyLoading.dismiss();
                                     _provider.saveProductDataToDb(
                                       context: context,
                                       comparedPrice: int.parse(_comparedPriceTextController.text),
                                       collection: dropdownValue,
                                       description: description,
                                       ktchfoodiqty: int.parse(_ktcfoodiqtyTextController.text),
                                       lowqty: int.parse(_lowqtyTextController.text),
                                       price: price,
                                       sku: sku,
                                       tax: tax,
                                       serviceCharge: serviceCharge,
                                       productName: productName,
                                     );
                                     setState(() {
                                       //clear all the existing value after saved product
                                       _formKey.currentState.reset();
                                       _comparedPriceTextController.clear();
                                       dropdownValue = null;
                                       _subCategoryTextController.clear();
                                       _categoryTextController.clear();
                                       _track=false;
                                       _image=null;
                                       _visible=false;
                                     });
                                   } else{
                                     _provider.alertDialog(
                                       context: context,
                                       title: 'IMAGE UPLOAD',
                                       content: 'Failed to upload product image',
                                     );
                                   }
                                 });
                               }else{
                                 _provider.alertDialog(
                                   context: context,
                                   title: 'PRODUCT IMAGE',
                                   content: 'Product image not selected',
                                 );
                               }
                             }else{
                               _provider.alertDialog(
                                   context: context,
                                   title: 'Sub Category',
                                   content: 'Sub Category not selected'
                               );
                             }
                           }else{
                             _provider.alertDialog(
                               context: context,
                               title: 'Main Category',
                               content: 'Main Category not selected'
                             );
                           }
                          }
                        },
                      ),



                    ],
                  ),
                ),
              ),
              TabBar(
                labelColor:Theme.of(context).primaryColor ,
                unselectedLabelColor: Colors.black,
                indicatorColor: Theme.of(context).primaryColor,
                tabs: [
                  Tab(text: 'GENERAL',),
                  Tab(text: 'KITCHEN',),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: TabBarView(
                      children: [
                        ListView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  TextFormField(

                                    validator: (value){
                                      if(value.isEmpty){
                                        return 'Enter Product Name';

                                      }
                                      setState(() {
                                        productName = value;
                                      });
                                      return null;
                                    },

                                    decoration: InputDecoration(
                                      labelText: 'Product Name*',
                                      labelStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey[300],
                                        ),
                                      ),
                                    ),
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 5,
                                    maxLength: 500,
                                    validator: (value){
                                      if(value.isEmpty){
                                        return 'Enter Description';

                                      }
                                      setState(() {
                                        description = value;
                                      });
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'About Product*',
                                      labelStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey[300],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: (){
                                        _provider.getProductImage().then((image) {

                                          setState(() {
                                            _image = image;
                                          });
                                        });
                                      },
                                      child: SizedBox(
                                        width: 150,
                                        height: 150,
                                        child: Card(
                                          color: Theme.of(context).primaryColor,

                                          child: _image==null ? Center(child: Text('Select Image')): Image.file(_image),
                                        ),
                                      ),
                                    ),
                                  ),
                                  TextFormField(
                                    validator: (value){
                                      if(value.isEmpty){
                                        return 'Enter Selling Price';

                                      }
                                      setState(() {
                                        price = double.parse(value);
                                      });
                                      return null;
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: 'Price*',
                                      labelStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey[300],
                                        ),
                                      ),
                                    ),
                                  ),
                                  TextFormField(
                                    controller: _comparedPriceTextController,
                                    validator: (value){
                                      if(price>double.parse(value)){
                                        return 'compared price should be higher than price';
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: ' Compared Price',
                                      labelStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey[300],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Container(
                                    child: Row(
                                      children: [
                                       Text('Collection',style: TextStyle(color: Colors.grey),),
                                        SizedBox(width: 10,),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).primaryColor,
                                          ),
                                          child: DropdownButton<String>(
                                            hint: Text('Select Collection'),
                                            value: dropdownValue,
                                            icon: Icon(Icons.arrow_drop_down),
                                            onChanged: (String value){
                                              setState(() {
                                                dropdownValue = value;
                                              });
                                            },
                                            items: _collections.map<DropdownMenuItem<String>>((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  TextFormField(
                                    validator: (value){
                                      if(value.isEmpty){
                                        return 'Enter SKU';
                                      }
                                      setState(() {
                                        sku = value;
                                      });
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      labelText: ' SKU',
                                      labelStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey[300],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20,bottom: 10),
                                    child: Row(
                                      children: [
                                        Text('Category',style: TextStyle(color: Colors.grey,fontSize: 16),),
                                        SizedBox(width: 10,),
                                        Expanded(
                                          child: AbsorbPointer(
                                            absorbing: true, //this will block user entering name manually
                                            child: TextFormField(
                                              validator: (value){
                                                if(value.isEmpty){
                                                  return 'Select Category Name';
                                                }
                                                return null;
                                              },
                                              controller: _categoryTextController,
                                              decoration: InputDecoration(
                                                fillColor: Colors.deepOrangeAccent,
                                                filled: true,
                                                hintText: ' not selected',
                                                labelStyle: TextStyle(color: Colors.grey),
                                                enabledBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.deepOrangeAccent,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                            icon: Icon(Icons.edit_outlined),
                                            onPressed: (){
                                              showDialog(
                                                  context: context,
                                                builder: (BuildContext context){
                                                    return CategoryList();
                                                }
                                              ).whenComplete(() {
                                                setState(() {
                                                  _categoryTextController.text = _provider.selectedCategory;
                                                  _visible = true;
                                                });
                                              });
                                            },
                                        )
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: _visible,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10, bottom: 20),
                                      child: Row(
                                        children: [
                                          Text('Sub Category', style: TextStyle(color: Colors.grey,fontSize: 16),),
                                          SizedBox(width: 10,),
                                          Expanded(
                                            child: AbsorbPointer(
                                              absorbing: true,
                                              child: TextFormField(
                                                validator: (value){
                                                  if(value.isEmpty){
                                                    return 'Select Sub Category Name';
                                                  }
                                                  return null;
                                                },
                                                controller: _subCategoryTextController,
                                                decoration: InputDecoration(
                                                  fillColor: Colors.deepOrangeAccent,
                                                  filled: true,
                                                  hintText: ' not selected',
                                                  labelStyle: TextStyle(color: Colors.grey),
                                                  enabledBorder: UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Colors.deepOrangeAccent,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),

                                          IconButton(
                                            icon: Icon(Icons.edit_outlined),
                                            onPressed: (){
                                              showDialog(
                                                  context: context,
                                                  builder: (BuildContext context){
                                                    return SubCategoryList();
                                                  }
                                              ).whenComplete(() {
                                                setState(() {
                                                  _subCategoryTextController.text = _provider.selectedSubCategory;

                                                });
                                              });
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  TextFormField(
                                    validator: (value){
                                      if(value.isEmpty){
                                        return 'Enter Service Charge %';
                                      }
                                      setState(() {
                                       serviceCharge= double.parse(value);
                                      });
                                      return null;
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: ' Service Charge %',
                                      labelStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey[300],
                                        ),
                                      ),
                                    ),
                                  ),
                                  TextFormField(
                                    validator: (value){
                                      if(value.isEmpty){
                                        return 'Enter Tax %';
                                      }
                                      setState(() {
                                        tax = double.parse(value);
                                      });
                                      return null;
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: ' Tax %',
                                      labelStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey[300],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              SwitchListTile(
                                title: Text('Track Kitchen'),
                                activeColor: Theme.of(context).primaryColor,
                                subtitle: Text('Switch on to track Kitchen',
                                  style: TextStyle(color: Colors.grey,fontSize: 12),),
                                value: _track,
                                onChanged: (selected){
                                 setState(() {
                                   _track = !_track;
                                 });
                                },
                              ),
                              Visibility(
                                visible: _track,
                                child: SizedBox(
                                  height: 300,
                                  width: double.infinity,
                                  child: Card(
                                    elevation: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        children: [
                                          TextFormField(
                                           controller: _ktcfoodiqtyTextController,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              labelText: ' Kitchen Food Items Quantity',
                                              labelStyle: TextStyle(color: Colors.grey),
                                              enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.grey[300],
                                                ),
                                              ),
                                            ),
                                          ),
                                          TextFormField(
                                            controller: _lowqtyTextController,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              labelText: ' Kitchen Food Items low Quantity',
                                              labelStyle: TextStyle(color: Colors.grey),
                                              enabledBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.grey[300],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
