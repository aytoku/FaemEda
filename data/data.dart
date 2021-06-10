import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Internet/check_internet.dart';
import 'package:flutter_app/Screens/HomeScreen/Bloc/restaurant_get_bloc.dart';
import 'package:flutter_app/Screens/HomeScreen/View/home_screen.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:flutter_app/data/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:launch_review/launch_review.dart';
import 'dart:convert' as convert;

import 'package:package_info/package_info.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:shared_preferences/shared_preferences.dart';


String getAuthorizationError(String message){
  print('auuu' + message);
  return codeErrors.containsKey(message)
      ? codeErrors[message] : message;
}


String getImage(String imgJson) {
  if(imgJson == null){
    return '';
  }
  try {
    Map<String,dynamic> json = convert.jsonDecode(imgJson);
    if(json.containsKey('medium_format')){
      print('parsedJson ' + json['medium_format']);
      return json['medium_format'];
    }
    print('not parsedJson ' + imgJson);
    return imgJson;
  } catch(e){
    if(imgJson.startsWith('"\\"')) {
      imgJson = imgJson.substring(3, imgJson.length - 3);
    }else if(imgJson.startsWith('"')){
      imgJson = imgJson.substring(1, imgJson.length - 1);
    }
    print('exception ' + imgJson);
    return imgJson;
  }
}

var DeliveryStates = [
  'cooking',
  'created',
  'offer_offered',
  'smart_distribution',
  'finding_driver',
  'offer_rejected',
  'order_start',
  'on_place',
  'waiting_for_confirmation',
  'on_the_way',
  'delivery',
  'ready',
  'order_payment'
];

class AppColor {
  AppColor._();

  static Color mainColor = Color(0xFF4A9D52);
  static Color textColor = Color(0xFF313131);
  static Color unselectedTextColor = Color(0xFF313131);
  static Color additionalTextColor = Color(0xFF9E9E9E);
  static Color themeColor = Color(0xFFFFFFFF);
  static Color fieldColor = Color(0xFFFFFFFF);
  static Color elementsColor = Color(0xFFEFEFEF);
  static Color subElementsColor = Color(0xFFEFEFEF);
  static Color borderFieldColor = Color(0xFF4A9D52);
  static Color unselectedBorderFieldColor = Color(0xFF9E9E9E);

  static fromJson(Map<String, dynamic> json){
    mainColor = (json['main_color'] == null || json['main_color'] == '') ? mainColor : Color(int.parse(json['main_color']));
    textColor = (json['text_color'] == null || json['text_color'] == '') ? textColor : Color(int.parse(json['text_color']));
    unselectedTextColor = (json['unselected_text_color'] == null || json['unselected_text_color'] == '') ? unselectedTextColor : Color(int.parse(json['unselected_text_color']));
    additionalTextColor = (json['additional_text_color'] == null || json['additional_text_color'] == '') ? additionalTextColor : Color(int.parse(json['additional_text_color']));
    themeColor = (json['theme_color'] == null || json['theme_color'] == '') ? themeColor : Color(int.parse(json['theme_color']));
    fieldColor = (json['text_field_color'] == null || json['text_field_color'] == '') ? fieldColor : Color(int.parse(json['text_field_color']));
    elementsColor = (json['elements_color'] == null || json['elements_color'] == '') ? elementsColor : Color(int.parse(json['elements_color']));
    subElementsColor = (json['sub_elements_color'] == null || json['sub_elements_color'] == '') ? subElementsColor : Color(int.parse(json['sub_elements_color']));
    borderFieldColor = (json['border_field_color'] == null || json['border_field_color'] == '') ? borderFieldColor : Color(int.parse(json['border_field_color']));
    unselectedBorderFieldColor = (json['unselected_border_field_color'] == null || json['unselected_border_field_color'] == '') ? unselectedBorderFieldColor : Color(int.parse(json['unselected_border_field_color']));
  }
}

  String version;
  String buildNumber;

  getAppInfo() async {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      // String appName = packageInfo.appName;
      // String packageName = packageInfo.packageName;
      version = packageInfo.version;
      buildNumber = packageInfo.buildNumber;
    });
  }

class CheckVersion {
  CheckVersion._();

  static String updateVersion = CheckVersion.updateVersion;
  static bool updateRequire = false;

  static fromJson(Map<String, dynamic> json) {
    updateVersion = (json['version'] == null || json['version'] == '')
        ? updateVersion
        : json['version'];
    updateRequire = (json['require'] == null || json['require'] == '')
        ? updateRequire
        : json['require'];
  }
}

Future<bool> checkVer(BuildContext context, {bool show = true}) async {

  SharedPreferences prefs = await SharedPreferences.getInstance();
  print('version $version');

  bool hasUpdate =  Version.parse(CheckVersion.updateVersion) > Version.parse(version);

  if (show && hasUpdate &&
      (CheckVersion.updateRequire ||  prefs.get('deniedVersion') == null)) {
    showUpdateDialog(context, CheckVersion.updateRequire);
  }
  return hasUpdate;
}

showUpdateDialog(BuildContext context, bool critical) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Widget okButton = FlatButton(
    child: Text("Да"),
    onPressed: () {
      Navigator.pop(context);
      LaunchReview.launch(
          androidAppId: "com.prod.pomidor",
          iOSAppId: "1535636635");
    },
  );

  Widget denyButton = FlatButton(
    child: Text("Позже", style: TextStyle(color: Colors.red),),
    onPressed: () {
      prefs.setString('deniedVersion', CheckVersion.updateVersion);
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  var criticalAlert;
  if(Platform.isIOS){
    criticalAlert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      title: Text("Критическое обновление"),
      content: Text("Для дальнейшей работы необходимо обновить приложение."),
      actions: [
        okButton,
      ],
    );
  }else{
    criticalAlert = CupertinoAlertDialog(
      title: Text("Критическое обновление"),
      content: Text("Для дальнейшей работы необходимо обновить приложение."),
      actions: [
        okButton,
      ],
    );
  }

  var alert;
  if(Platform.isIOS){
    alert = CupertinoAlertDialog(
      title: Text("Доступно обновление"),
      content: Text("Обновить приложение?"),
      actions: [okButton, denyButton],
    );
  }else{
    alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      title: Text("Доступно обновление"),
      content: Text("Обновить приложение?"),
      actions: [okButton, denyButton],
    );
  }

  if(critical){
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: criticalAlert,
          );
        });
  }else{
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: alert,
          );
        });
  }
}


// User
final currentUser = User(
  cartModel: null,
  name: '',
);
//checking on internet connection
noConnection(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      Future.delayed(Duration(seconds: 1), () {
        Navigator.of(context).pop(true);
      });
      return Center(
        child: Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          child: Container(
            height: 50,
            width: 100,
            child: Center(
              child: Text("Нет подключения к интернету"),
            ),
          ),
        ),
      );
    },
  );
}

// ignore: must_be_immutable
// for screen's title with navigator.pop
class ScreenTitlePop extends StatefulWidget {
  String title = '';
  String img = '';

  ScreenTitlePop({Key key, this.title, this.img}) : super(key: key);

  @override
  ScreenTitlePopState createState() {
    return new ScreenTitlePopState(title, img);
  }
}

class ScreenTitlePopState extends State<ScreenTitlePop> {
  String title = '';
  String img = '';

  ScreenTitlePopState(this.title, this.img);

  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.only(top: 30),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: InkWell(
                  hoverColor: Colors.white,
                  focusColor: Colors.white,
                  splashColor: Colors.white,
                  highlightColor: Colors.white,
                  child: Container(
                      height: 50,
                      width: 55,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 17, bottom: 17, right: 10),
                        child: SvgPicture.asset(
                            img),
                      )),
                  onTap: (){
                    homeScreenKey = new GlobalKey<HomeScreenState>();
                    Navigator.of(context).pushAndRemoveUntil(
                        new MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) => RestaurantGetBloc(),
                            child: new HomeScreen(),
                          ),
                        ), (Route<dynamic> route) => false);
                  }
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 15),
                child: Text(
                  title,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF424242)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

//for screen's title with pushAndRemoveUntil
class ScreenTitlePushAndRemoveUntil extends StatefulWidget {
  String title = '';
  String img = '';

  ScreenTitlePushAndRemoveUntil({Key key, this.title, this.img}) : super(key: key);

  @override
  ScreenTitlePushAndRemoveUntilState createState() {
    return new ScreenTitlePushAndRemoveUntilState(title, img);
  }
}

class ScreenTitlePushAndRemoveUntilState extends State<ScreenTitlePushAndRemoveUntil> {
  String title = '';
  String img = '';

  ScreenTitlePushAndRemoveUntilState(this.title, this.img);

  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 30),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: InkWell(
              hoverColor: Colors.white,
              focusColor: Colors.white,
              splashColor: Colors.white,
              highlightColor: Colors.white,
              child: Container(
                  height: 50,
                  width: 60,
                  child: Padding(
                    padding:
                    EdgeInsets.only(top: 17, bottom: 17, right: 10),
                    child: SvgPicture.asset(
                        img),
                  )),
              onTap: () async {
                if (await Internet.checkConnection()) {
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
                  noConnection(context);
                }
              },
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(top: 15),
                child: Text(
                  title,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF424242)),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class Circular extends StatefulWidget {

  Circular({Key key}) : super(key: key);

  @override
  CircularState createState() {
    return new CircularState();
  }
}

class CircularState extends State<Circular> {

  CircularState();

  bool visible = false;

  Widget build(BuildContext context) {
    if(!visible){
      return Container();
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Container(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 1,
            backgroundColor: Colors.white,
          ),
        ),
      ),
    );
  }
}