import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/HomeScreen/Model/FilteredStores.dart';
import 'package:flutter_app/Screens/RestaurantScreen/View/restaurant_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'CategoryListItem.dart';

class   CategoryList extends StatefulWidget {
  CategoryList({this.key, this.restaurant, this.parent}) : super(key: key);
  final GlobalKey<CategoryListState> key;
  final RestaurantScreenState parent;
  final FilteredStores restaurant;

  @override
  CategoryListState createState() {
    return new CategoryListState(restaurant, parent);
  }
}

class CategoryListState extends State<CategoryList> {
  final FilteredStores restaurant;
  final RestaurantScreenState parent;
  CategoriesUuid currentCategory;
  List<CategoryListItem> categoryItems;
  bool firstStart;
  ScrollController categoryListScrollController;
  ScrollController itemScrollController;
  ItemPositionsListener itemPositionsListener;


  CategoryListState(this.restaurant, this.parent);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    categoryItems = new List<CategoryListItem>();
    currentCategory = (restaurant.productCategoriesUuid.length > 0) ? restaurant.productCategoriesUuid[0] : '';
    firstStart = true;
    categoryListScrollController = new ScrollController();
    itemScrollController = ScrollController();
    itemPositionsListener = ItemPositionsListener.create();
  }

  @override
  void dispose(){
    super.dispose();
    categoryListScrollController.dispose();
  }

  _category() {
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
            height: 400,
            child: _buildCategoryBottomNavigationMenu(),
            decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                )),
          );
        });
  }

  _buildCategoryBottomNavigationMenu() {

    return Container(
      height: 400,
      child: ListView(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          children: List.generate(categoryItems.length, (index) {
            int itemCount = 0;
            parent.foodMenuItems.forEach((element) {
              if(categoryItems[index].value.uuid == element.restaurantDataItems.productCategories[0].uuid)
                itemCount++;
            });


            return Padding(
              padding: EdgeInsets.only(left: 20,
                  top: (categoryItems[0].value.name == categoryItems[index].value.name) ? 36 : 15,
                  bottom: 15, right: 0),
              child: GestureDetector(
                child: Row(
                  children: [
                    Text(categoryItems[index].value.name[0].toUpperCase() + categoryItems[index].value.name.substring(1),
                      style: (categoryItems[index].value != currentCategory) ? TextStyle(fontSize: 18) : TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      textAlign: TextAlign.start,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 2),
                      child: Text(itemCount.toString(),
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    )
                  ],
                ),
                onTap: () async {
                  CategoriesUuid value = categoryItems[index].value;
                  Navigator.pop(context);
                  if(await parent.GoToCategory(restaurant.productCategoriesUuid.indexOf(value)))
                    SelectCategory(value);
                  ScrollToSelectedCategory();
                },
              ),
            );
          })
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Если категории в списке отличаются от категорий ресторана
    if(categoryItems.length != restaurant.productCategoriesUuid.length){
      // Очищаем лист, если он не очищен
      if(categoryItems.length != 0)
        categoryItems.clear();
      // Заполянем список категорий категориями продуктов
      restaurant.productCategoriesUuid.forEach((element) {
        categoryItems.add(new CategoryListItem(key: new GlobalKey<CategoryListItemState>(),
            categoryList: this,value: element));
      });
    }
    // Скроллинг к выбранной категории после билда скрина
    if(!firstStart){
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await ScrollToSelectedCategory();
      });
    }else{
      firstStart = false;
    }

    return  Padding(
      padding: const EdgeInsets.only(top: 0),
      child: Container(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          height: 70,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 7, right: 5),
                child: InkWell(
                  hoverColor: Colors.white,
                  focusColor: Colors.white,
                  splashColor: Colors.white,
                  highlightColor: Colors.white,
                  child: SvgPicture.asset(
                    'assets/svg_images/rest_menu.svg',
                    color: Colors.black,
                  ),
                  onTap: (){
                    _category();
                  },
                ),
              ),

              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: SingleChildScrollView(
                  controller: itemScrollController,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: categoryItems,
                  ),
                )
              ),
            ],
          )
      ),
    );

  }

  void SelectCategory(CategoriesUuid category) {
    CategoriesUuid oldCategory = this.currentCategory;
    this.currentCategory = category;
    CategoryListItem categoryItem =
    categoryItems.firstWhere((element) => element.value == oldCategory);
    if(categoryItem.key.currentState != null)
      categoryItem.key.currentState.setState(() { });
    categoryItem =
        categoryItems.firstWhere((element) => element.value == category);
    if(categoryItem.key.currentState != null)
      categoryItem.key.currentState.setState(() { });
  }

  Future<void> ScrollToSelectedCategory() async{
    // Вычисляем оффсет тайтла необходимой категории
    double offset = 0;
    double defaultItemWidth = 165;
    for(int i = 0; i<categoryItems.length; i++){
      var item = categoryItems[i];
      if(item.value == currentCategory)
        break;
      offset += (item.key.currentContext != null) ? item.key.currentContext.size.width : 0;
    }
    await itemScrollController.position.animateTo(offset,curve: Curves.ease, duration: Duration(milliseconds: 600));


  }
}