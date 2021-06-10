import 'dart:io';

import 'package:flutter/cupertino.dart';
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
import 'package:flutter_app/data/globalVariables.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../data/data.dart';
import '../../Model/ProductsByStoreUuid.dart';
import 'Item.dart';
import 'ItemDesc.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/CartButton/CartButton.dart';

class MenuItemCounter extends StatefulWidget {
  GlobalKey<PriceFieldState> priceFieldKey;
  GlobalKey<MenuItemCounterState> menuItemCounterKey;
  BaseProductModel foodRecords;
  MenuItemState parent;
  GlobalKey<CartButtonState> cartButtonKey = new GlobalKey<CartButtonState>();
  MenuItemDescState descState;
  MenuItemCounter({this.menuItemCounterKey, this.priceFieldKey, this.foodRecords, this.parent, this.descState, this.cartButtonKey}) : super(key: menuItemCounterKey);

  @override
  MenuItemCounterState createState() {
    return new MenuItemCounterState(priceFieldKey, this.foodRecords, this.parent, this.menuItemCounterKey, this.descState, this.cartButtonKey);
  }
}

class MenuItemCounterState extends State<MenuItemCounter> {
  GlobalKey<PriceFieldState> priceFieldKey;
  BaseProductModel foodRecords;
  Item item;
  GlobalKey<MenuItemCounterState> menuItemCounterKey;
  GlobalKey<CartButtonState> cartButtonKey = new GlobalKey<CartButtonState>();
  MenuItemState parent;

  MenuItemDescState descState;

  MenuItemCounterState(this.priceFieldKey, this.foodRecords, this.parent, this.menuItemCounterKey, this.descState, this.cartButtonKey);

  int counter = 1;

  _deleteCartItem() {
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20),
              topRight: const Radius.circular(20),
            )),
        context: context,
        builder: (context) {
          return Container(
            height: 321,
            child: _buildDeleteCartItemNavigationMenu(),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                )),
          );
        });
  }

  _buildDeleteCartItemNavigationMenu() {
    List<Item> filteredCartItems = findCartItems(foodRecords);
    print(filteredCartItems.length);
    return Container(
      height: 300,
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 0, bottom: 20),
            child: Center(
              child: Text('Какое блюдо хотите удалить?',
                style: TextStyle(
                    fontSize: 18
                ),
              ),
            ),
          ),
          Container(
            height: 260,
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: filteredCartItems.length,
              itemBuilder: (BuildContext context, int index) {
                Item order = filteredCartItems[index];
                return Dismissible(
                  key: Key(order.product.uuid),
                  background: Container(
                      alignment: AlignmentDirectional.centerEnd,
                      color: Colors.red,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: SvgPicture.asset('assets/svg_images/del_basket.svg'),
                      )
                  ),
                  onDismissed: (direction) async {
                    AmplitudeAnalytics.analytics.logEvent('remove_from_cart ', eventProperties: {
                      'uuid': order.product.uuid
                    });
                    currentUser.cartModel = await deleteItemFromCart(necessaryDataForAuth.device_id, order.id);
                    currentUser.cartModel.items.remove(order);
                    Navigator.pop(context);
                    parent.setState(() {

                    });

                    if(parent.basketButtonStateKey.currentState != null &&
                        currentUser.cartModel.items.length == 0){
                      parent.basketButtonStateKey.currentState.setState(() {

                      });
                    }
                  },
                  direction: DismissDirection.endToStart,
                  child: Container(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width,
                    child: _buildCartItem(order, index),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Divider(
                      height: 1,
                      color: Color(0xFFE6E6E6),
                    )
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  _buildCartItem(Item order, int index) {
    GlobalKey<CounterState> counterKey = new GlobalKey();
    GlobalKey<PriceFieldState> priceFieldKey =
    new GlobalKey<PriceFieldState>();
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
              child: Image.network(
                getImage((order.product.meta.images != null && order.product.meta.images.length != 0) ? order.product.meta.images[0] : ''),
                fit: BoxFit.cover,
                height: 70,
                width: 70,
              ),),
          ),
          Padding(
            padding: EdgeInsets.only(left: 85),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      order.product.name,
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 14.0,
                          color: Color(0xFF000000)),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                (order.variantGroups != null)
                    ? Container(
                  child: Column(
                    children: List.generate(
                        order.variantGroups.length,
                            (index){
                          return Column(
                              children: List.generate(
                                  order.variantGroups[index].variants.length,
                                      (variantsIndex){
                                    return Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(bottom: 0.0),
                                        child: Text(order.variantGroups[index].variants[variantsIndex].name,
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 10
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                              )
                          );
                        }
                    ),
                  ),
                ) : Container(height: 0,),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Counter(
                          key: counterKey,
                          priceFieldKey: priceFieldKey,
                          order: order,
                          parent: this,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5, right: 2),
                          child: InkWell(
                            child: Container(
                              width: 20,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10, bottom: 10),
                                child: SvgPicture.asset(
                                    'assets/svg_images/del_basket.svg'),
                              ),
                            ),
                            onTap: () {
                              if(Platform.isIOS){
                                return showDialog(
                                    context: context,
                                    builder: (BuildContext context){
                                      return Padding(
                                        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.75),
                                        child: CupertinoActionSheet(
                                          actions: [
                                            CupertinoActionSheetAction(
                                              child: Text("Удалить",
                                                style: TextStyle(
                                                    color: Color(0xFFFF3B30),
                                                    fontSize: 20
                                                ),
                                              ),
                                              onPressed: () async {
                                                currentUser.cartModel = await deleteItemFromCart(necessaryDataForAuth.device_id, order.id);
                                                currentUser.cartModel.items.remove(order);
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                                parent.setState(() {

                                                });
                                                if(parent.basketButtonStateKey.currentState != null &&
                                                    currentUser.cartModel.items.length == 0){
                                                  parent.basketButtonStateKey.currentState.setState(() {

                                                  });
                                                }
                                              },
                                            ),
                                          ],
                                          cancelButton: CupertinoActionSheetAction(
                                            child: Text("Отмена",
                                              style: TextStyle(
                                                  color: Color(0xFF007AFF),
                                                  fontSize: 20
                                              ),
                                            ),
                                            onPressed: (){
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ),
                                      );
                                    }
                                );
                              }else{
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 0),
                                      child: Dialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(15.0))),
                                        child: Container(
                                            height: 130,
                                            width: 300,
                                            child: Column(
                                              children: <Widget>[
                                                InkWell(
                                                  child: Container(
                                                    padding: EdgeInsets.only(top: 20, bottom: 20),
                                                    child: Center(
                                                      child: Text("Удалить",
                                                        style: TextStyle(
                                                            color: Color(0xFFFF3B30),
                                                            fontSize: 20
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  onTap: () async {
                                                    currentUser.cartModel = await deleteItemFromCart(necessaryDataForAuth.device_id, order.id);
                                                    currentUser.cartModel.items.remove(order);
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                    parent.setState(() {

                                                    });
                                                    if(parent.basketButtonStateKey.currentState != null &&
                                                        currentUser.cartModel.items.length == 0){
                                                      parent.basketButtonStateKey.currentState.setState(() {

                                                      });
                                                    }
                                                  },
                                                ),
                                                Divider(
                                                  height: 1,
                                                  color: Colors.grey,
                                                ),
                                                InkWell(
                                                  child: Container(
                                                    padding: EdgeInsets.only(top: 20, bottom: 20),
                                                    child: Center(
                                                      child: Text("Отмена",
                                                        style: TextStyle(
                                                            color: Color(0xFF007AFF),
                                                            fontSize: 20
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  onTap: (){
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ],
                                            )),
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Column(
              children: [
                PriceField(key: priceFieldKey, order: order),
              ],
            ),
          )
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Future<void> _incrementCounter_plus() async {
    AmplitudeAnalytics.analytics.logEvent('plus_items_count ', eventProperties: {
      'uuid': item.product.uuid
    });
    currentUser.cartModel = await changeItemCountInCart(necessaryDataForAuth.device_id, item.id, 1);
    setState(() {});
  }

  // ignore: non_constant_identifier_names
  Future<void> _incrementCounter_minus({bool ignoreVariable = false}) async{
    AmplitudeAnalytics.analytics.logEvent('minus_items_count ', eventProperties: {
      'uuid': item.product.uuid
    });
    if(item.product.type == 'variable' && !ignoreVariable){
      int count = 0;
      currentUser.cartModel.items.forEach((element) {
        if(element.product.uuid == item.product.uuid)
          count++;
      });

      if(count > 1)
        _deleteCartItem();
      else
        _incrementCounter_minus(ignoreVariable: true);
    }else{
      currentUser.cartModel = await changeItemCountInCart(necessaryDataForAuth.device_id, item.id, -1);
      item = currentUser.cartModel.findCartItem(foodRecords);
      if(item.count == 0 || item == null){
        currentUser.cartModel = await deleteItemFromCart(necessaryDataForAuth.device_id, item.id);
        parent.setState(() {

        });
        if(parent.basketButtonStateKey.currentState != null &&
            currentUser.cartModel.items.length == 0){
          parent.basketButtonStateKey.currentState.setState(() {

          });
        }
      }

      setState(() {
      });
    }
  }


  List<Item> findCartItems(BaseProductModel product){
    List<Item> items = new List<Item>();
    try {
      items.addAll(currentUser.cartModel.items.where((element) => element.product.uuid == product.uuid));
    }catch(e){
      items = new List<Item>();
    }
    return items;
  }


  Widget build(BuildContext context) {
    item = currentUser.cartModel.findCartItem(foodRecords);
    if(item == null){
      if(parent.restaurant.type == 'restaurant'){
        return Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 0, bottom: 0),
            child: Row(
              children: [
                SvgPicture.asset('assets/svg_images/green_plus.svg', height: 26,),
                Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, bottom: 5, top: 5, right: 5),
                      child: Text(
                        '${foodRecords.price.toStringAsFixed(0)} \₽',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                ),
              ],
            ),
          ),
        );
      }else{
        return Padding(
          padding: const EdgeInsets.only(bottom: 0, right: 0, left: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 5, top: 5,),
                    child: Text(
                      '${foodRecords.price.toStringAsFixed(0)} \₽',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
              ),
              SvgPicture.asset('assets/svg_images/green_plus.svg', height: 36,),
            ],
          ),
        );
      }
    }

    counter = 0;
    for(int i = 0; i<currentUser.cartModel.items.length; i++){
      var element = currentUser.cartModel.items[i];
      if(element.product.uuid == foodRecords.uuid){
        counter += element.count;
      }
    }

    return Padding(
        padding: EdgeInsets.only(left: 0, bottom: 0 ),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          InkWell(
            onTap: () async {
              if (counter != 0) {
                await _incrementCounter_minus();
              }
            },
            child: SvgPicture.asset('assets/svg_images/rest_minus.svg', height: (parent.restaurant.type == 'restaurant') ? 26 : 36,),
          ),
          Container(
            height: 30,
            width: 60,
            child: Padding(
              padding: EdgeInsets.only(right: 0, left: 0),
              child: Center(
                child: Text(
                  '$counter',
                  style: TextStyle(
                      fontSize: (parent.restaurant.type == 'restaurant') ? 20 : 26,
                      fontWeight: FontWeight.w400
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              if (await Internet.checkConnection()) {
                if(foodRecords.type == 'variable'){
                  parent.onPressedButton(foodRecords, menuItemCounterKey);
                }else{
                  await _incrementCounter_plus();
                  setState(() {});
                }
              } else {
                noConnection(context);
              }
            },
            child: SvgPicture.asset('assets/svg_images/green_plus.svg', height: (parent.restaurant.type == 'restaurant') ? 26 : 36,),
          ),
        ])
    );
  }

  // void _onTapDown(TapDownDetails details) {
  //
  // }

  void refresh() {
    setState(() {});
  }
}