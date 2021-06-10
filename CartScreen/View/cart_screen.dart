
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/CartScreen/View/cart_page_view.dart';
import 'package:flutter_app/Screens/CartScreen/Widgets/Counter.dart';
import 'package:flutter_app/Screens/CartScreen/Widgets/PriceField.dart';
import 'package:flutter_app/Screens/CartScreen/Widgets/TotalPrice.dart';
import 'package:flutter_app/Screens/HomeScreen/Bloc/restaurant_get_bloc.dart';
import 'package:flutter_app/Screens/HomeScreen/View/home_screen.dart';
import 'package:flutter_app/Screens/RestaurantScreen/View/grocery_screen.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../Amplitude/amplitude.dart';
import '../../../data/data.dart';
import '../../../data/data.dart';
import '../../../data/data.dart';
import '../../../data/data.dart';
import '../../HomeScreen/Model/FilteredStores.dart';
import '../../RestaurantScreen/View/restaurant_screen.dart';
import '../API/clear_cart.dart';
import '../API/delete_item_from_cart.dart';
import '../Model/CartModel.dart';
import 'empty_cart_screen.dart';

class CartScreen extends StatefulWidget {
  CartScreen({Key key, this.restaurant, this.parent, this.isTakeAwayScreen}) : super(key: key);
  final FilteredStores restaurant;
  CartPageState parent;
  bool isTakeAwayScreen;

  @override
  CartScreenState createState() => CartScreenState(restaurant, parent, isTakeAwayScreen);
}

class CartScreenState extends State<CartScreen> {
  String title;
  String category;
  String description;
  String price;
  String discount;
  CartPageState parent;
  final FilteredStores restaurant;
  GlobalKey<ScaffoldState> _scaffoldStateKey = GlobalKey();
  GlobalKey<TotalPriceState> totalPriceKey;
  List<TotalPrice> totalPrices;
  double total;
  bool delete = false;
  bool isTakeAwayScreen;


  CartScreenState(this.restaurant, this.parent, this.isTakeAwayScreen);

  _buildList() {
    if(currentUser.cartModel == null
        || currentUser.cartModel.items == null
          || currentUser.cartModel.items.length == 0){
      return Container();
    }
    return Expanded(
      child: ListView.separated(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: currentUser.cartModel.items.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index < currentUser.cartModel.items.length) {
            Item order = currentUser.cartModel.items[index];
            print(currentUser.cartModel.items[index].getUniqueUuid());
            return Dismissible(
              key: Key(currentUser.cartModel.items[index].getUniqueUuid()),
              background: Container(
                  alignment: AlignmentDirectional.centerEnd,
                  color: Colors.red,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: SvgPicture.asset('assets/svg_images/del_basket.svg'),
                  )
              ),
              confirmDismiss: (direction) async {
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
                                  Navigator.of(context).pop(true);
                                  if(parent.totalPriceWidget.key.currentState!= null){
                                    parent.totalPriceWidget.key.currentState.setState(() {

                                    });
                                  }
                                  setState(() {
                                    AmplitudeAnalytics.analytics.logEvent('remove_product_dismiss ', eventProperties: {
                                      'uuid': currentUser.cartModel.items[index].product.uuid
                                    });
                                  });
                                  if (currentUser.cartModel.items.length == 0) {
                                    Navigator.pushReplacement(
                                      context,
                                      new MaterialPageRoute(
                                        builder: (context) =>
                                        new EmptyCartScreen(restaurant: restaurant, source: parent.source),
                                      ),
                                    );
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
                                Navigator.of(context).pop(false);
                                AmplitudeAnalytics.analytics.logEvent('not_remove_product_dismiss ', eventProperties: {
                                  'uuid': currentUser.cartModel.items[index].product.uuid
                                });
                              },
                            ),
                          ),
                        );
                      }
                  );
                }else{
                  return await showDialog(
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
                                      Navigator.of(context).pop(true);
                                      if(parent.totalPriceWidget.key.currentState!= null){
                                        parent.totalPriceWidget.key.currentState.setState(() {

                                        });
                                      }
                                      setState(() {
                                        AmplitudeAnalytics.analytics.logEvent('remove_product_dismiss ', eventProperties: {
                                          'uuid': currentUser.cartModel.items[index].product.uuid
                                        });
                                      });
                                      if (currentUser.cartModel.items.length == 0) {
                                        Navigator.pushReplacement(
                                          context,
                                          new MaterialPageRoute(
                                            builder: (context) =>
                                            new EmptyCartScreen(restaurant: restaurant, source: parent.source,),
                                          ),
                                        );
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
                                      Navigator.of(context).pop(false);
                                      AmplitudeAnalytics.analytics.logEvent('not_remove_product_dismiss ', eventProperties: {
                                        'uuid': currentUser.cartModel.items[index].product.uuid
                                      });
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
              direction: DismissDirection.endToStart,
              child: Container(
                color: AppColor.themeColor,
                width: MediaQuery.of(context).size.width,
                child: _buildCartItem(order, index),
              ),
            );
          }
          return Padding(
              padding: EdgeInsets.all(15.0),
              child: Column(
                children: <Widget>[
                  (isTakeAwayScreen) ? Container(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                            'Заберите заказ на ' + restaurant.address.unrestrictedValue,
                          style: TextStyle(
                            fontSize: 14
                          ),
                        ),
                      ),
                    ),
                  ) : Container(),
                  // Container(
                  //   child: Padding(
                  //     padding: const EdgeInsets.only(top: 5, bottom: 20),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: <Widget>[
                  //         Row(
                  //           children: [
                  //             Text(
                  //               'Доставка',
                  //               style: TextStyle(
                  //                   fontSize: 18.0,
                  //                   color: Color(0xFF000000)),
                  //             ),
                  //             // Padding(
                  //             //   padding: const EdgeInsets.only(left: 8.0, top: 5, bottom: 20,),
                  //             //   child: Text(
                  //             //     (currentUser.cartModel.cookingTime != null)? '~' + '${currentUser.cartModel.cookingTime ~/ 60} мин' : '',
                  //             //     style: TextStyle(
                  //             //       fontSize: 12.0,
                  //             //       color: Colors.black,
                  //             //     ),
                  //             //   ),
                  //             // ),
                  //           ],
                  //         ),
                  //         Text(
                  //           (currentUser.cartModel.deliveryPrice != null)? '~' + '${currentUser.cartModel.deliveryPrice} \₽' : '',
                  //           style: TextStyle(
                  //               fontSize: 18.0,
                  //               color: Color(0xFF000000)),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  (isTakeAwayScreen) ? Padding(
                    padding: EdgeInsets.only(bottom: 20, top: 20),
                    child: Divider(
                      height: 1,
                      color: Color(0xFFE6E6E6),
                    ),
                  ) : Container(),
                  Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Итого',
                          style: TextStyle(
                              fontSize: 18.0,
                              color: Color(0xFF000000)),
                        ),
                        Text(
                            (currentUser.cartModel.productsPrice != null) ? '${currentUser.cartModel.productsPrice.toStringAsFixed(0)} \₽' : '',
                          style: TextStyle(
                            fontSize: 18
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20, top: 20),
                    child: Divider(
                      height: 1,
                      color: Color(0xFFE6E6E6),
                    ),
                  ) ,
                  SizedBox(height: 80.0)
                ],
              ));
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
    );
  }

  _buildCartItem(Item order, int index) {
    GlobalKey<CounterState> counterKey = new GlobalKey();
    GlobalKey<PriceFieldState> priceFieldKey =
    new GlobalKey<PriceFieldState>();
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(top: 15, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 15),
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
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 15),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    order.product.name,
                                    style: TextStyle(
                                        decoration: TextDecoration.none,
                                        fontSize: 14.0,
                                        color: Color(0xFF000000)),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                                (true)
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
                                                              color: AppColor.additionalTextColor,
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
                              ],
                            ),
                          ),
                        ),
                        PriceField(key: priceFieldKey, order: order),
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(
                      top: (order.product.type == "single") ? 13 : 10.0,
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Counter(
                            key: counterKey,
                            priceFieldKey: priceFieldKey,
                            order: order,
                            totalPriceList: totalPrices,
                            parent: this,
                          ),
                          InkWell(
                            radius: 40,
                            child: Container(
                              margin: EdgeInsets.only(left: 15, right: 15),
                              height: 40,
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
                                                Navigator.pop(context);
                                                if(parent.totalPriceWidget.key.currentState!= null){
                                                  parent.totalPriceWidget.key.currentState.setState(() {

                                                  });
                                                }
                                                setState(() {
                                                  // if(parent.totalPriceWidget.key.currentState != null){
                                                  //   parent.totalPriceWidget.key.currentState.setState(() {
                                                  //
                                                  //   });
                                                  // }
                                                  AmplitudeAnalytics.analytics.logEvent('remove_product', eventProperties: {
                                                    'uuid': currentUser.cartModel.items[index].product.uuid
                                                  });
                                                });
                                                if (currentUser.cartModel.items.length == 0) {
                                                  Navigator.pushReplacement(
                                                    context,
                                                    new MaterialPageRoute(
                                                      builder: (context) =>
                                                      new EmptyCartScreen(restaurant: restaurant, source: parent.source),
                                                    ),
                                                  );
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
                                              AmplitudeAnalytics.analytics.logEvent('not_remove_product', eventProperties: {
                                                'uuid': currentUser.cartModel.items[index].product.uuid
                                              });
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
                                                    Navigator.pop(context);
                                                    if(parent.totalPriceWidget.key.currentState!= null){
                                                      parent.totalPriceWidget.key.currentState.setState(() {

                                                      });
                                                    }
                                                    setState(() {
                                                      AmplitudeAnalytics.analytics.logEvent('remove_product', eventProperties: {
                                                        'uuid': currentUser.cartModel.items[index].product.uuid
                                                      });
                                                    });
                                                    if (currentUser.cartModel.items.length == 0) {
                                                      Navigator.pushReplacement(
                                                        context,
                                                        new MaterialPageRoute(
                                                          builder: (context) =>
                                                          new EmptyCartScreen(restaurant: restaurant, source: parent.source,),
                                                        ),
                                                      );
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
                                                    AmplitudeAnalytics.analytics.logEvent('not_remove_product', eventProperties: {
                                                      'uuid': currentUser.cartModel.items[index].product.uuid
                                                    });
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    totalPrices = new List<TotalPrice>();
    totalPrices.add(new TotalPrice(key: new GlobalKey(),));
    totalPrices.add(new TotalPrice(key: new GlobalKey(),));
    totalPrices.add(parent.totalPriceWidget);
    return WillPopScope(
      onWillPop: () async{
        if(parent.source == CartSources.Home){
          homeScreenKey = new GlobalKey<HomeScreenState>();
          Navigator.pushReplacement(context,
              new MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => RestaurantGetBloc(),
                    child: new HomeScreen(),
                  )
              )
          );
        }else if(parent.source == CartSources.Restaurant){
          Navigator.pushReplacement(context,
              new MaterialPageRoute(builder:
                  (context)=>RestaurantScreen(restaurant: restaurant)
              )
          );
        }else if(parent.source == CartSources.Other){
          Navigator.pop(context);
          setState(() {

          });
        }
        return false;
      },
      child: Expanded(
          child: Column(
            children: <Widget>[
              _buildList(),
            ],
          )),
    );
  }
}