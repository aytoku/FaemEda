import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/Amplitude/amplitude.dart';
import 'package:flutter_app/Internet/check_internet.dart';
import 'package:flutter_app/Screens/CartScreen/API/change_item_count_in_cart.dart';
import 'package:flutter_app/Screens/CartScreen/API/delete_item_from_cart.dart';
import 'package:flutter_app/Screens/CartScreen/Model/CartModel.dart';
import 'package:flutter_app/Screens/CartScreen/Widgets/Counter.dart';
import 'package:flutter_app/Screens/CartScreen/Widgets/PriceField.dart';
import 'package:flutter_app/Screens/CartScreen/Widgets/TotalPrice.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Model/BaseProductModel.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Model/ProductsByStoreUuid.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../data/data.dart';
import '../../Model/ProductsByStoreUuid.dart';
import 'Item.dart';

class MenuItemDesc extends StatefulWidget {
  GlobalKey<PriceFieldState> priceFieldKey;
  BaseProductModel foodRecords;
  MenuItemState parent;
  MenuItemDesc({Key key, this.priceFieldKey, this.foodRecords, this.parent}) : super(key: key);

  @override
  MenuItemDescState createState() {
    return new MenuItemDescState(this.priceFieldKey, this.foodRecords, this.parent);
  }
}

class MenuItemDescState extends State<MenuItemDesc> {
  GlobalKey<PriceFieldState> priceFieldKey;
  BaseProductModel foodRecords;
  Item item;
  MenuItemState parent;

  MenuItemDescState(this.priceFieldKey, this.foodRecords, this.parent);
  int counter = 1;

  Widget build(BuildContext context) {
    item = currentUser.cartModel.findCartItem(foodRecords);
    if(item == null){
      return Padding(
        padding: const EdgeInsets.only(left: 15.0, bottom: 0, top: 5),
        child: Align(
          alignment: Alignment.topLeft,
          child: Container(
            padding: EdgeInsets.only(right: 15),
            child: Text(
              foodRecords.description,
              style: TextStyle(
                  fontSize: 10.0,
                  color: Colors.grey),
              maxLines: (parent.restaurant.type == 'restaurant') ? 3 : 2,
              overflow: TextOverflow.ellipsis,
              //overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      );
    }

    counter = 0;
    for(int i = 0; i<currentUser.cartModel.items.length; i++){
      var element = currentUser.cartModel.items[i];
      if(element.product.uuid == foodRecords.uuid){
        counter += element.count;
      }
    }

    return Row(
      children: [
        // Padding(
        //   padding: const EdgeInsets.only(left: 15.0, bottom: 0, top: 5),
        //   child: Align(
        //     alignment: Alignment.topLeft,
        //     child: Container(
        //       padding: EdgeInsets.only(right: 0),
        //       child: Text(
        //         '${foodRecords.weight.toStringAsFixed(0)}' + '' + foodRecords.weightMeasurement,
        //         style: TextStyle(
        //             fontSize: 12.0,
        //             color: Colors.grey),
        //         textAlign: TextAlign.start,
        //       ),
        //     ),
        //   ),
        // ),
        // Padding(
        //   padding: const EdgeInsets.only(left: 5.0, top: 6, right: 5),
        //   child: SvgPicture.asset('assets/svg_images/ellipse.svg',
        //     color: Colors.grey,
        //     width: 2,
        //     height: 2,),
        // ),
        // Padding(
        //   padding: const EdgeInsets.only(left: 5.0, bottom: 0, top: 5),
        //   child: Text(
        //     '${(foodRecords.weight + counter).toStringAsFixed(0)}кг • ${(foodRecords.price * counter).toStringAsFixed(0)} \₽',
        //     style: TextStyle(
        //         fontSize: 12.0,
        //         color: Colors.grey),
        //     overflow: TextOverflow.ellipsis,
        //   ),
        // ),
      ],
    );
  }

  void refresh() {
    setState(() {});
  }
}