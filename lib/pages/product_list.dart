import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:EasyList/pages/product_edit.dart';
import '../scoped-models/main.dart';

class ProductListPage extends StatefulWidget {
  final MainModel model;
  ProductListPage(this.model);
  @override
  State<StatefulWidget> createState() {
    return _ProductListPageState();
  }
}

class _ProductListPageState extends State<ProductListPage> {
  @override
  initState() {
    widget.model.fetchProducts(onlyForUser: true);
    super.initState();
  }

  Widget _buildEditButton(BuildContext context, int index, MainModel model) {
    return IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          model.selectProduct(model.allProducts[index].id);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return ProductEditPage();
              },
            ),
          ).then((_) => model.selectProduct(null));
        });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              background: Container(color: Colors.red),
              onDismissed: (DismissDirection direction) {
                if (direction == DismissDirection.endToStart) {
                  model.selectProduct(model.allProducts[index].id);
                  model.deleteProduct();
                }
              },
              key: Key(model.allProducts[index].title),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: CircleAvatar(
                        backgroundImage:
                            // AssetImage(model.allProducts[index].image)),
                            NetworkImage(model.allProducts[index].image)),
                    title: Text(model.allProducts[index].title),
                    subtitle:
                        Text('\$${model.allProducts[index].price.toString()}'),
                    trailing: _buildEditButton(context, index, model),
                  ),
                  Divider(),
                ],
              ),
            );
          },
          itemCount: model.allProducts.length,
        );
      },
    );
  }
}
