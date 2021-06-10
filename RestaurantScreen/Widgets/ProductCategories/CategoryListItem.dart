import 'package:flutter/material.dart';
import 'package:flutter_app/Internet/check_internet.dart';
import 'package:flutter_app/Screens/HomeScreen/Model/FilteredStores.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/data/globalVariables.dart';

import 'CategoryList.dart';

class CategoryListItem extends StatefulWidget {
  CategoryListItem({this.key, this.value, this.categoryList}) : super(key: key);
  final GlobalKey<CategoryListItemState> key;
  final CategoriesUuid value;
  final CategoryListState categoryList;

  @override
  CategoryListItemState createState() {
    return new CategoryListItemState(value,categoryList);
  }
}


class CategoryListItemState extends State<CategoryListItem> with AutomaticKeepAliveClientMixin {
  final CategoryListState categoryList;
  final CategoriesUuid value;

  CategoryListItemState(this.value, this.categoryList);

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
          padding:
          EdgeInsets.only(left: 11, top: 5, bottom: 5),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 100),
            // transitionBuilder: (Widget child, Animation<double> animation) {
            //   return ScaleTransition(child: child, scale: animation);
            // },
            child: Container(
              key: ValueKey<bool>(value != categoryList.currentCategory),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: (value != categoryList.currentCategory)
                      ? AppColor.themeColor
                      : AppColor.mainColor),
              child: Padding(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Center(
                    child: Text(
                      value.name[0].toUpperCase() + value.name.substring(1),
                      style: TextStyle(
                          color: (value != categoryList.currentCategory)
                              ? Color(0xFF424242)
                              : AppColor.textColor,
                          fontSize: 15),
                    ),
                  )),
            ),
          )),
      onTap: () async {
        if (await Internet.checkConnection()) {
          //Если категория загрузась без ошибок
          if(await categoryList.parent.GoToCategory(categoryList.restaurant.productCategoriesUuid.indexOf(value)))
            categoryList.SelectCategory(value); // выделяем ее
        } else {
          noConnection(context);
        }
      },
    );
  }
}