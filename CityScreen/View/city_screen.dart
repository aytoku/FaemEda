import 'package:carousel_pro/carousel_pro.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/AuthScreen/Bloc/phone_number_get_bloc.dart';
import 'package:flutter_app/Screens/AuthScreen/View/auth_screen.dart';
import 'package:flutter_app/Screens/CityScreen/View/add_city_screen.dart';
import 'package:flutter_app/Screens/HomeScreen/Bloc/restaurant_get_bloc.dart';
import 'package:flutter_app/Screens/HomeScreen/View/home_screen.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CityScreen extends StatefulWidget {
  CityScreen({Key key}) : super(key: key);

  @override
  CityScreenState createState() {
    return new CityScreenState();
  }
}

bool vis = true;

class CityScreenState extends State<CityScreen> {
  CarouselController buttonCarouselController = CarouselController();
  TextEditingController cityController;
  PageController pageController = PageController(initialPage: 1);

  @override
  void initState() {
    super.initState();
    cityController = new TextEditingController();
  }

  List<Widget> welcome = [
    Image.asset('assets/images/welcome1.png', fit: BoxFit.fill,),
    Image.asset('assets/images/welcome2.png', fit: BoxFit.fill,),
    Image.asset('assets/images/welcome3.png', fit: BoxFit.fill,),
    Image.asset('assets/images/welcome4.png', fit: BoxFit.fill,),
  ];

  @override
  void dispose() {
    super.dispose();
    cityController.dispose();
  }

  CityScreenState();

  showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 1), () {
          Navigator.of(context).pop(true);
        });
        return Padding(
          padding: EdgeInsets.only(bottom: 500),
          child: Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            child: Container(
              height: 50,
              width: 100,
              child: Center(
                child: Text("Выберите город"),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (selectedCity != null) {
      cityController.text = selectedCity.name;
    }
    return Scaffold(
      backgroundColor: Color(0xFF141414),
      body: Stack(
        children: [
          Center(
            child: Image.asset(
              'assets/images/tomato_preloader.png',
            ),
          ),
          (currentUser.isLoggedIn)
              ? Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 50, left: 20),
                    child: GestureDetector(
                      child: SvgPicture.asset(
                          'assets/svg_images/rest_arrow_left.svg'),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                )
              : Container(),
          (!currentUser.isLoggedIn)
              ? Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50, right: 20),
                    child: GestureDetector(
                      child: Container(
                        width: 125,
                        height: 41,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColor.themeColor),
                        child: Center(
                          child: Text(
                            'Войти',
                            style: TextStyle(
                                fontSize: 18, color: AppColor.textColor),
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (context) => AuthGetBloc(),
                              child: AuthScreen(),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              : Container(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 190,
              decoration: BoxDecoration(
                color: AppColor.themeColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20, left: 20),
                      child: Text(
                        'Укажите город доставки',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    child: GestureDetector(
                      child: TextField(
                        controller: cityController,
                        decoration: InputDecoration(
                            enabled: false,
                            contentPadding: EdgeInsets.only(left: 2),
                            hintText: 'Введите город',
                            hintStyle: TextStyle(
                                fontSize: 14,
                                color: AppColor.additionalTextColor)),
                      ),
                      onTap: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => AddCityScreen()),
                            (Route<dynamic> route) => false);
                      },
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            bottom: 20, right: 20, left: 20),
                        child: GestureDetector(
                          child: Container(
                            height: 52,
                            width: 335,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: (cityController.text.length == 0)
                                    ? Color(0xFFF6F6F6)
                                    : AppColor.mainColor),
                            child: Center(
                              child: Text(
                                'Далее',
                                style: TextStyle(
                                    color: AppColor.textColor, fontSize: 18),
                              ),
                            ),
                          ),
                          onTap: () {
                            if (cityController.text.length == 0) {
                              showAlertDialog(context);
                            }
                            homeScreenKey = new GlobalKey<HomeScreenState>();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                      create: (context) => RestaurantGetBloc(),
                                      child: new HomeScreen(),
                                    )));
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Visibility(
            visible: vis,
            child: Container(
              color: AppColor.fieldColor,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: CarouselSlider.builder(
                itemCount: 4,
                itemBuilder: (BuildContext context, int index, int realIndex) {
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(color: AppColor.fieldColor),
                    child: GestureDetector(
                      child: welcome[index],
                      onTap: () {
                        if (index == 3) {
                          setState(() {
                            vis = false;
                          });
                        } else {
                          buttonCarouselController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.linear);
                        }
                      },
                    ),
                  );
                },
                carouselController: buttonCarouselController,
                options: CarouselOptions(
                  viewportFraction: 1,
                  height: double.infinity,
                  autoPlay: false,
                  initialPage: 0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
