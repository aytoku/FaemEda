import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Amplitude/amplitude.dart';
import 'package:flutter_app/Internet/check_internet.dart';
import 'package:flutter_app/Screens/CartScreen/View/cart_page_view.dart';
import 'package:flutter_app/Screens/RestaurantScreen/API/didnt_find_product.dart';
import 'package:flutter_app/Screens/RestaurantScreen/API/get_products_with_categories.dart';
import 'package:flutter_app/Screens/RestaurantScreen/API/search_products_v2.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Model/ProductsWithCategories.dart';
import 'package:flutter_app/Screens/RestaurantScreen/View/global_products_search_screen.dart';
import 'package:flutter_app/Screens/RestaurantScreen/View/grocery_categories_screen.dart';
import 'package:flutter_app/Screens/RestaurantScreen/View/restaurant_products_search_screen.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/CartButton/CartButton.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/ItemsPadding.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/PanelContent.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/ProductDescCounter.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/ProductMenu/Item.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/ProductMenu/Title.dart';
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


class ProductsSearchV2Screen extends StatefulWidget {


  FilteredStores restaurant;
  ProductsSearchV2Screen({Key key, this.restaurant});

  @override
  ProductsSearchV2ScreenState createState() => ProductsSearchV2ScreenState(
      restaurant,
  );
}

class ProductsSearchV2ScreenState extends State<ProductsSearchV2Screen> {

  TextEditingController controller = new TextEditingController();
  GlobalKey<ProductsSearchV2BodyState> key = new GlobalKey();
  GlobalKey<CartButtonState> basketButtonStateKey;
  GlobalKey<ItemsPaddingState> itemsPaddingKey;
  GlobalKey<PanelContentState> panelContentKey;
  GlobalKey<ProductDescCounterState> counterKey;
  PanelController panelController;
  FilteredStores restaurant;
  ScrollController sc;

  ProductsSearchV2ScreenState(
      this.restaurant,
      );

  @override
  initState() {
    super.initState();
    key = new GlobalKey<ProductsSearchV2BodyState>();
    basketButtonStateKey = new GlobalKey();
    itemsPaddingKey = new GlobalKey();
    counterKey = new GlobalKey();
    panelController = new PanelController();
    panelContentKey = new GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
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
            height: MediaQuery.of(context).size.height * 0.7,
            child: Stack(
              children: [
                Align(
                    alignment: Alignment.topCenter,
                    child: SvgPicture.asset('assets/svg_images/close_button.svg')),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container( height: MediaQuery.of(context).size.height * 0.9,
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
        body: Container(
          color: Colors.white,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                          hoverColor: Colors.white,
                          focusColor: Colors.white,
                          splashColor: Colors.white,
                          highlightColor: Colors.white,
                          onTap: () async {
                            if(await Internet.checkConnection()){
                              Navigator.pop(context);
                            }else{
                              noConnection(context);
                            }
                          },
                          child: Container(
                              height: 40,
                              width: 60,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 12, bottom: 12, right: 10, left: 0),
                                child: SvgPicture.asset(
                                    'assets/svg_images/arrow_left.svg'),
                              ))),
                      Expanded(
                        child: TextField(
                          controller: controller,
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.start,
                          cursorColor: Colors.black,
                          decoration: new InputDecoration(
                            border: InputBorder.none,
                            counterText: '',
                            hintStyle: TextStyle(
                              color: Color(0xFFC0BFC6),
                            ),
                            hintText: 'Поиск',
                          ),
                          onChanged: (text){
                            key.currentState.setState(() {
                              key.currentState.text = text;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: InkWell(
                          child: Container(
                            child: SvgPicture.asset('assets/svg_images/search_cross.svg'),
                          ),
                          onTap: (){
                            controller.clear();
                            key.currentState.text = '';
                            key.currentState.setState(() {

                            });
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 80),
                  child: ProductsSearchV2Body(
                    key: key,
                    restaurant: restaurant,
                    panelController: panelController,
                    panelContentKey: panelContentKey,
                    text: controller.text,
                  )),
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
      ),
    );
  }
}


class ProductsSearchV2Body extends StatefulWidget {

  FilteredStores restaurant;
  String text;
  PanelController panelController;
  GlobalKey<PanelContentState> panelContentKey;
  ProductsSearchV2Body({Key key, this.restaurant, this.text, this.panelController, this.panelContentKey}) : super(key: key);

  @override
  ProductsSearchV2BodyState createState() {
    return new ProductsSearchV2BodyState(restaurant, text, panelController, panelContentKey);
  }
}

class ProductsSearchV2BodyState extends State<ProductsSearchV2Body>{

  FilteredStores restaurant;
  PanelController panelController;
  GlobalKey<PanelContentState> panelContentKey;
  ProductsWithCategories productsWithCategories;

  String text;


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
  ScrollController sc;
  TextEditingController productController;
  ProductsSearchV2BodyState(this.restaurant, this.text, this.panelController, this.panelContentKey);


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = false;
    sc = new ScrollController();
    productController = new TextEditingController();
  }


  showAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          Future.delayed(Duration(milliseconds: 2400), () {
            lock = false;
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
                  AmplitudeAnalytics.analytics.logEvent('send_didnt_find_in_search');
                } catch(ex) {
                  lock = false;
                }
              },
            ),
          )
        ],)
    );
  }



  List<Widget> sortProductsWidgets(){
    productsWidgets.sort((var p1, var p2){
      int p1_ind = categories.indexWhere((element) => element.uuid == p1.restaurantDataItems.productCategories[0].uuid);
      int p2_ind = categories.indexWhere((element) => element.uuid == p2.restaurantDataItems.productCategories[0].uuid);
      return p1_ind.compareTo(p2_ind);
    });
  }

  List<MenuItemTitle> generateCategoriesWidgets(List<Product> products){
    List<MenuItemTitle> widgets = [];
    int lastIndex = -1;
    products.forEach((element) {
      if(lastIndex == -1 || categories[lastIndex].uuid != element.productCategoriesUuid?.first){
        int p1_ind = categories.indexWhere((cat) => cat.uuid ==
            element.productCategories[0].uuid);
        if(p1_ind != lastIndex){
          lastIndex = p1_ind;
          widgets.add(MenuItemTitle(key: GlobalKey(), title: element.productCategories[0].name,));
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
        tempRowChildren.add(SearchCustomGridItem(widget));
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
  @override
  Widget build(BuildContext context) {

    return Container(
      child: FutureBuilder<ProductsWithCategories>(
        future: searchProductsV2(
            restaurant.uuid,
            text
        ),
        builder: (BuildContext context,
            AsyncSnapshot<ProductsWithCategories> snapshot){
          if(snapshot.hasData){
            if(snapshot.connectionState == ConnectionState.done){

              categories = List.from(snapshot.data.categories);

              products = snapshot.data.products;

              // categoriesWidgets = generateCategoriesWidgets(products);


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

              menuItemsWithTitles = generateGridMenu();
            }

            productsWithCategories = snapshot.data;
            if(productsWithCategories.products.length == 0){
              return Center(
                child: Column(
                  children: [
                    Lottie.asset('assets/gif/empty.json', width: 150, height: 150),
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
                          AmplitudeAnalytics.analytics.logEvent('open_didnt_find_in_search');
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
            return Container(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.88,
                      child: ListView(
                          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                          controller: scrollController,
                          physics: BouncingScrollPhysics(),
                          padding: const EdgeInsets.only(top: 0),
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Wrap(
                                children: List.generate(categories.length, (index){
                                  return GestureDetector(
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 4, bottom: 4,
                                          right: (categories[index].name == categories.last.name) ? 15 : 8),
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
                                    ),
                                    onTap: () async{
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context)=> GroceryCategoriesScreen(
                                            parentCategory: categories[index],
                                            restaurant: restaurant,
                                          ))
                                      );
                                    },
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
                ],
              )
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
    );
  }

  bool canLoadNewPage(){
    return products == null || products.length<productsWithCategories.productsCount;
  }
}



class SearchCustomGridItem extends StatelessWidget{

  Widget child;
  SearchCustomGridItem(this.child);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: Color(0xFFE6E6E6), width: 0.1)
        ),
        height: 250,
        width: MediaQuery.of(context).size.width * 0.5,
        child: child
    );
  }
}