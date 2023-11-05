import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app_admin/services/firebase_services.dart';
import 'package:food_delivery_app_admin/widgets/vendor/subcategory_widget.dart';

class CategoryCard extends StatelessWidget {
  final DocumentSnapshot document;
  final FirebaseServices _services = FirebaseServices();

  CategoryCard(this.document);

  void _deleteCategory(BuildContext context) {
    _services.category.doc(document.id).delete().then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Category deleted')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete category')),
      );
      print('Failed to delete category: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(4),
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return SubCategoryWidget(document['name']);
          },
        );
      },
      child: SizedBox(
        height: 120,
        width: 120,
        child: Stack(
          children: [
            Card(
              color: Colors.grey[100],
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 70,
                        width: double.infinity,
                        child: Image.network(document['image']),
                      ),
                      FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          document['name'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                color: Colors.red,
                icon: Icon(Icons.delete),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Delete Category'),
                        content: Text(
                            'Are you sure you want to delete this category?'),
                        actions: [
                          FlatButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          FlatButton(
                            child: Text('Delete'),
                            onPressed: () {
                              _deleteCategory(context);
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
