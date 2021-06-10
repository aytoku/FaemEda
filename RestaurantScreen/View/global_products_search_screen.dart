import 'package:flutter/material.dart';
import 'package:flutter_app/Amplitude/amplitude.dart';
import 'package:flutter_app/Screens/HomeScreen/API/getStoreByUuid.dart';
import 'package:flutter_app/Screens/RestaurantScreen/API/search_products.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Model/SearchProductModel.dart';
import 'package:flutter_app/Screens/RestaurantScreen/View/restaurant_screen.dart';
import 'package:flutter_app/app.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProductsSearchScreen extends StatefulWidget {

  ProductsSearchScreen({Key key});

  @override
  ProductsSearchScreenState createState() => ProductsSearchScreenState();
}

class ProductsSearchScreenState extends State<ProductsSearchScreen> {

  TextEditingController controller = new TextEditingController();
  GlobalKey<SearchProductsContentState> key = new GlobalKey();

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: SvgPicture.asset('assets/svg_images/search_icon.svg',
          color: Colors.black,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
                  hintText: 'Ресторан,кухня или блюдо',
                ),
                onChanged: (text){
                  print(controller.text);
                  if(key.currentState != null){
                    key.currentState.setState(() {
                      key.currentState.productName = controller.text;
                      key.currentState.page = 1;
                    });
                  }
                },
              ),
            ),
            InkWell(
              child: Container(
                child: SvgPicture.asset('assets/svg_images/search_cross.svg'),
              ),
              onTap: (){
                controller.clear();
                key.currentState.productName = '';
                key.currentState.searchProductModelList.clear();
                key.currentState.page = 1;
                key.currentState.setState(() {

                });
                Navigator.pop(context);
                AmplitudeAnalytics.analytics.logEvent('close_global_search');
              },
            )
          ],
        ),
      ),
      body: GestureDetector(
        child: Container(
          child: Column(
            children: [
              SearchProductsContent(key: key, productName: controller.text),
            ],
          ),
        ),
        onTap: (){
          FocusScope.of(context).requestFocus(new FocusNode());
        },
      ),
    );
  }
}


class SearchProductsContent extends StatefulWidget {
  String productName;

  SearchProductsContent(
      {Key key, this.productName}) : super(key: key);

  @override
  SearchProductsContentState createState() => SearchProductsContentState(productName);
}

class SearchProductsContentState extends State<SearchProductsContent> {

  String productName;
  int page = 1;
  int limit = 10;
  List<SearchProductModel> searchProductModelList;
  ScrollController scrollController;
  bool isLoading;

  SearchProductsContentState(this.productName);

  @override
  initState() {
    super.initState();
    scrollController = new ScrollController();
    isLoading = false;
    searchProductModelList = new List<SearchProductModel>();
    scrollController.addListener(() {
      if (!isLoading &&
          scrollController.position.pixels ==
              scrollController.position.maxScrollExtent) {
        setState(() {
          isLoading = true;
          page++;
        });
      }
    });
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SearchProductModelData>(
      future: searchProducts('988a1afb-f5a0-475f-9927-bcbc5fc04e09', 'c0065f4f-b440-4c74-83c6-7bfb00671780', productName, page, limit),
      builder: (BuildContext context,
          AsyncSnapshot<SearchProductModelData> snapshot) {
        if (snapshot.hasData) {

          if(snapshot.connectionState == ConnectionState.done){
            if(page == 1)
              searchProductModelList.clear();

            if(searchProductModelList.isEmpty){
              searchProductModelList.addAll(snapshot.data.searchModel);

              if(searchProductModelList.isEmpty){
                isLoading = false;
                return Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.4),
                  child: Center(child: Text('Ничего не найдено')),
                );
              }


            } else if(snapshot.data.searchModel.isNotEmpty) {
              if(snapshot.data.searchModel.first.store.uuid == searchProductModelList.last.store.uuid){
                searchProductModelList.last.products.addAll(snapshot.data.searchModel.first.products);
                if(snapshot.data.searchModel.length>1){
                  searchProductModelList.addAll(snapshot.data.searchModel.getRange(1, snapshot.data.searchModel.length-1));
                }
              } else{
                searchProductModelList.addAll(snapshot.data.searchModel);
              }
            }

            isLoading = false;
          }

          return Expanded(
            child: ListView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                controller: scrollController,
                padding: EdgeInsets.only(top: 20),
                children: [
                  Column(
                    children: List.generate(searchProductModelList.length, (index){
                      return Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                            child: Row(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10)),
                                      child: Image.network(
                                        getImage((searchProductModelList[index].store.image != null) ?
                                        searchProductModelList[index].store.image : ''),
                                        fit: BoxFit.cover,
                                        height: 50,
                                        width: 50,
                                      ),),
                                  ),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 20),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 8.0, right: 60),
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                searchProductModelList[index].store.name,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    decoration: TextDecoration.none,
                                                    fontSize: 18.0,
                                                    color: Color(0xFF000000)),
                                                textAlign: TextAlign.start,
                                              ),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text("Категория",
                                              style: TextStyle(
                                                  color: AppColor.additionalTextColor,
                                                  fontSize: 12
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: List.generate(searchProductModelList[index].products.length, (index2) {
                              var product = searchProductModelList[index].products[index2];
                              return InkWell(
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.only(left: 25, right: 15, top: 0, bottom: 10),
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 60),
                                        child: Column(
                                          children: [
                                            // Align(
                                            //   alignment: Alignment.topLeft,
                                            //   child: Text(product.productCategoryName,
                                            //     style: TextStyle(
                                            //         color: AppColor.additionalTextColor,
                                            //         fontSize: 12
                                            //     ),
                                            //   ),
                                            // ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: 10
                                              ),
                                              child: Container(
                                                width: MediaQuery.of(context).size.width * 0.9,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        padding: EdgeInsets.only(right: 15),
                                                        child: Text(product.name,
                                                          textAlign: TextAlign.start,
                                                          style: TextStyle(
                                                              fontSize: 14
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Text(product.price.toStringAsFixed(0) + ' \₽',
                                                      style: TextStyle(
                                                          fontSize: 14
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Align(
                                                alignment: Alignment.bottomCenter,
                                                child: Padding(
                                                  padding: EdgeInsets.only(top: 15),
                                                  child: Divider(height: 1, color: Colors.grey,),
                                                ))
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () async{
                                  var restaurant = await getStoreByUuid(searchProductModelList[index].store.uuid);
                                  if(restaurant.type == "grocery"){
                                    selectedCategoriesUuid = product.productCategory;
                                    selectedCategoriesUuid.uuid = product.productCategoryUuid;
                                  }

                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) =>
                                          RestaurantScreen(restaurant: restaurant, initialProductUuid: product.uuid)
                                      )
                                  );
                                  AmplitudeAnalytics.analytics.logEvent('open_search_product', eventProperties: {
                                    'uuid': product.uuid
                                  });
                                },
                              );
                            }),
                          )
                        ],
                      );
                    }),
                  ),
                  Center(
                    child: CircularProgressIndicator(),
                  )
                ]
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}