import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/product.dart';
import '../../scoped-models/main.dart';

class ProductFAB extends StatefulWidget {
  final Product product;

  ProductFAB(this.product);

  @override
  State<StatefulWidget> createState() {
    return _ProductFABState();
  }
}

class _ProductFABState extends State<ProductFAB> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: 70.0,
              width: 56.0,
              alignment: FractionalOffset.topCenter,
              child: ScaleTransition(
                scale: CurvedAnimation(
                  parent: _controller,
                  curve: Interval(0.0, 1.0, curve: Curves.easeOut),
                ),
                child: FloatingActionButton(
                  backgroundColor: Theme.of(context).cardColor,
                  foregroundColor: Theme.of(context).primaryColor,
                  onPressed: () async {
                    final url = 'mailto:${widget.product.userEmail}';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch!';
                    }
                  },
                  heroTag: 'contact',
                  child: Icon(Icons.mail),
                  mini: true,
                ),
              ),
            ),
            Container(
                height: 70.0,
                width: 56.0,
                alignment: FractionalOffset.topCenter,
                child: ScaleTransition(
                  scale: CurvedAnimation(
                    parent: _controller,
                    curve: Interval(0.0, 0.5, curve: Curves.easeOut),
                  ),
                  child: FloatingActionButton(
                    backgroundColor: Theme.of(context).cardColor,
                    foregroundColor: Colors.red,
                    onPressed: () {
                      model.toggleProductFavoriteStatus();
                    },
                    heroTag: 'favorite',
                    child: Icon(model.selectedProduct.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border),
                    mini: true,
                  ),
                )),
            Container(
              height: 70.0,
              width: 56.0,
              child: FloatingActionButton(
                onPressed: () {
                  if (_controller.isDismissed) {
                    _controller.forward();
                  } else {
                    _controller.reverse();
                  }
                },
                heroTag: 'options',
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (BuildContext context, Widget child) {
                    return Transform(
                      alignment: FractionalOffset.center,
                      transform:
                          Matrix4.rotationZ(_controller.value * 0.5 * math.pi),
                      child: Icon(_controller.isDismissed
                          ? Icons.more_vert
                          : Icons.close),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}