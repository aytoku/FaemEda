import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/RestaurantScreen/Model/ProductDataModel.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_svg/flutter_svg.dart';

class VariantsSelector extends StatefulWidget {
  VariantGroup variantGroup;
  GlobalKey<VariantsSelectorState> key;
  bool error;
  VoidCallback onTap;


  VariantsSelector({this.key, this.variantGroup, this.error, this.onTap}) : super(key: key);

  @override
  VariantsSelectorState createState() => VariantsSelectorState(variantGroup, (error == null) ? false : error, onTap);
}

class VariantsSelectorState extends State<VariantsSelector> {
  VariantGroup variantGroup;
  List<Variant> selectedVariants;
  List<Variant> variantsList;
  bool required;
  String groupName;
  bool error;
  VoidCallback onTap;

  @override
  void initState() {
    selectedVariants = new List<Variant>();
    variantsList.forEach((element) {
      if(element.variantDefault)
        selectedVariants.add(element);
    });
    super.initState();
  }

  VariantsSelectorState(this.variantGroup, this.error, this.onTap){
    groupName = variantGroup.name;
    variantsList = variantGroup.variants;
    required = variantGroup.required;
  }

  List<Variant> getSelectedVariants() {

    return selectedVariants;
  }

  double getSelectedVariantsCost(){
    double cost = 0;
    selectedVariants.forEach((element) {
      cost+=element.price;
    });
    return cost;
  }

  bool hasSelectedVariants(){
    return selectedVariants.isNotEmpty;
  }

  Widget build(BuildContext context) {
    List<Widget> widgetsList = new List<Widget>();
    widgetsList.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 15, top: 10, bottom: 15),
              child: Text(
                groupName,
              ),
            ),
          ),
          (error) ? Padding(
            padding: EdgeInsets.only(right: 15, top: 10, bottom: 15),
            child: Text((required) ? 'Обязательно' : 'Опционально',
              style: TextStyle(color: Colors.red),
            ),
          ) : Row(
            children: [
              (selectedVariants.isNotEmpty && required) ? Padding(
                padding: const EdgeInsets.only(right: 8.0, top: 10, bottom: 15),
                child: SvgPicture.asset('assets/svg_images/accepted_variant.svg'),
              ) : Container(),
              Padding(
                padding: EdgeInsets.only(right: 15, top: 10, bottom: 15),
                child: Text(
                  (required) ? 'Обязательно' : 'Опционально',
                  style: TextStyle(
                    color: (selectedVariants.isNotEmpty && required) ?
                    Colors.black :
                    Color(0xFF7D7D7D)
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
    if(!required){
      variantsList.forEach((element) {
        widgetsList.add( InkWell(
          child: Container(
            padding:  EdgeInsets.only(left: 15, top: 0, bottom: 22),
            child: Row(
              children: [
                (selectedVariants.contains(element)) ? SvgPicture.asset('assets/svg_images/selector_green.svg') :
                SvgPicture.asset('assets/svg_images/kitchen_unselected.svg'),
                Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    element.name,
                    style: TextStyle(color: Color(0xff424242), fontSize: 14),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 12.0),
                  child: Text(
                    '+ ${element.price.toInt()} \₽',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          onTap: (){
            setState(() {
              if(selectedVariants.contains(element)){
                selectedVariants.remove(element);
              }else{
                selectedVariants.add(element);
              }
            });
            if(onTap != null)
              onTap();
          },
        ));
      });
    }else{
      variantsList.forEach((element) {
        print(element.uuid);
        widgetsList.add(
            GestureDetector(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: AppColor.themeColor
                ),
                padding:  EdgeInsets.only(top: 0, bottom: 22 , left: 15),
                child: Row(
                  children: [
                    (selectedVariants.contains(element)) ? SvgPicture.asset('assets/svg_images/checked_rest_circle.svg')
                        : SvgPicture.asset('assets/svg_images/rest_circle.svg'),
                    Padding(
                      padding: EdgeInsets.only(left: 18),
                      child: Text(element.name,
                        style: TextStyle(
                            fontSize: 14
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 12.0),
                      child: Text(
                        '${element.price.toInt()} \₽',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
              onTap: (){
                setState(() {
                  selectedVariants.clear();
                  selectedVariants.add(element);
                  error = false;
                  if(onTap != null)
                    onTap();
                });
              },
            )
        );
      });
    }
    return Container(
      color: AppColor.themeColor,
      child: ScrollConfiguration(
        behavior: new ScrollBehavior(),
        child: SingleChildScrollView(
          child: Column(
            children: widgetsList,
          ),
        ),
      ),
    );
  }
}