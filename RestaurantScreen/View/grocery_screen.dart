import 'dart:io';

import 'package:animated_widgets/widgets/translation_animated.dart';
import 'package:bouncing_widget/bouncing_widget.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Amplitude/amplitude.dart';
import 'package:flutter_app/Internet/check_internet.dart';
import 'package:flutter_app/Screens/HomeScreen/Bloc/restaurant_get_bloc.dart';
import 'package:flutter_app/Screens/HomeScreen/Model/FilteredStores.dart';
import 'package:flutter_app/Screens/HomeScreen/View/home_screen.dart';
import 'package:flutter_app/Screens/RestaurantScreen/View/grocery_categories_screen.dart';
import 'package:flutter_app/Screens/RestaurantScreen/View/products_search_v2.dart';
import 'package:flutter_app/Screens/RestaurantScreen/View/restaurant_products_search_screen.dart';
import 'package:flutter_app/Screens/RestaurantScreen/View/restaurant_screen.dart';
import 'package:flutter_app/Screens/RestaurantScreen/View/restaurant_screen.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/CartButton/CartButton.dart';
import 'package:flutter_app/Screens/CartScreen/View/cart_page_view.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/FadeAnimation.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/ProductCategories/CategoryList.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/ProductMenu/Title.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/SliverTitleItems/SliverBackButton.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/SliverTitleItems/SliverShadow.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/SliverTitleItems/SliverText.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/ItemsPadding.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Model/FilteredProductCategories.dart';
import 'package:flutter_app/Screens/RestaurantScreen/API/get_filtered_product_categories.dart';
import 'package:show_up_animation/show_up_animation.dart';

class GroceryScreen extends StatefulWidget {
  GroceryScreen({this.key, this.restaurant}) : super(key: key);
  final GlobalKey<GroceryScreenState> key;
  FilteredStores restaurant;

  @override
  GroceryScreenState createState() {
    return new GroceryScreenState(restaurant);
  }
}

class GroceryScreenState extends State<GroceryScreen> {
  FilteredStores restaurant;
  CategoryList categoryList;
  String parentUuid;
  ScrollController sliverScrollController = new ScrollController();
  GlobalKey<CartButtonState> basketButtonStateKey;
  GlobalKey<SliverShadowState> sliverShadowKey;
  GlobalKey<ItemsPaddingState> itemsPaddingKey;
  int page = 1;
  int limit = 10;
  bool isLoading;
  List<FilteredProductCategories> filteredProductCategoriesList = [];

  GroceryScreenState(this.restaurant);

  @override
  void initState() {
    super.initState();
    sliverShadowKey = new GlobalKey();
    itemsPaddingKey = GlobalKey();
  }

  _restInfo() {
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
            height: 300,
            child: _buildRestInfoNavigationMenu(),
            decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                )),
          );
        });
  }

  _buildRestInfoNavigationMenu() {
//    DateTime now = DateTime.now();
//    int currentTime = now.hour*60+now.minute;
//    int dayNumber  = now.weekday-1;
//    int work_ending = restaurant.work_schedule[dayNumber].work_ending;
    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20, top: 30),
            child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  restaurant.name,
                  style: TextStyle(color: Color(0xFF424242), fontSize: 21, fontWeight: FontWeight.bold),
                )),
          ),
          // Padding(
          //   padding: EdgeInsets.only(left: 20, top: 20),
          //   child: Align(
          //       alignment: Alignment.topLeft,
          //       child: Text('Адрес',
          //         style: TextStyle(
          //             color: AppColor.additionalTextColor,
          //             fontSize: 14
          //         ),
          //       )
          //   ),
          // ),
          // Padding(
          //   padding: EdgeInsets.only(left: 20, top: 10),
          //   child: Align(
          //       alignment: Alignment.topLeft,
          //       child: Text(restaurant.address.unrestrictedValue,
          //         style: TextStyle(
          //             fontSize: 14
          //         ),
          //       )
          //   ),
          // ),
          Padding(
            padding: EdgeInsets.only(left: 20, top: 20),
            child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Время доставки",
                  style: TextStyle(color: AppColor.additionalTextColor, fontSize: 14),
                )),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, top: 10),
            child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  '${restaurant.meta.avgDeliveryTime}',
                  style: TextStyle(fontSize: 14),
                )),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, top: 20),
            child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Кухни',
                  style: TextStyle(color: AppColor.additionalTextColor, fontSize: 14),
                )),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, top: 10),
            child: Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: List.generate(restaurant.storeCategoriesUuid.length, (index) {
                    return Text(restaurant.storeCategoriesUuid[index].name + ' ');
                  }),
                )),
          )
        ],
      ),
    );
  }

  bool get _isAppBarExpanded {
    return sliverScrollController.hasClients && sliverScrollController.offset > 90;
  }

  List<Widget> getSliverChildren() {
    List<Widget> result = new List<Widget>();
    result.add(PaginationScreen(
      restaurant: restaurant,
      sliverScrollController: sliverScrollController,
    ));
    return result;
  }

  Widget _buildRestaurantScreen() {
    // генерим список еды и названий категория

    List<Widget> sliverChildren = getSliverChildren();
    GlobalKey<SliverTextState> sliverTextKey = new GlobalKey();
    GlobalKey<SliverBackButtonState> sliverImageKey = new GlobalKey();

    // замена кастомной кнопки на кнопку и текст аппбара
    sliverScrollController.addListener(() async {
      if (sliverTextKey.currentState != null && sliverScrollController.offset > 89) {
        sliverTextKey.currentState.setState(() {
          sliverTextKey.currentState.title = new Text(
            this.restaurant.name,
            style: TextStyle(color: Colors.black),
          );
        });
      } else {
        if (sliverTextKey.currentState != null) {
          sliverTextKey.currentState.setState(() {
            sliverTextKey.currentState.title = new Text('');
          });
        }
      }
      if (sliverImageKey.currentState != null && sliverScrollController.offset > 89) {
        sliverImageKey.currentState.setState(() {
          sliverImageKey.currentState.image = new SvgPicture.asset('assets/svg_images/arrow_left.svg');
        });
      } else {
        if (sliverImageKey.currentState != null) {
          sliverImageKey.currentState.setState(() {
            sliverImageKey.currentState.image = null;
          });
        }
      }
      if (sliverShadowKey.currentState != null && sliverScrollController.offset > 180) {
        sliverShadowKey.currentState.setState(() {
          sliverShadowKey.currentState.showShadow = true;
        });
      } else {
        if (sliverShadowKey.currentState != null) {
          sliverShadowKey.currentState.setState(() {
            sliverShadowKey.currentState.showShadow = false;
          });
        }
      }
    });
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        backgroundColor: AppColor.themeColor,
        body: Stack(
          children: [
            Image.network(
              getImage((restaurant.meta.images != null && restaurant.meta.images.length > 0) ? restaurant.meta.images[0] : ''),
              fit: BoxFit.cover,
              height: 230.0,
              width: MediaQuery.of(context).size.width,
            ),
            CustomScrollView(
              physics: BouncingScrollPhysics(),
              anchor: 0.01,
              controller: sliverScrollController,
              slivers: [
                SliverAppBar(
                  brightness: _isAppBarExpanded ? Brightness.dark : Brightness.light,
                  expandedHeight: 100.0,
                  floating: false,
                  pinned: true,
                  snap: false,
                  stretch: true,
                  elevation: 0,
                  backgroundColor: AppColor.themeColor,
                  leading: InkWell(
                    hoverColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Container(
                      height: 40,
                      width: 60,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 20, right: 10),
                        child: SliverBackButton(
                          key: sliverImageKey,
                          image: null,
                        ),
                      ),
                    ),
                    onTap: () async {
                      homeScreenKey = new GlobalKey<HomeScreenState>();
                      if (await Internet.checkConnection()) {
                        Navigator.of(context).pushAndRemoveUntil(
                            PageRouteBuilder(
                                pageBuilder: (context, animation, anotherAnimation) {
                                  return BlocProvider(
                                    create: (context) => RestaurantGetBloc(),
                                    child: new HomeScreen(),
                                  );
                                },
                                transitionDuration: Duration(milliseconds: 300),
                                transitionsBuilder: (context, animation, anotherAnimation, child) {
                                  return SlideTransition(
                                    position: Tween(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0)).animate(animation),
                                    child: child,
                                  );
                                }),
                                (Route<dynamic> route) => false);
                      } else {
                        noConnection(context);
                      }
                    },
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: SliverText(
                      title: Text(
                        '',
                        style: TextStyle(fontSize: 18),
                      ),
                      key: sliverTextKey,
                    ),
                    background: AnnotatedRegion<SystemUiOverlayStyle>(
                      value: (Platform.isIOS)
                          ? _isAppBarExpanded
                          ? SystemUiOverlayStyle.dark
                          : SystemUiOverlayStyle.light
                          : SystemUiOverlayStyle.dark,
                      child: ClipRRect(
                          child: Stack(
                            children: <Widget>[
                              Center(
                                  child: Image.asset(
                                    'assets/images/food.png',
                                    fit: BoxFit.cover,
                                  )),
                              Image.network(
                                getImage((restaurant.meta.images != null && restaurant.meta.images.length > 0) ? restaurant.meta.images[0] : ''),
                                fit: BoxFit.cover,
                                height: 500.0,
                                alignment: Alignment.topCenter,
                                width: MediaQuery.of(context).size.width,
                              ),
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 40, left: 15),
                                    child: GestureDetector(
                                      child: SvgPicture.asset('assets/svg_images/fermer_arrow_left.svg'),
                                      onTap: () async {
                                        if (await Internet.checkConnection()) {
                                          homeScreenKey = new GlobalKey<HomeScreenState>();
                                          Navigator.of(context).pushAndRemoveUntil(
                                              PageRouteBuilder(
                                                  pageBuilder: (context, animation, anotherAnimation) {
                                                    return BlocProvider(
                                                      create: (context) => RestaurantGetBloc(),
                                                      child: new HomeScreen(),
                                                    );
                                                  },
                                                  transitionDuration: Duration(milliseconds: 300),
                                                  transitionsBuilder: (context, animation, anotherAnimation, child) {
                                                    return SlideTransition(
                                                      position: Tween(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0)).animate(animation),
                                                      child: child,
                                                    );
                                                  }),
                                                  (Route<dynamic> route) => false);
                                        } else {
                                          noConnection(context);
                                        }
                                      },
                                    ),
                                  )),
                            ],
                          )),
                    ),
                  ),
                ),
                SliverStickyHeader(
                  sticky: false,
                  header: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.themeColor,
                          offset: Offset(0, 5),
                          blurRadius: 4,
                          spreadRadius: 2,
                        )
                      ],
                      border: Border.all(color: Colors.white, width: 4),
                      color: AppColor.themeColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                          child: FadeOnScroll(
                            scrollController: sliverScrollController,
                            fullOpacityOffset: 110,
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 15),
                                  child: Text(
                                    this.restaurant.name,
                                    style: TextStyle(fontSize: 24, color: Color(0xFF3F3F3F)),
                                  ),
                                ),
                                InkWell(
                                  hoverColor: AppColor.themeColor,
                                  focusColor: Colors.white,
                                  splashColor: Colors.white,
                                  highlightColor: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 3.0),
                                    child: SvgPicture.asset('assets/svg_images/rest_info.svg'),
                                  ),
                                  onTap: () {
                                    _restInfo();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            // Padding(
                            //   padding: const EdgeInsets.only(left: 15),
                            //   child: Container(
                            //     height: 26,
                            //     decoration: BoxDecoration(
                            //         borderRadius: BorderRadius.circular(10),
                            //         color: Color(0xFFEFEFEF)
                            //     ),
                            //     child: Center(
                            //       child: Padding(
                            //         padding: EdgeInsets.only(top: 5, bottom: 5, right: 10, left: 10),
                            //         child: Row(
                            //           children: [
                            //             SvgPicture.asset('assets/svg_images/star.svg',
                            //             ),
                            //             Padding(
                            //               padding: const EdgeInsets.only(left: 5),
                            //               child: Text(restaurant.meta.rating.toString(),
                            //                 style: TextStyle(
                            //                 ),
                            //               ),
                            //             )
                            //           ],
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: Container(
                                height: 26,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color(0xFFEFEFEF)),
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(right: 5),
                                          child: SvgPicture.asset(
                                            'assets/svg_images/rest_car.svg',
                                          ),
                                        ),
                                        Text(
                                          '~' + '${restaurant.meta.avgDeliveryTime}',
                                          style: TextStyle(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 16, right: 15),
                              child: Container(
                                height: 26,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color(0xFFEFEFEF)),
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                                    child: Text(
                                      '${restaurant.meta.avgDeliveryPrice}',
                                      style: TextStyle(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: 30, left: 15),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Категории',
                                style: TextStyle(fontSize: 24),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
                SliverStickyHeader(
                    sticky: true,
                    header: Container(),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          return TranslationAnimatedWidget(
                            enabled: true,
                            values: [
                              Offset(0, 200), // disabled value value
                              Offset(0, 100), //intermediate value
                              Offset(0, 0) //enabled value
                            ],
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 40),
                              child: Container(
                                decoration: BoxDecoration(boxShadow: [
                                  BoxShadow(
                                    color: Colors.white,
                                    offset: Offset(0, 0),
                                    blurRadius: 4,
                                    spreadRadius: 2,
                                  )
                                ], border: Border.all(color: Colors.white, width: 4), color: AppColor.themeColor),
                                child: Column(
                                  children: [
                                    Column(
                                      children: sliverChildren,
                                    ),
                                    ItemsPadding(
                                      key: itemsPaddingKey,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        childCount: 1,
                      ),
                    ))
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 0),
                child: CartButton(
                  key: basketButtonStateKey,
                  restaurant: restaurant,
                  source: CartSources.Restaurant,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.black));
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 20, right: 20),
      child: PaginationScreen(
        restaurant: restaurant,
        sliverScrollController: sliverScrollController,
      ),
    );

    /*return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top, left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 40,
                      child: InkWell(
                          hoverColor: AppColor.themeColor,
                          focusColor: AppColor.themeColor,
                          splashColor: AppColor.themeColor,
                          highlightColor: AppColor.themeColor,
                          onTap: () async {
                            if(await Internet.checkConnection()){
                              homeScreenKey = new GlobalKey<HomeScreenState>();
                              Navigator.of(context).pushAndRemoveUntil(
                                  PageRouteBuilder(
                                      pageBuilder: (context, animation, anotherAnimation) {
                                        return BlocProvider(
                                          create: (context) => RestaurantGetBloc(),
                                          child: new HomeScreen(),
                                        );
                                      },
                                      transitionDuration: Duration(milliseconds: 300),
                                      transitionsBuilder:
                                          (context, animation, anotherAnimation, child) {
                                        return SlideTransition(
                                          position: Tween(
                                              begin: Offset(1.0, 0.0),
                                              end: Offset(0.0, 0.0))
                                              .animate(animation),
                                          child: child,
                                        );
                                      }
                                  ), (Route<dynamic> route) => false);
                            }else{
                              noConnection(context);
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 20, bottom: 20),
                            child: SvgPicture.asset(
                                'assets/svg_images/arrow_left.svg'),
                          )
                      ),
                    ),
                    Text(restaurant.name, style: TextStyle(fontSize: 18, color: Color(0xFF3F3F3F)), textAlign: TextAlign.center,),
                    Container(
                      width: 40,
                      child: InkWell(
                        child: Container(
                          height: 40, width: 40,
                          padding: EdgeInsets.all(6),
                          child: SvgPicture.asset(
                            'assets/svg_images/search.svg',
                            color: Colors.black,),
                        ),
                        onTap: (){
                          AmplitudeAnalytics.analytics.logEvent('open_product_search');
                          Navigator.push(
                            context,
                            new MaterialPageRoute(
                              builder: (context) =>
                              new ProductsSearchV2Screen(
                                restaurant: restaurant
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top + 2 * 20 + 16, left: 15, right: 15),
              child: PaginationScreen(restaurant: restaurant, sliverScrollController: sliverScrollController,),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding:  EdgeInsets.only(bottom: 0),
                child: CartButton(
                  key: basketButtonStateKey, restaurant: restaurant, source: CartSources.Other,),
              ),
            )
          ],
        )
      ),
    );*/
  }
}

class PaginationScreen extends StatefulWidget {
  FilteredStores restaurant;
  ScrollController sliverScrollController;

  PaginationScreen({Key key, this.restaurant, this.sliverScrollController}) : super(key: key);

  @override
  PaginationScreenState createState() {
    return new PaginationScreenState(restaurant, sliverScrollController);
  }
}

class PaginationScreenState extends State<PaginationScreen> {
  FilteredStores restaurant;
  CategoryList categoryList;
  String parentUuid;
  ScrollController sliverScrollController;

  int page = 1;
  int limit = 100;
  bool isLoading;
  List<FilteredProductCategories> filteredProductCategoriesList = [];

  PaginationScreenState(this.restaurant, this.sliverScrollController);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = false;
    sliverScrollController.addListener(() {
      if (!isLoading && sliverScrollController.position.pixels >= sliverScrollController.position.maxScrollExtent - 15) {
        setState(() {
          isLoading = true;
          page++;
        });
      }
    });
  }

  List<Widget> generateGridMenu() {
    //filteredProductCategoriesList
    List<Widget> result = [];
    List<Widget> tempRowChildren = [];
    for (int index = 0; index < filteredProductCategoriesList.length; index++) {
      FilteredProductCategories cat = filteredProductCategoriesList[index];

      tempRowChildren.add(CustomGridItem(
        Container(
          height: MediaQuery.of(context).size.width / 2 - 20,
          width: MediaQuery.of(context).size.width / 2 - 20,
          decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(12)),
          child: FlatButton(
            child: Container(
              child: Stack(
                children: [
                  Image.network(
                    (cat.meta.images != null && cat.meta.images[0] != null) ? cat.meta.images[0] : '',
                    fit: BoxFit.cover,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        cat.name,
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 18, color: Color(0xFF404040), fontWeight: FontWeight.w700),
                      ),
                    ),
                  )
                ],
              ),
            ),
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) {
                  return GroceryCategoriesScreen(restaurant: restaurant, parentCategory: cat);
                }),
              );
            },
          ),
        ),
      ));

      if (tempRowChildren.isNotEmpty && tempRowChildren.length % 2 == 0) {
        result.add(Row(children: tempRowChildren));
        tempRowChildren = [];
      }
    }

    if (tempRowChildren.isNotEmpty) {
      result.add(Row(children: tempRowChildren));
      tempRowChildren = [];
    }

    return result;
  }

  GlobalKey<ItemsPaddingState> itemsPaddingKey;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Категории',
          style: TextStyle(color: Color(0xFF404040), fontSize: 24, fontWeight: FontWeight.w700),
        ),
        SizedBox(
          height: 15,
        ),
        FutureBuilder<FilteredProductCategoriesData>(
          future: getFilteredProductCategories(
            restaurant.uuid,
            parentUuid,
            '988a1afb-f5a0-475f-9927-bcbc5fc04e09',
            page,
            limit,
          ),
          builder: (BuildContext context, AsyncSnapshot<FilteredProductCategoriesData> snapshot) {
            print(snapshot.data);
            if (snapshot.hasData) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (page == 1) filteredProductCategoriesList.clear();

                filteredProductCategoriesList.addAll(snapshot.data.filteredProductCategories);

                if (filteredProductCategoriesList.isEmpty) {
                  isLoading = false;
                  return Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.4),
                    child: Center(child: Text('Ничего не найдено')),
                  );
                }
                isLoading = false;
              }
              if (filteredProductCategoriesList.isNotEmpty) {
                // List<Widget> widgets = generateGridMenu();
                // return ListView(
                //     physics: NeverScrollableScrollPhysics(),
                //   children:  List.generate(widgets.length, (index){
                //     return widgets[index];
                //   }
                // ));
                return StaggeredGridView.countBuilder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.only(bottom: 50),
                  crossAxisCount: 2,
                  controller: sliverScrollController,
                  itemCount: filteredProductCategoriesList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                      child: Bounce(
                        duration: Duration(milliseconds: 100),
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(color: Color(0xFFF8F8F8), borderRadius: BorderRadius.circular(10)),
                            ),
                            ShowUpAnimation(
                              delayStart: Duration(seconds: 1),
                              animationDuration: Duration(seconds: 1),
                              curve: Curves.bounceIn,
                              direction: Direction.vertical,
                              offset: 0.5,
                              child: Container(
                                height: MediaQuery.of(context).size.height / 2,
                                width: MediaQuery.of(context).size.width / 2,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    (filteredProductCategoriesList[index].meta.images != null && filteredProductCategoriesList[index].meta.images[0] != null)
                                        ? filteredProductCategoriesList[index].meta.images[0]
                                        : '',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                filteredProductCategoriesList[index].name,
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) {
                              return GroceryCategoriesScreen(restaurant: restaurant, parentCategory: filteredProductCategoriesList[index]);
                            }),
                          );
                          AmplitudeAnalytics.analytics.logEvent('open_category ', eventProperties: {
                            'uuid': filteredProductCategoriesList[index].uuid
                          });
                        },
                      ),
                    );
                  },
                  staggeredTileBuilder: (int index) {
                    return StaggeredTile.extent(1, MediaQuery.of(context).size.width / 2 - 20);
                  },
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                );
              } else {
                return Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 2),
                  child: Center(
                    child: SpinKitFadingCircle(
                      color: AppColor.mainColor,
                      size: 50.0,
                    ),
                  ),
                );
              }
            } else {
              return Container();
            }
          },
        ),
      ],
    );
  }
}
