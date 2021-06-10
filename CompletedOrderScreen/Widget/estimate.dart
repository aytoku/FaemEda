
import 'package:flutter/material.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../data/data.dart';

class Estimate extends StatefulWidget {

  Estimate({Key key}) : super(key: key);

  @override
  EstimateState createState() {
    return new EstimateState();
  }
}

class EstimateState extends State<Estimate>{

  List<bool> selectedStars;
  EstimateState();

  @override
  void initState(){
    super.initState();
    selectedStars = List.generate(5, (index) => false);
  }


  @override
  Widget build(BuildContext context) {

    return Container(
        padding: EdgeInsets.only(),
        height: 60,
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.zero,
          children: List.generate(5,(index){
            return InkWell(
              child: Padding(
                padding: const EdgeInsets.only(top: 15, left: 20, right: 20, bottom: 15),
                child: (!selectedStars[index]) ? SvgPicture.asset('assets/svg_images/estimate_star.svg') :
                SvgPicture.asset('assets/svg_images/estimate_star.svg', color: AppColor.mainColor,),
              ),
              onTap: (){
                setState(() {
                  selectedStars[index] = !selectedStars[index];
                });
              },
            );
          }),
        )
    );
  }
}