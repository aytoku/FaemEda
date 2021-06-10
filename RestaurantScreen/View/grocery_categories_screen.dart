import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Amplitude/amplitude.dart';
import 'package:flutter_app/Screens/CartScreen/View/cart_page_view.dart';
import 'package:flutter_app/Screens/HomeScreen/Bloc/restaurant_get_bloc.dart';
import 'package:flutter_app/Screens/HomeScreen/View/home_screen.dart';
import 'package:flutter_app/Screens/RestaurantScreen/API/didnt_find_product.dart';
import 'package:flutter_app/Screens/RestaurantScreen/API/get_products_with_categories.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Model/ProductsWithCategories.dart';
import 'package:flutter_app/Screens/RestaurantScreen/View/global_products_search_screen.dart';
import 'package:flutter_app/Screens/RestaurantScreen/View/products_search_v2.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/CartButton/CartButton.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/ItemsPadding.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/PanelContent.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/ProductDescCounter.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/ProductMenu/Item.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/ProductMenu/Title.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../data/data.dart';
import '../../../data/globalVariables.dart';
import '../../HomeScreen/Model/FilteredStores.dart';
import '../API/get_filtered_product_categories.dart';
import '../Model/FilteredProductCategories.dart';
import 'restaurant_screen.dart';

class GroceryCategoriesScreen extends StatefulWidget {

  FilteredProductCategories parentCategory;
  FilteredStores restaurant;
  int depth;
  GroceryCategoriesScreen({Key key, this.parentCategory, this.restaurant, this.depth = 1}) : super(key: key);

  @override
  GroceryCategoriesScreenState createState() {
    return new GroceryCategoriesScreenState(parentCategory, restaurant, depth);
  }
}

class GroceryCategoriesScreenState extends State<GroceryCategoriesScreen>{

  FilteredProductCategories parentCategory;
  FilteredStores restaurant;
  ProductsWithCategories productsWithCategories;
  int page = 1;
  int limit = 10;
  bool isLoading;
  ScrollController scrollController = new ScrollController();
  List<Product> products = [];
  List<MenuItem> productsWidgets = [];
  List<Category> categories = [];
  List<MenuItemTitle> categoriesWidgets = [];
  List<Widget> menuItemsWithTitles = [];

  GlobalKey<ProductDescCounterState> counterKey = new GlobalKey();
  GlobalKey<CartButtonState> basketButtonStateKey = new GlobalKey();
  GlobalKey<ItemsPaddingState> itemsPaddingKey = new GlobalKey();
  GlobalKey<PanelContentState> panelContentKey = new GlobalKey();
  ScrollController sc;
  PanelController panelController;
  int depth;
  GroceryCategoriesScreenState(this.parentCategory, this.restaurant, this.depth);


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = false;
    sc = new ScrollController();

    panelController = new PanelController();

    productController = new TextEditingController();
    // scrollController.addListener(() {
    //   print("scrollController");
    //
    //   if(!canLoadNewPage())
    //     return;
    //   if (!isLoading &&
    //       scrollController.position.pixels ==
    //           scrollController.position.maxScrollExtent) {
    //     setState(() {
    //       isLoading = true;
    //       page++;
    //     });
    //   }
    // });

  }



  List<Widget> sortProductsWidgets(){
    productsWidgets.sort((var p1, var p2){
      int p1_ind = categories.indexWhere((element) => element.uuid == p1.restaurantDataItems.productCategories[0].uuid);
      int p2_ind = categories.indexWhere((element) => element.uuid == p2.restaurantDataItems.productCategories[0].uuid);
      return p1_ind.compareTo(p2_ind);
    });
  }

  List<MenuItemTitle> generateCategoriesWidgets(List<MenuItem> products){
    List<MenuItemTitle> widgets = [];
    int lastIndex = -1;
    products.forEach((element) {
      if(lastIndex == -1 || categories[lastIndex].uuid != element.restaurantDataItems.productCategories?.first?.uuid){
        int p1_ind = categories.indexWhere((cat) => cat.uuid ==
            element.restaurantDataItems.productCategories?.first?.uuid);
        if(p1_ind != lastIndex){
          lastIndex = p1_ind;
          widgets.add(MenuItemTitle(key: GlobalKey(), title: element.restaurantDataItems.productCategories?.first?.name));
        }
      }
    });
    return widgets;
  }


  List<Widget> generateGridMenu(){
    List<Widget> widgets = (categories.isNotEmpty) ?
    RestaurantScreenState.generateMenu(productsWidgets, categoriesWidgets) : productsWidgets;

    List<Widget> result = [];
    List<Widget> tempRowChildren = [];
    for(int i = 0; i<widgets.length; i++){
      Widget widget = widgets[i];
      if(widget is MenuItem){
        tempRowChildren.add(CustomGridItem(widget));
      } else  {
        result.add(Row(children: tempRowChildren));
        result.add(
          Column(
            children: [
              widget
            ],
          )
        );
        tempRowChildren = [];
      }

      if(tempRowChildren.isNotEmpty && tempRowChildren.length % 2 == 0){
        result.add(Row(children: tempRowChildren));
        tempRowChildren  = [];
      }
    }

    if(tempRowChildren.isNotEmpty){
      result.add(Row(children: tempRowChildren));
      tempRowChildren  = [];
    }

    return result;
  }



  TextEditingController productController;
  showAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          Future.delayed(Duration(milliseconds: 2400), () {
            Navigator.of(context).pop(true);
          });
          return Center(
            child: Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(20.0)), //this right here
                child: Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text('Благодарим за отзыв!'),
                      ),
                      Lottie.asset('assets/gif/accepted.json', width: 100, height: 100, repeat: false),
                    ],
                  ),
                )
            ),
          );
        });
  }

  bool lock = false;
  _addProduct() {
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
            height: 240,
            child: _buildAddProductBottomNavigationMenu(),
            decoration: BoxDecoration(
                color: Theme
                    .of(context)
                    .canvasColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                )),
          );
        });
  }

  _buildAddProductBottomNavigationMenu() {
    return Container(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 8),
            child: Text('Что бы вы хотели?',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: 52,
                decoration: BoxDecoration(
                    color: Color(0xFFF3F3F3),
                    borderRadius: BorderRadius.circular(10)
                ),
                child: TextField(
                  autofocus: true,
                  controller: productController,
                  decoration: new InputDecoration(
                    contentPadding: EdgeInsets.only(left: 15),
                    hintText: 'Введите товар',
                    hintStyle: TextStyle(
                        color: Color(0xFF424242),
                        fontSize: 13),
                    border: InputBorder.none,
                    counterText: '',
                  ),
                )
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: InkWell(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 52,
                decoration: BoxDecoration(
                    color: AppColor.mainColor,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Center(
                  child: Text('Отправить',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16
                    ),
                  ),
                ),
              ),
              onTap: () async{
                if(lock)
                  return;
                try{
                  lock = true;
                  await didntFindProduct(productController.text);
                  Navigator.pop(context);
                  productController.clear();
                  showAlertDialog(context);
                  AmplitudeAnalytics.analytics.logEvent('send_didnt_find_on_grocery_screen');
                } catch(ex) {
                  lock = false;
                }
              },
            ),
          )
        ],)
    );
  }


  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: (Platform.isIOS) ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
      child: WillPopScope(
        child: Scaffold(
          body: FutureBuilder<ProductsWithCategories>(
            future: getProductsWithCateogies(
                restaurant.uuid,
                parentCategory.uuid,
                // page,
                // limit
            ),
            builder: (BuildContext context,
                AsyncSnapshot<ProductsWithCategories> snapshot){
              if(snapshot.hasData){
                if(snapshot.connectionState == ConnectionState.done){

                  // if(page == 1){
                  //   products.clear();
                  //   categories.clear();
                  //   categoriesWidgets.clear();
                  //   productsWidgets.clear();
                  //
                  //   categories.addAll(snapshot.data.categories.reversed);
                  //   categoriesWidgets.addAll(List<MenuItemTitle>.from(snapshot.data.categories.reversed.map((e) =>
                  //       MenuItemTitle(key: GlobalKey(),title: e.name))));
                  // }


                  categories = List.from(snapshot.data.categories);

                  products = snapshot.data.products;
                  productsWidgets = List<MenuItem>.from(snapshot.data.products.map((e) =>
                      MenuItem(
                          restaurant: restaurant,
                          restaurantDataItems: e,
                          parent: this,
                          key: new GlobalKey(),
                          counterKey: counterKey,
                          basketButtonStateKey: basketButtonStateKey,
                          panelController: panelController,
                          panelContentKey: panelContentKey,
                          itemsPaddingKey: itemsPaddingKey)
                  ));

                  sortProductsWidgets();

                  categoriesWidgets = generateCategoriesWidgets(productsWidgets);



                  menuItemsWithTitles = generateGridMenu();

                  isLoading = false;


                  // if(categories.isEmpty){
                  //   selectedCategoriesUuid = parentCategory;
                  //   return RestaurantScreen(restaurant: restaurant);
                  // }
                }

                productsWithCategories = snapshot.data;
                if(productsWithCategories.productsCount == 0){
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white
                    ),
                      child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 40, left: 15),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: InkWell(
                              hoverColor: AppColor.themeColor,
                              focusColor: AppColor.themeColor,
                              splashColor: AppColor.themeColor,
                              highlightColor: AppColor.themeColor,
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 20, bottom: 20, right: 10),
                                child: SvgPicture.asset(
                                    'assets/svg_images/arrow_left.svg'),
                              )
                          ),
                        ),
                      ),
                      Center(child: Text('В данной категории нет товаров')),
                    ],
                  ));
                }
                return Container(
                  child: Stack(
                    children: [
                      Scaffold(
                        backgroundColor: Colors.white,
                        // appBar: AppBar(
                        //   backgroundColor: Colors.white,
                        //   elevation: 0,
                        //   leading: Container(
                        //     height: 30,
                        //     width: 30,
                        //     child: InkWell(
                        //       hoverColor: AppColor.themeColor,
                        //       focusColor: AppColor.themeColor,
                        //       splashColor: AppColor.themeColor,
                        //       highlightColor: AppColor.themeColor,
                        //       onTap: () {
                        //         Navigator.pop(context);
                        //       },
                        //       child: Padding(
                        //         padding: EdgeInsets.only(
                        //             top: 20, bottom: 20, right: 10),
                        //         child: SvgPicture.asset(
                        //             'assets/svg_images/arrow_left.svg'),
                        //       )
                        //     ),
                        //   ),
                        //   title: Text(parentCategory.name,
                        //     textAlign: TextAlign.center,
                        //     style: TextStyle(
                        //         fontSize: 18,
                        //         color: Color(0xFF3F3F3F)),
                        //   ),
                        // ),
                        body: Stack(
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
                                          onTap: () {
                                            if(depth == 1){
                                              homeScreenKey = new GlobalKey<HomeScreenState>();
                                              Navigator.of(context).pushAndRemoveUntil(
                                                  new MaterialPageRoute(
                                                    builder: (context) => BlocProvider(
                                                      create: (context) => RestaurantGetBloc(),
                                                      child: new HomeScreen(),
                                                    ),
                                                  ), (Route<dynamic> route) => false);
                                            }else{
                                              Navigator.pop(context);
                                            }
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                top: 20, bottom: 20,),
                                            child: SvgPicture.asset(
                                                'assets/svg_images/arrow_left.svg'),
                                          )
                                      ),
                                    ),
                                    Text(parentCategory.name,
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Color(0xFF3F3F3F)),
                                    ),
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
                                          AmplitudeAnalytics.analytics.logEvent('search_into_category');
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
                              padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top + 2 * 20 + 16),
                              child: Container(
                                height: MediaQuery.of(context).size.height * 0.88,
                                child: ListView(
                                    controller: scrollController,
                                    physics: BouncingScrollPhysics(),
                                    padding: const EdgeInsets.only(top: 0),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 15),
                                        child: Wrap(
                                          children: List.generate(categories.length, (index){
                                            return Padding(
                                              padding: EdgeInsets.only(top: 4, bottom: 4,
                                                  right: (categories[index].name == categories.last.name) ? 15 : 8),
                                              child: InkWell(
                                                child: Container(
                                                  height: 35,
                                                  padding: const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(15),
                                                      color: Color(0xFFE6E6E6)
                                                  ),
                                                  child: Text(categories[index].name,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                                onTap: () async{
                                                  await Navigator.push(context,
                                                      MaterialPageRoute(builder: (context)=> GroceryCategoriesScreen(
                                                          restaurant: restaurant,
                                                          parentCategory: categories[index],
                                                          depth: depth+1,
                                                      ))
                                                  );
                                                  AmplitudeAnalytics.analytics.logEvent('open_sub_category ', eventProperties: {
                                                    'uuid': categories[index].uuid
                                                  });
                                                  setState(() {

                                                  });
                                                },
                                              ),
                                            );
                                          }),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 20),
                                        child: Column(
                                            children: menuItemsWithTitles
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(top: 15, bottom: 0),
                                            child: Text('Не нашли что искали?',
                                              style: TextStyle(
                                                  fontSize: 16
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 20, right: 20, top: 15),
                                            child: InkWell(
                                              child: Container(
                                                width: MediaQuery.of(context).size.width,
                                                height: 52,
                                                decoration: BoxDecoration(
                                                    color: Color(0xFFF3F3F3),
                                                    borderRadius: BorderRadius.circular(10)
                                                ),
                                                child: Center(
                                                  child: Text('Введите название товара',
                                                    style: TextStyle(
                                                        color: Color(0xFF424242)
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              onTap: (){
                                                _addProduct();
                                                AmplitudeAnalytics.analytics.logEvent('open_didnt_find_on_grocery_screen');
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      ItemsPadding(key: itemsPaddingKey,),
                                      (canLoadNewPage()) ? Center(
                                        child: SpinKitFadingCircle(
                                          color: AppColor.mainColor,
                                          size: 50.0,
                                        ),
                                      ) : Container()
                                    ]
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding:  EdgeInsets.only(bottom: 0),
                                child: CartButton(
                                  key: basketButtonStateKey,
                                  restaurant: restaurant,
                                  source: CartSources.Other,),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SlidingUpPanel(
                        backdropEnabled: true,
                        controller: panelController,
                        color: Colors.transparent,
                        minHeight: 0,
                        maxHeight: MediaQuery.of(context).size.height * 0.9,
                        isDraggable: true,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        panelBuilder: (sc) {
                          this.sc = sc;
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.9,
                            child: Stack(
                              children: [
                                Align(
                                    alignment: Alignment.topCenter,
                                    child: SvgPicture.asset('assets/svg_images/close_button.svg')),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Container( height: MediaQuery.of(context).size.height * 0.7,
                                      decoration: BoxDecoration(
                                        color: AppColor.themeColor,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(12),
                                          topRight: Radius.circular(12),
                                        ),),
                                      child: PanelContent(
                                          key: panelContentKey,
                                          parent: this,
                                          panelController: panelController,
                                          panelContentKey: panelContentKey,
                                          itemsPaddingKey: itemsPaddingKey,
                                          counterKey: counterKey,
                                          basketButtonStateKey: basketButtonStateKey,
                                          restaurant: restaurant,
                                          sc: sc
                                      )),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              }else{
                return Center(
                  child: SpinKitFadingCircle(
                    color: AppColor.mainColor,
                    size: 50.0,
                  ),
                );
              }
            },
          ),
        ),
        onWillPop: () async{
          if(depth == 1){
            homeScreenKey = new GlobalKey<HomeScreenState>();
            Navigator.of(context).pushAndRemoveUntil(
                new MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => RestaurantGetBloc(),
                    child: new HomeScreen(),
                  ),
                ), (Route<dynamic> route) => false);
          }else{
            Navigator.pop(context);
          }
          return false;
        },
      ),
    );
  }

  bool canLoadNewPage(){
    return false;
    return products == null || products.length<productsWithCategories.productsCount;
  }
}



class CustomGridItem extends StatelessWidget{

  Widget child;
  CustomGridItem(this.child);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: Color(0xFFE6E6E6), width: 0.1)
        ),
        height: 280,
        width: MediaQuery.of(context).size.width * 0.5,
        child: child
    );
  }
}
