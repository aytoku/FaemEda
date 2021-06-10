import 'package:flutter/material.dart';
import 'package:flutter_app/data/data.dart';

class TotalPrice extends StatefulWidget {
  GlobalKey<TotalPriceState> key;

  TotalPrice({this.key}) : super(key: key);

  @override
  TotalPriceState createState() {
    return new TotalPriceState();
  }
}

class TotalPriceState extends State<TotalPrice> {
  TotalPriceState();

  Widget build(BuildContext context) {
    double totalPrice = currentUser.cartModel.productsPrice;
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: totalPrice < currentUser.cartModel.storeData.meta.minOrderPrice ? Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${totalPrice.toStringAsFixed(0)}',
            style: TextStyle(fontSize: 18.0, color: Colors.black),
          ),
          Text(
            ' / ${currentUser.cartModel.storeData.meta.minOrderPrice} \₽',
            style: TextStyle(fontSize: 18.0, color: Colors.black.withOpacity(0.5)),
          ),
        ],
      ) :
      Text(
        '${totalPrice.toStringAsFixed(0)} \₽',
        style: TextStyle(fontSize: 18.0, color: Colors.black),
      ),
    );
  }
}
