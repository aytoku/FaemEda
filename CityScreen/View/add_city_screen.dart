import 'package:flutter/material.dart';
import 'package:flutter_app/Internet/check_internet.dart';
import 'package:flutter_app/Screens/CartScreen/View/cart_page_view.dart';
import 'package:flutter_app/Screens/CityScreen/View/city_autocomplete.dart';
import 'package:flutter_app/Screens/CityScreen/View/city_screen.dart';
import 'package:flutter_app/Screens/OrderConfirmationScreen/View/address_screen.dart';
import 'package:flutter_svg/svg.dart';

import '../../../data/data.dart';
import '../../../data/data.dart';
import 'city_screen.dart';

// ignore: must_be_immutable
class AddCityScreen extends StatefulWidget {
  AddressScreenState parent;

  AddCityScreen({Key key, this.parent}) : super(key: key);

  @override
  AddCityScreenState createState() =>
      AddCityScreenState(parent);
}

class AddCityScreenState extends State<AddCityScreen> {
  bool status1 = false;
  String name;
  GlobalKey<CityAutocompleteState> autoCompleteFieldKey;
  AddressScreenState parent;
  TextEditingController nameField;
  TextEditingController commentField;
  GlobalKey<CartPageState>cartPageKey;

  AddCityScreenState(this.parent);


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    autoCompleteFieldKey = new GlobalKey();
    nameField = new TextEditingController();
    commentField = new TextEditingController();
    cartPageKey = new GlobalKey();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: AppColor.themeColor,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InkWell(
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                        padding: EdgeInsets.only(top: 30, bottom: 25),
                        child: Container(
                            height: 40,
                            width: 60,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 12, bottom: 12, right: 10),
                              child:SvgPicture.asset(
                                  'assets/svg_images/arrow_left.svg'),
                            )))),
                onTap: () {
                   Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CityScreen())
                   );
                },
              ),
            ],
          ),
          Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(top: 80, left: 20),
                child: Column(
                  children: <Widget>[
                    CityAutocomplete(autoCompleteFieldKey, onSelected: (){
                      return;
                    },
                   )
                  ],
                ),
              )
          ),
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: Container(
          //     width: MediaQuery.of(context).size.width,
          //     color: Colors.white,
          //     child: Padding(
          //       padding: EdgeInsets.only(bottom: 15, left: 15, right: 15, top: 5),
          //       child: FlatButton(
          //         child: Text(
          //             "Добавить город",
          //             style: TextStyle(
          //                 fontSize: 16.0,
          //                 color: Colors.white)
          //         ),
          //         color: Color(0xFF09B44D),
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(10),
          //         ),
          //         padding:
          //         EdgeInsets.only(left: 100, top: 20, right: 100, bottom: 20),
          //         onPressed: () async {
          //           if (await Internet.checkConnection()) {
          //             selectedCity = autoCompleteFieldKey.currentState.selectedValue;
          //             necessaryDataForAuth.city_uuid = selectedCity.uuid;
          //             Navigator.pop(context);
          //             Navigator.push(context,
          //               new MaterialPageRoute(builder: (context) => new CityScreen()),
          //             );
          //           } else {
          //             noConnection(context);
          //           }
          //         },
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}