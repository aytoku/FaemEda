import 'package:flutter/material.dart';
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
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/ItemsPadding.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/ProductDescCounter.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/ProductMenu/Item.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/ProductMenu/ItemCounter.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/VariantSelector.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class PanelContent extends StatefulWidget {
  State parent;
  MenuItemState menuItem;
  GlobalKey<MenuItemCounterState> menuItemCounterKey;
  GlobalKey<ProductDescCounterState> counterKey;
  GlobalKey<CartButtonState> basketButtonStateKey;
  GlobalKey<ItemsPaddingState> itemsPaddingKey;
  GlobalKey<PanelContentState> panelContentKey;
  PanelController panelController;
  ScrollController sc;

  FilteredStores restaurant;

  PanelContent({
    key,
    this.parent,
    this.menuItem,
    this.menuItemCounterKey,
    this.restaurant,
    this.counterKey,
    this.basketButtonStateKey,
    this.itemsPaddingKey,
    this.panelContentKey,
    this.panelController,
    this.sc
  }) : super(key: key);

  @override
  PanelContentState createState() {
    return new PanelContentState(
        parent,
        menuItem,
        restaurant,
        menuItemCounterKey,
        counterKey,
        basketButtonStateKey,
        itemsPaddingKey,
        panelContentKey,
        panelController,
        sc
    );
  }
}

class PanelContentState extends State<PanelContent>{


  PanelContentState(
      this.parent,
      this.menuItem,
      this.restaurant,
      this.menuItemCounterKey,
      this.counterKey,
      this.basketButtonStateKey,
      this.itemsPaddingKey,
      this.panelContentKey,
      this.panelController,
      this.sc
      );

  State parent;
  BaseProductModel restaurantDataItems;
  MenuItemState menuItem;
  FilteredStores restaurant;
  GlobalKey<MenuItemCounterState> menuItemCounterKey;
  GlobalKey<PriceFieldState> priceFieldKey =
  new GlobalKey<PriceFieldState>();
  ProductsDataModel productsDescription;
  List<VariantsSelector> variantsSelectors;
  GlobalKey<ProductDescCounterState> counterKey;
  GlobalKey<CartButtonState> basketButtonStateKey;
  GlobalKey<ItemsPaddingState> itemsPaddingKey;
  GlobalKey<PanelContentState> panelContentKey;
  PanelController panelController;
  ScrollController sc;
  GlobalKey<CircularState> circularKey = new GlobalKey();

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
  Widget build(BuildContext context) {
    bool isScheduleAvailable = restaurant.workSchedule.isAvailable();
    //isScheduleAvailable = false;
    Standard standard = restaurant.workSchedule.getCurrentStandard();
    bool available = restaurant.available.flag != null ? restaurant.available.flag : true;
    if(menuItem == null)
      return Container(height: 200);

    restaurantDataItems = menuItem.restaurantDataItems;

    return FutureBuilder<ProductsDataModel>(
      future: getProductDescription(restaurantDataItems.uuid),
      builder: (BuildContext context,
          AsyncSnapshot<ProductsDataModel> snapshot){
        if(snapshot.connectionState == ConnectionState.done && variantsSelectors == null){
          productsDescription = snapshot.data;
          variantsSelectors = getVariantGroups(productsDescription);
        }

        if(!available || !isScheduleAvailable){
          Container(
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
                      child: FlatButton(
                        child: Text(
                          "Далее",
                          style:
                          TextStyle(color: AppColor.textColor, fontSize: 16),
                        ),
                        color: AppColor.mainColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.only(
                            left: 160, top: 20, right: 160, bottom: 20),
                        onPressed: ()async {
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
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(12),
                topRight: const Radius.circular(12),
              )
          ),
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Align(
                    alignment: Alignment.topCenter,
                    child: SvgPicture.asset('assets/svg_images/close_button.svg')),
              ),
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
                    Container(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: ListView(
                        padding: EdgeInsets.zero,
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
                                  Image.network(
                                    getImage(restaurantDataItems.image),
                                    fit: BoxFit.fill,

                                    width: MediaQuery.of(context).size.width,
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
                          (restaurantDataItems.description != "" &&
                              restaurantDataItems.description != null)
                              ? Padding(
                            padding:
                            EdgeInsets.only(left: 15, top: 20, bottom: 10),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                restaurantDataItems.description,
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 15),
                              ),
                            ),
                          )
                              : Container(
                            height: 0,
                          ),
                        ],
                      ),
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
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(top: (productsDescription.product.meta.description != "" &&
                                              productsDescription.product.meta.description != null) ? 14 : 0),
                                          child: Container(
                                            padding: EdgeInsets.only(top: 10, bottom: 10),
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
                                                      padding: const EdgeInsets.only(left: 20, right: 10, top: 10),
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
                                                    Padding(
                                                      padding: EdgeInsets.only(right: 20, top: 8),
                                                      child: PriceField(key: priceFieldKey, restaurantDataItems: restaurantDataItems),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 4.0,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(top: 10, bottom: 5),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: <Widget>[
                                                      Flexible(
                                                        flex: 1,
                                                        child: Padding(
                                                          padding: EdgeInsets.only(left: 16),
                                                          child: ProductDescCounter(
                                                              key: counterKey,
                                                              priceFieldKey: priceFieldKey
                                                          ),
                                                        ),
                                                      ),
                                                      Flexible(
                                                        flex: 2,
                                                        child: Padding(
                                                          padding: EdgeInsets.only(left: 8, right: 16),
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
      },
    );
  }

  Future<ProductsDataModel> getProductDescription(String uuid) async{
    if(productsDescription != null)
      return productsDescription;
    else
      return await getProductData(uuid);
  }

  List<VariantsSelector> getVariantGroups(ProductsDataModel productsDescription){
    List<VariantsSelector> result = new List<VariantsSelector>();
    productsDescription.variantGroups.forEach((element) {
      result.add(VariantsSelector(key: new GlobalKey<VariantsSelectorState>(), variantGroup: element,
        onTap: () {
          if(priceFieldKey.currentState != null)
            priceFieldKey.currentState.setState(() {

            });
        },
      ));
    });
    return result;
  }

  void reset(){
    menuItem = null;
    productsDescription = null;
    variantsSelectors = null;
  }
}