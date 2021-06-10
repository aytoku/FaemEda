import 'package:flutter/material.dart';
import 'package:flutter_app/Internet/check_internet.dart';
import 'package:flutter_app/VersionControl/API/getCurrentVersion.dart';
import 'package:flutter_app/VersionControl/Model/CurrentVersionModel.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:launch_review/launch_review.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_app/VersionControl/API/getCurrentVersion.dart';
import 'package:flutter_app/VersionControl/Model/CurrentVersionModel.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AboutAppScreen extends StatefulWidget {
  @override
  AboutAppScreenState createState() => AboutAppScreenState();
}

class AboutAppScreenState extends State<AboutAppScreen> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Container(
          color: AppColor.themeColor,
          child: Stack(
            children: <Widget>[
              ScreenTitlePop(img: 'assets/svg_images/arrow_left.svg', title: 'О приложении'),
              Align(
                alignment: Alignment.center,
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
                    child: Column(
                      children: <Widget>[
                        Center(
                          child: Padding(
                              padding: EdgeInsets.only(top: 20, bottom: 10),
                              child: Image.asset('assets/images/tomato_logo.png', width: 300,)
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 25),
                          child: Center(
                              child: Text(
                                'Версия $version от 9 июня. 2021 г.\nсборка 5',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Color(0x97979797), fontSize: 15),
                              )
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: FutureBuilder<bool>(
                    future: checkVer(context, show: false),
                    builder: (context, AsyncSnapshot<bool> snapshot) {
                      if(snapshot.connectionState == ConnectionState.done && snapshot.data != null){
                        return (snapshot.data) ?
                        SafeArea(
                          bottom: true,
                          minimum: EdgeInsets.only(bottom: 15),
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.6),
                                  child: Center(
                                      child: Text('Доступна новая версия, хотите\nобновить?',
                                        style: TextStyle(
                                            fontSize: 18
                                        ),
                                        textAlign: TextAlign.center,
                                      )),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 15, right: 15),
                                  child: GestureDetector(
                                    child: Container(
                                      height: 52,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          color: AppColor.mainColor,
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Center(
                                        child: Text('Обновить',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.white
                                          ),
                                        ),
                                      ),
                                    ),
                                    onTap: (){
                                      LaunchReview.launch(
                                          androidAppId: "com.prod.pomidor", iOSAppId: "1535636635");
                                    },
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                            : Container();
                      }else{
                        return Container();
                      }
                    }
                ),
              )
            ],
          ),
        ));
  }
}