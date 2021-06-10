import 'package:flutter/material.dart';
import 'package:flutter_app/data/data.dart';


class ItemsPadding extends StatefulWidget {
  ItemsPadding({Key key}) : super(key: key);

  @override
  ItemsPaddingState createState() {
    return new ItemsPaddingState();
  }
}

class ItemsPaddingState extends State<ItemsPadding> {
  ItemsPaddingState();

  Widget build(BuildContext context) {
    bool addPadding = false;

    addPadding = currentUser.cartModel != null && currentUser.cartModel.items != null &&
        currentUser.cartModel.items.isNotEmpty;

    return Container(
      height: (addPadding) ? 100 : 15,
    );
  }
}