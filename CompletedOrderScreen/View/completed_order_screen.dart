import 'package:flutter/material.dart';
import 'package:flutter_app/Internet/check_internet.dart';
import 'package:flutter_app/Screens/CompletedOrderScreen/Widget/estimate.dart';
import 'package:flutter_app/Screens/HomeScreen/Bloc/restaurant_get_bloc.dart';
import 'package:flutter_app/Screens/HomeScreen/View/home_screen.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class CompletedOrderScreen extends StatefulWidget {

  CompletedOrderScreen({Key key}) : super(key: key);

  @override
  CompletedOrderScreenState createState() =>
      CompletedOrderScreenState();
}

class CompletedOrderScreenState extends State<CompletedOrderScreen> {

  CompletedOrderScreenState();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: <Widget>[
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Column(
                    children: [
                      Text(
                        'Спасибо за заказ!',
                        style: TextStyle(color: Color(0xFF424242), fontSize: 24),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          'Оставьте свой отзыв, это поможет\nсделать приложение лучше! ',
                          style: TextStyle(color: Color(0xFF424242), fontSize: 18), textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: Align(
                        alignment: Alignment.topCenter,
                        child: Estimate()),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 222,
                        width: 339,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(width: 1.0, color: Colors.grey[200])),
                        child: TextField(
                          minLines: 1,
                          maxLines: 100,
                          textCapitalization: TextCapitalization.sentences,
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 14),
                          keyboardType: TextInputType.text,
                          decoration: new InputDecoration(
                            hintText: 'Оставьте свой отзыв',
                            hintStyle: TextStyle(
                                color: AppColor.additionalTextColor,
                                fontSize: 16
                            ),
                            contentPadding: EdgeInsets.all(15),
                            border: InputBorder.none,
                            counterText: '',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(left: 0, top: 20, bottom: 20),
                  child: FlatButton(
                    child: Text(
                      "Оценить заказ",
                      style: TextStyle(color: AppColor.textColor, fontSize: 18),
                    ),
                    color: AppColor.mainColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding:
                    EdgeInsets.only(left: 110, top: 20, right: 110, bottom: 20),
                    onPressed: () async {
                      if (await Internet.checkConnection()) {
                        homeScreenKey = new GlobalKey();
                        Navigator.pushReplacement(
                          context,
                          new MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (context) => RestaurantGetBloc(),
                              child: new HomeScreen(),
                            ),
                          ),
                        );
                      } else {
                        noConnection(context);
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}