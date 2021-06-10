import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Widgets/ProductCategories/CategoryList.dart';
import 'package:flutter_app/data/data.dart';

class SliverShadow extends StatefulWidget {
  SliverShadow({
    this.key,
    this.categoryList
  }) : super(key: key);
  final GlobalKey<SliverShadowState> key;
  Widget categoryList;

  @override
  SliverShadowState createState() {
    return new SliverShadowState(categoryList);
  }
}

class SliverShadowState extends State<SliverShadow>{

  Widget categoryList;
  bool showShadow = false;
  SliverShadowState(this.categoryList);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: (showShadow) ? BoxDecoration(
        color: AppColor.themeColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 15,
            offset: Offset(0, -10),
          ),
        ],
      ) : BoxDecoration(
        color: AppColor.themeColor
      ),
      child: categoryList,
    );
  }
}