import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/Amplitude/amplitude.dart';
import 'package:flutter_app/Internet/check_internet.dart';
import 'package:flutter_app/Screens/CartScreen/Widgets/PriceField.dart';
import 'package:flutter_app/Screens/HomeScreen/Bloc/restaurant_get_bloc.dart';
import 'package:flutter_app/Screens/HomeScreen/Model/FilteredStores.dart';
import 'package:flutter_app/Screens/HomeScreen/View/home_screen.dart';
import 'package:flutter_app/Screens/RestaurantScreen/API/add_variant_to_cart.dart';
import 'package:flutter_app/Screens/RestaurantScreen/API/getProductData.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Model/BaseProductModel.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Model/ProductDataModel.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Model/ProductsByStoreUuid.dart';
import 'package:flutter_app/Screens/RestaurantScreen/View/restaurant_screen.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/CartButton/CartButton.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/DiscountType.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/ItemsPadding.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/PanelContent.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/ProductDescCounter.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/ProductMenu/ItemDesc.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/VariantSelector.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../../data/data.dart';
import '../../../../data/data.dart';
import 'ItemCounter.dart';

class MenuItem extends StatefulWidget {
  MenuItem({
    this.key,
    this.restaurantDataItems,
    this.restaurant,
    this.parent,
    this.counterKey,
    this.basketButtonStateKey,
    this.itemsPaddingKey,
    this.panelContentKey,
    this.panelController
  }) : super(key: key);
  final GlobalKey<MenuItemState> key;
  final State parent;
  FilteredStores restaurant;
  final BaseProductModel restaurantDataItems;
  GlobalKey<ProductDescCounterState> counterKey;
  GlobalKey<CartButtonState> basketButtonStateKey;
  GlobalKey<ItemsPaddingState> itemsPaddingKey;
  GlobalKey<PanelContentState> panelContentKey;
  PanelController panelController;

  @override
  MenuItemState createState() {
    return new MenuItemState(
        restaurantDataItems,
        restaurant,
        parent,
        counterKey,
        basketButtonStateKey,
        itemsPaddingKey,
        panelContentKey,
        panelController
    );
  }
  static List<MenuItem> fromFoodRecordsList(
      List<ProductsByStoreUuid> foodRecordsList,
      RestaurantScreenState parent,
      FilteredStores restaurant,
      GlobalKey<ProductDescCounterState> counterKey,
      GlobalKey<CartButtonState> basketButtonStateKey,
      GlobalKey<ItemsPaddingState> itemsPaddingKey,
      GlobalKey<PanelContentState> panelContentKey,
      PanelController panelController
      ) {
    List<MenuItem> result = new List<MenuItem>();
    foodRecordsList.forEach((element) {
      result.add(new MenuItem(
        parent: parent,
        restaurantDataItems: element,
        key: new GlobalKey<MenuItemState>(),
        restaurant: restaurant,
        basketButtonStateKey: basketButtonStateKey,
        counterKey: counterKey,
        itemsPaddingKey: itemsPaddingKey,
        panelContentKey: panelContentKey,
        panelController: panelController,
      ));
    });
    return result;
  }
}

class MenuItemState extends State<MenuItem> with AutomaticKeepAliveClientMixin{
  final BaseProductModel restaurantDataItems;
  final State parent;
  FilteredStores restaurant;

  GlobalKey<ProductDescCounterState> counterKey = new GlobalKey();
  GlobalKey<CartButtonState> basketButtonStateKey = new GlobalKey();
  GlobalKey<ItemsPaddingState> itemsPaddingKey = new GlobalKey();
  GlobalKey<PanelContentState> panelContentKey = new GlobalKey();
  PanelController panelController = new PanelController();
  GlobalKey<CircularState> circularKey = new GlobalKey();


  MenuItemState(
      this.restaurantDataItems,
      this.restaurant,
      this.parent,
      this.counterKey,
      this.basketButtonStateKey,
      this.itemsPaddingKey,
      this.panelContentKey,
      this.panelController);


  showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 1), () {
          Navigator.of(context).pop(true);
        });
        return Padding(
          padding: EdgeInsets.only(bottom: 500),
          child: Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            child: Container(
              height: 50,
              width: 100,
              child: Center(
                child: Text("Товар добавлен в корзину"),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lock = false;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;



  _dayOff() {
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
            height: 250,
            child: _dayOffBottomNavigationMenu(restaurant),
            decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                )),
          );
        });
  }


  _dayOffBottomNavigationMenu(FilteredStores restaurant) {
    Standard standard = restaurant.workSchedule.getCurrentStandard();
    return Container(
      decoration: BoxDecoration(
          color: AppColor.themeColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
          )),
      child: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 30),
            child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Text('К сожалению, заведение не доступно.',
                      style: TextStyle(
                          fontSize: 16
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text((standard!= null) ? "Заведение откроется в ${standard.beginningTime} часов" : '',
                      style: TextStyle(
                          fontSize: 16
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10,left: 15, right: 15, bottom: 25),
            child: Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  child: Container(
                    height: 52,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColor.mainColor
                    ),
                    child: Center(
                      child: Text(
                        "Далее",
                        style:
                        TextStyle(color: AppColor.textColor, fontSize: 16),
                      ),
                    ),
                  ),
                  onTap: ()async {
                    homeScreenKey = new GlobalKey<HomeScreenState>();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (context) => RestaurantGetBloc(),
                              child: new HomeScreen(),
                            )),
                            (Route<dynamic> route) => false);
                  },
                )
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isScheduleAvailable = restaurant.workSchedule.isAvailable();
    bool available = restaurant.available.flag != null ? restaurant.available.flag : true;
    super.build(context);
    GlobalKey<MenuItemCounterState> menuItemCounterKey = new GlobalKey();
    if(restaurant.type == 'restaurant'){
      return Container(
        color: AppColor.themeColor,
        child: Padding(
          padding: EdgeInsets.only(top: 10.0, left: 15, right: 15,
              bottom:  10),
          child: Center(
              child: GestureDetector(
                  onTap: () async {
                    if (await Internet.checkConnection()) {
                      if(isScheduleAvailable || available){
                        showDialog(
                          context: context,
                          builder: (context) {
                            Future.delayed(Duration(seconds: 10), () {
                              Navigator.of(context).pop(true);
                            });
                            return CupertinoAlertDialog(
                              content: Text('Наш магазин работает с 8:00 до 23:00, укажите удобное время доставки в комментариях к заказу',
                                style: TextStyle(fontSize: 14),),
                            );
                          },
                        );
                      }else{
                        onPressedButton(restaurantDataItems, menuItemCounterKey);
                      }
                      AmplitudeAnalytics.analytics.logEvent('open_product ', eventProperties: {
                        'uuid': restaurantDataItems.uuid
                      });
                      // Navigator.push(context, MaterialPageRoute(builder: (context)=> PB()));
                    } else {
                      noConnection(context);
                    }
                  },
                  child: Container(
                    height: 152,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12.withOpacity(0.05),
                          blurRadius: 7.0, // soften the shadow
                          spreadRadius: 3.0, //extend the shadow
                        )
                      ],
                      color: AppColor.themeColor,
                      // border: Border.all(width: 1.0, color: Colors.grey[200]),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFFFFFF),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        bottomLeft: Radius.circular(15),
                                        bottomRight: Radius.circular(15)),
                                  ),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        height: 110,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 10.0, left: 15, bottom: 5),
                                              child: Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  restaurantDataItems.name,
                                                  maxLines: 3,
                                                  style: TextStyle(
                                                      fontSize: 14.0, color: Color(0xFF3F3F3F), fontWeight: FontWeight.w700),
                                                  textAlign: TextAlign.start,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                            // Padding(
                                            //   padding: const EdgeInsets.only(left: 10.0),
                                            //   child: MenuItemDesc(foodRecords: restaurantDataItems, parent: this),
                                            // )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 15.0),
                                        child: MenuItemCounter(foodRecords: restaurantDataItems, menuItemCounterKey: menuItemCounterKey, parent: this),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Align(
                                alignment: Alignment.topRight,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: Stack(
                                    children: [
                                      Image.asset('assets/images/food.png',
                                        fit: BoxFit.cover,
                                        height:
                                        MediaQuery.of(context).size.height,
                                        width: 168,
                                      ),
                                      Image.network(
                                        getImage(restaurantDataItems.image),
                                        fit: BoxFit.cover,
                                        height:
                                        MediaQuery.of(context).size.height,
                                        width: 168,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Visibility(
                            //   visible: restaurantDataItems.old_price == 0 ? false : true,
                            //   child: DiscountTapeWidget(price: restaurantDataItems.price, oldPrice: restaurantDataItems.old_price),
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ))),
        ),
      );
    }else {
      return GestureDetector(
        child: Container(
          padding: EdgeInsets.only(top: 15),
          height: 300,
          decoration: BoxDecoration(
            color: AppColor.themeColor,
            border: Border.all(width: 0.5, color: AppColor.unselectedBorderFieldColor.withOpacity(0.3)),
            // borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    height: 130,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Center(
                        child: Stack(
                          children: [
                            Image.asset('assets/images/food.png',
                              fit: BoxFit.contain,
                              height: 150,
                              width: 150,
                            ),
                            Image.network(
                              getImage(restaurantDataItems.image),
                              fit: BoxFit.contain,
                              height: 150,
                              width: 150,
                            ),
                          ],
                        ),
                      ),),
                  ),
                ),
                Container(
                  height: 135,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                      color: Colors.transparent
                  ),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15, top: 12, right: 15, bottom: 15),
                          child: Text(
                            restaurantDataItems.name,
                            maxLines: 3,
                            style: TextStyle(
                              fontSize: 14.0, color: Color(0xFF3F3F3F), ),
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      // Align(
                      //   alignment: Alignment.topLeft,
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(left: 2,),
                      //     child: Text(
                      //       "${}кг • ${restaurantDataItems.price} ₽",
                      //       maxLines: 2,
                      //       style: TextStyle(
                      //         fontSize: 12.0, color: AppColor.additionalTextColor, ),
                      //       textAlign: TextAlign.start,
                      //       overflow: TextOverflow.ellipsis,
                      //     ),
                      //   ),
                      // ),
                      // Align(
                      //   alignment: Alignment.topLeft,
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(left: 2.0),
                      //     child: Text(
                      //       (currentUser.cartModel.findCartItem(restaurantDataItems) != null) ?
                      //       '${(restaurantDataItems.meta.weight + count).toStringAsFixed(0)}кг • ${(restaurantDataItems.price * count).toStringAsFixed(0)} ₽' :
                      //       '${(restaurantDataItems.price).toStringAsFixed(0)} ₽',
                      //       style: TextStyle(
                      //           fontSize: 12.0,
                      //           color: Colors.grey),
                      //       overflow: TextOverflow.ellipsis,
                      //     ),
                      //   ),
                      Spacer(),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                          child: MenuItemCounter(
                              foodRecords: restaurantDataItems,
                              menuItemCounterKey: menuItemCounterKey,
                              parent: this),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        onTap: () async {
          if (await Internet.checkConnection()) {
            if(!closeDialog && (!isScheduleAvailable || !available)){
              onPressedButton(restaurantDataItems, menuItemCounterKey);
              showDialog(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    content: Text('Наш магазин работает с 8:00 до 23:00, укажите удобное время доставки в комментариях к заказу',
                      style: TextStyle(fontSize: 14),),
                    actions: [
                      FlatButton(
                        child: Text("Да"),
                        onPressed: () {
                          Navigator.pop(context);
                          closeDialog = true;
                        },
                      )
                    ],
                  );
                },
              );
            }else{
              onPressedButton(restaurantDataItems, menuItemCounterKey);
            }
            AmplitudeAnalytics.analytics.logEvent('open_product ', eventProperties: {
              'uuid': restaurantDataItems.uuid
            });
            // Navigator.push(context, MaterialPageRoute(builder: (context)=> PB()));
          } else {
            noConnection(context);
          }
        },
      );
    }
  }


  void onPressedButton(BaseProductModel food, GlobalKey<MenuItemCounterState> menuItemCounterKey) {



    GlobalKey<PriceFieldState> priceFieldKey =
    new GlobalKey<PriceFieldState>();


    if(restaurantDataItems.type == 'single'){
      if(panelContentKey.currentState != null)
        panelContentKey.currentState.setState(() {
          panelContentKey.currentState.menuItem = null;
        });

      showModalBottomSheet(
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(12),
                topRight: const Radius.circular(12),
              )),
          context: context,
          builder: (context) {
            return Container(
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(12),
                    topRight: const Radius.circular(12),
                  )
              ),
              child: Wrap(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: AppColor.themeColor,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(12),
                          topRight: const Radius.circular(12),
                        )
                    ),
                    child: Column(
                      children: [
                        FutureBuilder<ProductsDataModel>(
                          future: getProductData(restaurantDataItems.uuid),
                          builder: (BuildContext context,
                              AsyncSnapshot<ProductsDataModel> snapshot){
                            if(snapshot.connectionState == ConnectionState.done){
                              ProductsDataModel productsDescription = snapshot.data;

                              List<VariantsSelector> variantsSelectors = getVariantGroups(productsDescription);

                              return Stack(
                                children: [
                                  ConstrainedBox(
                                    constraints: BoxConstraints.loose(
                                        Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height * 0.7,)),
                                    child: DraggableScrollableSheet(
                                      initialChildSize: MediaQuery.of(context).size.width / MediaQuery.of(context).size.height / 0.7 + 0.1 > 1.0
                                          ? MediaQuery.of(context).size.width / MediaQuery.of(context).size.height / 0.7
                                          : MediaQuery.of(context).size.width / MediaQuery.of(context).size.height / 0.7 + 0.1,
                                      expand: false,
                                      builder: (context, controller) => Container(
                                        margin: EdgeInsets.symmetric(horizontal: 20),
                                        child: ListView(
                                          physics: BouncingScrollPhysics(),
                                          controller: controller,
                                          shrinkWrap: true,
                                          children: [
                                            ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(12),
                                                    topRight: Radius.circular(12),
                                                    bottomLeft: Radius.circular(0),
                                                    bottomRight: Radius.circular(0)),
                                                child: Stack(
                                                  children: <Widget>[
                                                    Center(child: Image.asset('assets/images/food.png')),
                                                    Padding(
                                                      padding: EdgeInsets.only(top: 20),
                                                      child: Image.network(
                                                        getImage(productsDescription.product.meta.images?.first),
                                                        fit: BoxFit.fill,

                                                        width: MediaQuery.of(context).size.width,
                                                      ),
                                                    ),
                                                    // Align(
                                                    //     alignment: Alignment.topRight,
                                                    //     child: Padding(
                                                    //       padding: EdgeInsets.only(top: 10, right: 15),
                                                    //       child: GestureDetector(
                                                    //         child: SvgPicture.asset(
                                                    //             'assets/svg_images/bottom_close.svg'),
                                                    //         onTap: () {
                                                    //           Navigator.pop(context);
                                                    //         },
                                                    //       ),
                                                    //     ))
                                                  ],
                                                )),
                                            Padding(
                                              padding:
                                              EdgeInsets.only(top: 20, bottom: 10),
                                              child: Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  productsDescription.product.meta.description,
                                                  style: TextStyle(
                                                      color: Colors.grey, fontSize: 15),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        margin: EdgeInsets.all(10),
                                        padding: EdgeInsets.all(10),
                                        child: SvgPicture.asset('assets/svg_images/big_cross.svg'),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }else{
                              return Center(child: Image.asset('assets/images/food.png',
                                fit: BoxFit.fill,
                                width: MediaQuery.of(context).size.width,));
                            }
                          },
                        ),
                        FutureBuilder<ProductsDataModel>(
                          future: getProductData(restaurantDataItems.uuid),
                          builder: (BuildContext context,
                              AsyncSnapshot<ProductsDataModel> snapshot){
                            if(snapshot.connectionState == ConnectionState.done){
                              ProductsDataModel productsDescription = snapshot.data;

                              List<VariantsSelector> variantsSelectors = getVariantGroups(productsDescription);

                              return Container(
                                child: Stack(
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppColor.themeColor,
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(top: (productsDescription.product.meta.description != "" &&
                                                  productsDescription.product.meta.description != null) ? 0 : 0),
                                              child: Container(
                                                padding: EdgeInsets.only(top: 15, bottom: 15),
                                                decoration: (productsDescription.variantGroups != null) ? BoxDecoration(
                                                  color: AppColor.themeColor,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black12,
                                                      blurRadius: 4.0, // soften the shadow
                                                      spreadRadius: 1.0, //extend the shadow
                                                    )
                                                  ],
                                                ) : null,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: <Widget>[
                                                        Expanded(child: Padding(
                                                          padding: const EdgeInsets.only(left: 20, right: 20, top: 0),
                                                          child: Container(
                                                            child: RichText(text:
                                                            TextSpan(
                                                                children: <TextSpan>[
                                                                  TextSpan(text: restaurantDataItems.name,
                                                                    style: TextStyle(
                                                                        fontSize: 16.0,
                                                                        color: Color(0xFF000000)),),
                                                                ]
                                                            )
                                                            ),
                                                          ),
                                                        )),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 4.0,
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(top: 10, bottom: 0),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        children: <Widget>[
                                                          Flexible(
                                                            flex: 1,
                                                            child: Padding(
                                                              padding: EdgeInsets.only(left: 20),
                                                              child: ProductDescCounter(
                                                                  key: counterKey,
                                                                  priceFieldKey: priceFieldKey
                                                              ),
                                                            ),
                                                          ),
                                                          Flexible(
                                                            flex: 2,
                                                            child: Padding(
                                                              padding: EdgeInsets.only(left: 8, right: 20),
                                                              child: Stack(
                                                                children: [
                                                                  Container(
                                                                    height: 52,
                                                                    decoration: BoxDecoration(
                                                                      color: AppColor.mainColor,
                                                                      borderRadius: BorderRadius.circular(10),
                                                                    ),
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.only(left: 15, right: 15),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                                        children: [
                                                                          PriceField(key: priceFieldKey, restaurantDataItems: restaurantDataItems),
                                                                          SizedBox(width: 10),
                                                                          Text(
                                                                            "Добавить",
                                                                            style:
                                                                            TextStyle(color: AppColor.textColor, fontSize: 18),
                                                                          ),
                                                                          Circular(key: circularKey,)
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Material(
                                                                    type: MaterialType.transparency,
                                                                    child: InkWell(
                                                                      splashColor: AppColor.unselectedBorderFieldColor.withOpacity(0.5),
                                                                      child: Ink(
                                                                        child: Container(
                                                                          height: 52,
                                                                          decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.circular(10),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      onTap: () async {
                                                                        if (await Internet.checkConnection()) {
                                                                          try{
                                                                            if(lock){
                                                                              Vibrate.vibrate();
                                                                              return;
                                                                            }
                                                                            lock = true;
                                                                            if(circularKey.currentState != null){
                                                                              circularKey.currentState.visible = true;
                                                                              circularKey.currentState.setState(() {

                                                                              });
                                                                            }
                                                                            // await Future.delayed(Duration(seconds: 2));
                                                                            ProductsDataModel cartProduct = ProductsDataModel.fromJson(productsDescription.toJson());
                                                                            bool hasErrors = false;
                                                                            cartProduct.variantGroups = new List<VariantGroup>();
                                                                            variantsSelectors.forEach((variantGroupSelector) {
                                                                              if(variantGroupSelector.key.currentState.hasSelectedVariants()){
                                                                                cartProduct.variantGroups.add(VariantGroup.fromJson(variantGroupSelector.variantGroup.toJson()));
                                                                                cartProduct.variantGroups.last.variants = variantGroupSelector.key.currentState.selectedVariants;
                                                                              } else if(variantGroupSelector.key.currentState.required) {
                                                                                hasErrors = true;
                                                                                variantGroupSelector.key.currentState.setState(() {
                                                                                  variantGroupSelector.key.currentState.error = true;
                                                                                });
                                                                              }
                                                                            });
                                                                            if(hasErrors){
                                                                              return;
                                                                            }

                                                                            if(currentUser.cartModel != null && currentUser.cartModel.items != null
                                                                                && currentUser.cartModel.items.length > 0
                                                                                && productsDescription.product.storeUuid != currentUser.cartModel.storeUuid){
                                                                              print(productsDescription.product.storeUuid.toString() + "!=" + currentUser.cartModel.storeUuid.toString());
                                                                              RestaurantScreenState.showCartClearDialog(
                                                                                  context,
                                                                                  cartProduct,
                                                                                  menuItemCounterKey,
                                                                                  this,
                                                                                  basketButtonStateKey,
                                                                                  counterKey,
                                                                                  panelController
                                                                              );
                                                                            } else {
                                                                              currentUser.cartModel = await addVariantToCart(cartProduct, necessaryDataForAuth.device_id,
                                                                                  counterKey.currentState.counter);
                                                                              Navigator.pop(context);
                                                                              menuItemCounterKey.currentState.refresh();
                                                                              setState(() {

                                                                              });

                                                                              // Добавляем паддинг в конец
                                                                              if(itemsPaddingKey.currentState != null){
                                                                                itemsPaddingKey.currentState.setState(() {

                                                                                });
                                                                              }

                                                                              showAlertDialog(context);
                                                                              if(basketButtonStateKey.currentState != null){
                                                                                basketButtonStateKey.currentState.refresh();
                                                                              }
                                                                            }
                                                                          }finally{
                                                                            if(circularKey.currentState != null){
                                                                              circularKey.currentState.visible = false;
                                                                            }
                                                                            lock = false;
                                                                          }
                                                                          AmplitudeAnalytics.analytics.logEvent('add_product ', eventProperties: {
                                                                            'uuid': restaurantDataItems.uuid
                                                                          });
                                                                        } else {
                                                                          noConnection(context);
                                                                        }
                                                                      },
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }else{
                              return Padding(
                                padding: const EdgeInsets.only(top: 40),
                                child: Container(
                                  height: 80,
                                  decoration: BoxDecoration(
                                      color: AppColor.themeColor
                                  ),
                                  child: Center(
                                    child: SpinKitFadingCircle(
                                      color: AppColor.mainColor,
                                      size: 50.0,
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          });

    }else{
      if(panelContentKey.currentState != null)
        panelContentKey.currentState.setState(() {
          panelContentKey.currentState.reset();
          panelContentKey.currentState.menuItem = this;
          panelContentKey.currentState.menuItemCounterKey = menuItemCounterKey;
        });
      panelController.open();
    }
  }

  List<VariantsSelector> getVariantGroups(ProductsDataModel productsDescription){
    List<VariantsSelector> result = new List<VariantsSelector>();
    productsDescription.variantGroups.forEach((element) {
      result.add(VariantsSelector(key: new GlobalKey<VariantsSelectorState>(), variantGroup: element,));
    });
    return result;
  }
}

