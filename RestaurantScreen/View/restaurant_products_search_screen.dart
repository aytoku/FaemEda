import 'package:flutter/material.dart';
import 'package:flutter_app/Internet/check_internet.dart';
import 'package:flutter_app/Screens/CartScreen/View/cart_page_view.dart';
import 'package:flutter_app/Screens/HomeScreen/API/getStoreByUuid.dart';
import 'package:flutter_app/Screens/HomeScreen/Model/FilteredStores.dart';
import 'package:flutter_app/Screens/RestaurantScreen/API/search_products.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Model/SearchProductModel.dart';
import 'package:flutter_app/Screens/RestaurantScreen/View/restaurant_screen.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/CartButton/CartButton.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/ItemsPadding.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/PanelContent.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/ProductDescCounter.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/ProductMenu/Item.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/ProductMenu/Title.dart';
import 'package:flutter_app/app.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class RestaurantProductsSearchScreen extends StatefulWidget {


  List<Widget> menuWithTitles;
  FilteredStores restaurant;
  RestaurantProductsSearchScreen({Key key, this.menuWithTitles, this.restaurant});

  @override
  RestaurantProductsSearchScreenState createState() => RestaurantProductsSearchScreenState(
    menuWithTitles,
    restaurant
  );
}

class RestaurantProductsSearchScreenState extends State<RestaurantProductsSearchScreen> {

  TextEditingController controller = new TextEditingController();
  GlobalKey<RestaurantSearchProductsContentState> key = new GlobalKey();
  GlobalKey<CartButtonState> basketButtonStateKey;
  GlobalKey<ItemsPaddingState> itemsPaddingKey;
  GlobalKey<PanelContentState> panelContentKey;
  GlobalKey<ProductDescCounterState> counterKey;
  PanelController panelController;
  List<Widget> menuWithTitles;
  FilteredStores restaurant;
  ScrollController sc;

  RestaurantProductsSearchScreenState(
      this.menuWithTitles,
       this.restaurant
   );

  @override
  initState() {
    super.initState();
    key = new GlobalKey<RestaurantSearchProductsContentState>();
    basketButtonStateKey = new GlobalKey();
    itemsPaddingKey = new GlobalKey();
    counterKey = new GlobalKey();
    panelController = new PanelController();
  }

  @override
  Widget build(BuildContext context) {
    panelContentKey = new GlobalKey();
    return Scaffold(
      body: SlidingUpPanel(
        backdropEnabled: true,
        controller: panelController,
        color: Colors.transparent,
        minHeight: 0,
        // maxHeight: MediaQuery.of(context).size.height * 0.9,
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
                              Navigator.pushReplacement(context,
                                  new MaterialPageRoute(builder:
                                      (context)=>RestaurantScreen(restaurant: restaurant)
                                  )
                              );
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
                              key.currentState.productName = text;
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
                            key.currentState.productName = '';
                            key.currentState.searchProductModelList.clear();
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
                  padding: EdgeInsets.only(top: 100),
                  child: RestaurantSearchProductsContent(
                    key: key,
                    productName: controller.text,
                    menuWithTitles: menuWithTitles,
                    itemsPaddingKey: itemsPaddingKey,
                    panelContentKey: panelContentKey,
                    panelController: panelController,
                    restaurant: restaurant,
                    basketButtonStateKey: basketButtonStateKey,
                    counterKey: counterKey,
                  )),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding:  EdgeInsets.only(bottom: 0),
                  child: CartButton(
                    key: basketButtonStateKey,
                    restaurant: restaurant,
                    source: CartSources.Restaurant,),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class RestaurantSearchProductsContent extends StatefulWidget {
  String productName;
  List<Widget> menuWithTitles;
  GlobalKey<CartButtonState> basketButtonStateKey;
  GlobalKey<ItemsPaddingState> itemsPaddingKey;
  GlobalKey<PanelContentState> panelContentKey;
  GlobalKey<ProductDescCounterState> counterKey;
  PanelController panelController;
  FilteredStores restaurant;

  RestaurantSearchProductsContent(
      {Key key, this.productName,
        this.menuWithTitles, this.basketButtonStateKey, this.itemsPaddingKey, this.panelContentKey, this.panelController, this.restaurant, this.counterKey}) : super(key: key);

  @override
  RestaurantSearchProductsContentState createState() => RestaurantSearchProductsContentState(
      productName,
      menuWithTitles,
      basketButtonStateKey,
      itemsPaddingKey,
      panelController,
      panelContentKey,
      restaurant,
      counterKey
  );
}

class RestaurantSearchProductsContentState extends State<RestaurantSearchProductsContent> {

  String productName;
  List<Widget> searchProductModelList;
  List<Widget> menuWithTitles;
  ScrollController scrollController;


  GlobalKey<CartButtonState> basketButtonStateKey;
  GlobalKey<ItemsPaddingState> itemsPaddingKey;
  GlobalKey<PanelContentState> panelContentKey;
  PanelController panelController;
  GlobalKey<ProductDescCounterState> counterKey;
  FilteredStores restaurant;
  ScrollController sliverScrollController;

  RestaurantSearchProductsContentState(
      this.productName,
      this.menuWithTitles,
      this.basketButtonStateKey,
      this.itemsPaddingKey,
      this.panelController,
      this.panelContentKey,
      this.restaurant,
      this.counterKey
  );

  @override
  initState() {
    super.initState();
    scrollController = new ScrollController();
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    searchProductModelList = [];

    // Производим происк среди итемов меню с заголовками
    for(int i = 0; i < menuWithTitles.length; i++){
      var element = menuWithTitles[i];

      // Любой итем, прошедший фильтр, добавляем в результирующий список
      if(element is MenuItem){
        if(element.restaurantDataItems.name.toUpperCase().contains(productName.toUpperCase())){
          //searchProductModelList.add(element);
          searchProductModelList.add(MenuItem(
            basketButtonStateKey: basketButtonStateKey,
            restaurant: restaurant,
            panelController: panelController,
            panelContentKey: panelContentKey,
            itemsPaddingKey: itemsPaddingKey,
            counterKey: counterKey,
            key: new GlobalKey(),
            parent: this,
            restaurantDataItems: element.restaurantDataItems,
          ));
        }
      }

      // Добавляем любой попавшийся тайтл, но удаляем тайтлы между которыми нет итемов
      if(element is MenuItemTitle || i == menuWithTitles.length-1) {
        if(searchProductModelList.isNotEmpty && searchProductModelList.last is MenuItemTitle){
          searchProductModelList.removeLast();
        }
        if(element is MenuItemTitle)
          searchProductModelList.add(MenuItemTitle(key: new GlobalKey(), title: element.title,));
          //searchProductModelList.add(element);
      }
    }

    if(restaurant.type == 'restaurant'){
      return ListView(
        children: searchProductModelList,
      );
    }else{
      return StaggeredGridView.countBuilder(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        crossAxisCount: 2,
        controller: sliverScrollController,
        itemCount: searchProductModelList.length+1,
        itemBuilder: (BuildContext context, int index) => (index == searchProductModelList.length) ? ItemsPadding(key: itemsPaddingKey,) : searchProductModelList[index],
        staggeredTileBuilder: (int index) {
          if(index == searchProductModelList.length)
            return StaggeredTile.extent(2, 80);
          if (searchProductModelList[index] is MenuItemTitle) {
            return StaggeredTile.extent(2, 50);
          }
          return StaggeredTile.extent(1, 245);

        },
        mainAxisSpacing: 0.0,
        crossAxisSpacing: 0.0,
      );
    }
  }
}