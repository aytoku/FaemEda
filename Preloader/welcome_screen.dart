import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/HomeScreen/Bloc/restaurant_get_bloc.dart';
import 'package:flutter_app/Screens/HomeScreen/View/home_screen.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  WelcomeScreenState createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> {

  List<Widget> welcome = [
    Image.asset('assets/images/welcome1.png', fit: BoxFit.fill,),
    Image.asset('assets/images/welcome2.png', fit: BoxFit.fill,),
    Image.asset('assets/images/welcome3.png', fit: BoxFit.fill,),
    Image.asset('assets/images/welcome4.png', fit: BoxFit.fill,),
  ];
  CarouselController buttonCarouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Container(
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
                      homeScreenKey = new GlobalKey<HomeScreenState>();
                      Navigator.of(context).pushAndRemoveUntil(
                          PageRouteBuilder(
                              pageBuilder: (context, animation, anotherAnimation) {
                                return BlocProvider(
                                  create: (context) => RestaurantGetBloc(),
                                  child: new HomeScreen(),
                                );
                              },
                              transitionDuration: Duration(milliseconds: 300),
                              transitionsBuilder:
                                  (context, animation, anotherAnimation, child) {
//                                      animation = CurvedAnimation(
//                                          curve: Curves.bounceIn, parent: animation);
                                return SlideTransition(
                                  position: Tween(
                                      begin: Offset(1.0, 0.0),
                                      end: Offset(0.0, 0.0))
                                      .animate(animation),
                                  child: child,
                                );
                              }
                          ), (Route<dynamic> route) => false);
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
        ));
  }
}