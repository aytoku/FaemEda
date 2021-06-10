import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../View/city_autocomplete.dart';

class Cross extends StatefulWidget {

  TextEditingController controller;
  AutocompleteList autocompleteList;
  Cross(this.controller, this.autocompleteList, {Key key}) : super(key: key);

  @override
  CrossState createState() {
    return new CrossState(controller, autocompleteList);
  }
}

class CrossState extends State<Cross> {
  TextEditingController controller;
  AutocompleteList autocompleteList;
  CrossState(this.controller, this.autocompleteList);

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {

      });
    });
  }

  Widget build(BuildContext context) {
    if(controller.text.length == 0){
      return Container();
    }
    return GestureDetector(
      child: SvgPicture.asset(
          'assets/svg_images/auto_cross.svg'),
      onTap: (){
        if(controller.text != ''){
          autocompleteList.autoCompleteListKey.currentState.suggestions.clear();
          controller.clear();
          autocompleteList.autoCompleteListKey.currentState.setState((){

          });
        }
      },
    );
  }
}