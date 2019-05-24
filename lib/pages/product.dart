import 'package:flutter/material.dart';

class ProductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ProductDetail'),
      ),
      body: Column(
        children: <Widget>[
          Text("Details!"),
          RaisedButton(
            child: Text('քամակ'),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
    );
  }
}
