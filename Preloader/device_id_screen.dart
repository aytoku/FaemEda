import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Centrifugo/centrifugo.dart';
import 'package:flutter_app/Config/config.dart';
import 'package:flutter_app/FCM/fcm.dart';
import 'package:flutter_app/Screens/WelcomeScreen/View/welcome_screen.dart';
import 'package:flutter_app/Screens/AuthScreen/Bloc/phone_number_get_bloc.dart';
import 'package:flutter_app/Screens/AuthScreen/View/auth_screen.dart';
import 'package:flutter_app/Screens/CityScreen/View/city_screen.dart';
import 'package:flutter_app/Screens/HomeScreen/Bloc/restaurant_get_bloc.dart';
import 'package:flutter_app/Screens/HomeScreen/Bloc/restaurant_get_state.dart';
import 'package:flutter_app/VersionControl/API/getCurrentVersion.dart';
import 'package:flutter_app/VersionControl/Model/CurrentVersionModel.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

import '../Amplitude/amplitude.dart';
import '../Config/config.dart';
import '../Screens/HomeScreen/View/home_screen.dart';
import '../data/data.dart';


class DeviceIdScreen extends StatefulWidget{
  @override
  DeviceIdScreenState createState() =>
      DeviceIdScreenState();
}

class DeviceIdScreenState extends State<DeviceIdScreen> {

  GlobalKey<CityScreenState> cityScreenKey = new GlobalKey();


  Future<NecessaryDataForAuth> devId;
  CurrentVersionModel currentVersionModel;
  Future<bool> animationDelay;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    devId = NecessaryDataForAuth.getData();
    animationDelay = Future.delayed(Duration(seconds: 0), () => true);
    getVerData(context);
  }

  getVerData(BuildContext context) async {
    await getCurrentVersion();
    checkVer(context);
  }

  showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(bottom: 300),
          child: Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            child: Container(
              height: 150,
              width: 100,
              child: Column(
                children: [
                  Center(
                    child: Text("Вышло новое обновление"),
                  ),
                  Text('Не желаете обновить?'),
                  Row(
                    children: [
                      Text('Да'),
                      Text('Нет'),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFF8F9F8),
      child: FutureBuilder<NecessaryDataForAuth>(
        future: devId,
        builder:
            (BuildContext context, AsyncSnapshot<NecessaryDataForAuth> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // CartDataModel.getCart().then((value) {
            //   currentUser.cartModel = value;
            //   print('Cnjbn');
            // });
            return FutureBuilder<bool>(
              future: animationDelay,
              builder: (BuildContext context, AsyncSnapshot<bool> animationSnapshot){
                if(animationSnapshot.connectionState != ConnectionState.done)

                  //return Lottie.asset('assets/gif/pomidor.json');
                  return Center(
                      child: Image(
                        image: new AssetImage('assets/gif/tomato.gif'),
                      )
                  );

                necessaryDataForAuth = snapshot.data;
                if (necessaryDataForAuth.refresh_token == null ||
                    necessaryDataForAuth.phone_number == null ||
                    necessaryDataForAuth.name == null) {
                  currentUser.isLoggedIn = false;

                  AmplitudeAnalytics.initialize(necessaryDataForAuth.device_id).then((value){
                    AmplitudeAnalytics.analytics.logEvent('open_app');
                  });
                  // if(necessaryDataForAuth.vis){
                  //   necessaryDataForAuth.vis = false;
                  //   NecessaryDataForAuth.saveData();
                  //   return WelcomeScreen();
                  // }

                  homeScreenKey =
                  new GlobalKey<HomeScreenState>();
                  return WelcomeScreen();
                  // if(necessaryDataForAuth.city == null){
                  //   return CityScreen();
                  // }else{
                  //   selectedCity = necessaryDataForAuth.city;
                  //   homeScreenKey =
                  //   new GlobalKey<HomeScreenState>();
                  //   return BlocProvider(
                  //     create: (context)=> RestaurantGetBloc(
                  //         restaurantGetState: RestaurantGetStateLoading(
                  //             showPrelaoder: true)),
                  //     child: HomeScreen(),
                  //   );
                  // }
                }
                print(necessaryDataForAuth.refresh_token);
                AmplitudeAnalytics.initialize(necessaryDataForAuth.phone_number).then((value){
                  AmplitudeAnalytics.analytics.logEvent('open_app');
                });
                Centrifugo.connectToServer();
                new FirebaseNotifications().setUpFirebase();
                homeScreenKey =
                new GlobalKey<HomeScreenState>();
                return BlocProvider(
                  create: (context)=> RestaurantGetBloc(
                      restaurantGetState: RestaurantGetStateLoading(
                          showPrelaoder: true)),
                  child: HomeScreen(),
                );


                // if(necessaryDataForAuth.city == null){
                //   return CityScreen();
                // }else{
                //   selectedCity = necessaryDataForAuth.city;
                //   homeScreenKey =
                //   new GlobalKey<HomeScreenState>();
                //   return BlocProvider(
                //     create: (context)=> RestaurantGetBloc(
                //         restaurantGetState: RestaurantGetStateLoading(
                //             showPrelaoder: true)),
                //     child: HomeScreen(),
                //   );
                // }
              });
          } else {
            return Center(
                child: Image(
                  image: new AssetImage('assets/gif/tomato.gif'),
                )
            );
          }
        },
      ),
    );
  }
}