import 'package:tap_debouncer/tap_debouncer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/CartScreen/API/change_item_count_in_cart.dart';
import 'package:flutter_app/Screens/CartScreen/View/cart_screen.dart';
import 'package:flutter_app/Screens/CartScreen/Widgets/PriceField.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../Internet/check_internet.dart';
import '../../../data/data.dart';
import '../API/decriment_cart_item.dart';
import '../API/increment_cart_item_count.dart';
import '../Model/CartModel.dart';
import 'TotalPrice.dart';

class Counter extends StatefulWidget {
  State parent;
  GlobalKey<PriceFieldState> priceFieldKey;
  Item order;
  List<TotalPrice> totalPriceList;
  Counter({Key key, this.priceFieldKey, this.order, this.totalPriceList, this.parent}) : super(key: key);

  @override
  CounterState createState() {
    return new CounterState(priceFieldKey, order, totalPriceList, parent);
  }
}

class CounterState extends State<Counter> {
  State parent;
  GlobalKey<PriceFieldState> priceFieldKey;
  List<TotalPrice> totalPriceList;
  Item order;
  bool isLoading = false;
  CounterState(this.priceFieldKey, this.order, this.totalPriceList, this.parent);

  int counter;

  // ignore: non_constant_identifier_names
  Future<void> _incrementCounter_plus() async {
    setState(() {
      order.count++;
    });
    isLoading = true;
    currentUser.cartModel = await changeItemCountInCart(necessaryDataForAuth.device_id, order.id, 1);
    isLoading = false;
    if(parent is CartScreenState){
      if((parent as CartScreenState).parent.totalPriceWidget.key.currentState!= null){
        (parent as CartScreenState).parent.totalPriceWidget.key.currentState.setState(() {

        });
      }
    }

    parent.setState(() {

    });
  }

  // ignore: non_constant_identifier_names
  Future<void> _incrementCounter_minus() async {
    setState(() {
      order.count--;
    });
    isLoading = true;
    currentUser.cartModel = await changeItemCountInCart(necessaryDataForAuth.device_id, order.id, -1);
    isLoading = false;
    if(parent is CartScreenState) {
      if ((parent as CartScreenState).parent.totalPriceWidget.key.currentState != null) {
        (parent as CartScreenState).parent.totalPriceWidget.key.currentState.setState(() {

        });
      }
    }
    parent.setState(() {

    });
  }

  Widget build(BuildContext context) {
    counter = order.count;
    return Row(
        children: [
          TapDebouncer(
            cooldown: const Duration(seconds: 1),
              onTap: () async {
                if (counter != 1) {
                  await _incrementCounter_minus();
                  // counter = restaurantDataItems.records_count;
                }
              },
            builder: (BuildContext context, TapDebouncerFunc onTap) {
              return InkWell(
                onTap: onTap,
                child: SvgPicture.asset('assets/svg_images/rest_minus.svg'),
              );
            }
          ),
          Container(
            child: Padding(
              padding: EdgeInsets.only(right: 15, left: 15),
              child: Center(
                child: Text(
                  '$counter',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
          ),
          TapDebouncer(
            cooldown: const Duration(seconds: 1),
              onTap: () async {
                if (await Internet.checkConnection()) {
                  await _incrementCounter_plus();
                } else {
                  noConnection(context);
                }
              },
            builder: (BuildContext context, TapDebouncerFunc onTap) {
              return InkWell(
                onTap: onTap,
                child: SvgPicture.asset('assets/svg_images/green_plus.svg'),
              );
            }
          ),
        ]);
  }

  void refresh() {
    setState(() {});
  }
}