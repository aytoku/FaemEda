import 'package:flutter/material.dart';
import 'package:flutter_app/data/data.dart';

class CartButtonCounter extends StatefulWidget {
  CartButtonCounter({Key key}) : super(key: key);

  @override
  CartButtonCounterState createState() {
    return new CartButtonCounterState();
  }
}

class CartButtonCounterState extends State<CartButtonCounter> {
  @override
  Widget build(BuildContext context) {
    double totalPrice = currentUser.cartModel.productsPrice * 1.0;

    return Text('${totalPrice.toStringAsFixed(0)} \₽',
        style: TextStyle(
            fontSize: 18.0, color: AppColor.textColor));
  }

  void refresh() {
    setState(() {});
  }
}