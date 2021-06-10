import 'package:flutter/material.dart';
import 'package:flutter_app/Internet/check_internet.dart';
import 'package:flutter_app/Screens/HomeScreen/Bloc/restaurant_get_bloc.dart';
import 'package:flutter_app/Screens/HomeScreen/View/home_screen.dart';
import 'package:flutter_app/Screens/MyAddressesScreen/Model/my_addresses_model.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'add_my_address_screen.dart';
import 'dart:io' show Platform;

class MyAddressesScreen extends StatefulWidget {
  @override
  MyAddressesScreenState createState() => MyAddressesScreenState();
}

class MyAddressesScreenState extends State<MyAddressesScreen> {
  List<MyFavouriteAddressesModel> myAddressesModelList;
  bool addressScreenButton = false;
  bool changeMode = false;


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          color: AppColor.themeColor,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 30, bottom: 0, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    InkWell(
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                              height: 40,
                              width: 60,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 12, bottom: 12, right: 10),
                                child: SvgPicture.asset(
                                    'assets/svg_images/arrow_left.svg'),
                              )
                          )
                      ),
                      onTap: () {
                        homeScreenKey = new GlobalKey<HomeScreenState>();
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) => RestaurantGetBloc(),
                                  child: new HomeScreen(),
                                )),
                                (Route<dynamic> route) => false);
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 0, left: 0, bottom: 0),
                      child: Text('Мои адреса',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF424242))),
                    ),
                    InkWell(
                      child: (changeMode) ? Text('Готово') : Text('Изменить'),
                      onTap: () async {
                        setState(() {
                          changeMode = !changeMode;
                        });
                      },
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Divider(height: 1, color: Colors.grey,),
              ),
              FutureBuilder<List<MyFavouriteAddressesModel>>(
                future: MyFavouriteAddressesModel.getAddresses(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<MyFavouriteAddressesModel>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    myAddressesModelList = snapshot.data;

                    if (addressScreenButton) {
                      myAddressesModelList
                          .add(new MyFavouriteAddressesModel(type: MyFavouriteAddressesModel.MyAddressesTags[0]));
                      myAddressesModelList
                          .add(new MyFavouriteAddressesModel(type: MyFavouriteAddressesModel.MyAddressesTags[1]));
                      myAddressesModelList
                          .add(new MyFavouriteAddressesModel(type: MyFavouriteAddressesModel.MyAddressesTags[2]));
                      addressScreenButton = false;
                    }
                    if(myAddressesModelList.isEmpty){
                      return Padding(
                        padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.35),
                        child: Center(
                          child: Text('У вас еще нет ни одного\nсохранённого адреса',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.70,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: ListView(
                              padding: EdgeInsets.zero,
                              children:
                              List.generate(myAddressesModelList.length, (index) {
                                if (myAddressesModelList[index].uuid ==
                                    null || myAddressesModelList[index].uuid == "") {
                                  return Column(
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                            padding: EdgeInsets.only(
                                                top: 0, left: 30, bottom: 0),
                                            child: GestureDetector(
                                                child: Container(
                                                  decoration: BoxDecoration(color: AppColor.themeColor),
                                                  padding: EdgeInsets.only(top: 15, bottom: 15),
                                                  child: Row(
                                                    children: <Widget>[
                                                      SvgPicture.asset(
                                                          'assets/svg_images/my_addresses_plus.svg'),
                                                      Padding(
                                                        padding:
                                                        EdgeInsets.only(left: 20),
                                                        child: Text(
                                                          (myAddressesModelList[index].type == MyFavouriteAddressesModel.MyAddressesTags[0]) ?
                                                          "Добавить адрес работы" : ((myAddressesModelList[index].type == MyFavouriteAddressesModel.MyAddressesTags[1]) ?
                                                          "Добавить адрес дома" : "Добавить адрес"),
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color:
                                                              AppColor.additionalTextColor),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                onTap: () async {
                                                  if (await Internet
                                                      .checkConnection()) {
                                                    Navigator.push(
                                                      context,
                                                      new MaterialPageRoute(
                                                        builder: (context) => new AddMyAddressScreen(myAddressesModel: myAddressesModelList[index],),
                                                      ),
                                                    );
                                                  } else {
                                                    noConnection(context);
                                                  }
                                                })),
                                      ),
                                      Divider(height: 1.0, color: Color(0xFFEDEDED)),
                                    ],
                                  );
                                }
                                return Padding(
                                  padding: const EdgeInsets.only(left: 15.0, right: 15, top: 10, bottom: 10),
                                  child: GestureDetector(
                                    child: Container(
                                      height: 110,
                                      width: MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.only(right: 10, left: 15),
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 4.0, // soften the shadow
                                              spreadRadius: 1.0, //extend the shadow
                                            )
                                          ],
                                          color: AppColor.themeColor,
                                          borderRadius: BorderRadius.circular(10.0),
                                          border: Border.all(width: 1.0, color: Colors.grey[200])),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(top: 30, right: 20),
                                                child: Container(
                                                  height: 70,
                                                  child: Column(
                                                    children: [
                                                      //(myAddressesModelList[index].tag = "Дом") != null ? SvgPicture.asset('assets/svg_images/home_my_addresses.svg') : SvgPicture.asset('assets/svg_images/star_my_addresses.svg'),
                                                      (myAddressesModelList[index].type == MyFavouriteAddressesModel.MyAddressesTags[0]) ?
                                                      SvgPicture.asset('assets/svg_images/work.svg') : ((myAddressesModelList[index].type == MyFavouriteAddressesModel.MyAddressesTags[1]) ?
                                                      SvgPicture.asset('assets/svg_images/home_my_addresses.svg') : SvgPicture.asset('assets/svg_images/star_my_addresses.svg')),
                                                      Text(
                                                        (myAddressesModelList[index].name != " ") ?
                                                        myAddressesModelList[index].name
                                                            :
                                                        "-",
                                                        style:
                                                        TextStyle(fontSize: 10, color: AppColor.additionalTextColor),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Flexible(
                                                child: Container(
                                                  height: 80,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Align(
                                                        alignment: Alignment.topLeft,
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(right: 10, bottom: 5),
                                                          child: Text(
                                                            myAddressesModelList[index].address.unrestrictedValue,
                                                            textAlign: TextAlign.left,
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                          'г.Владикавказ, республика Северная Осетия-Алания, Россия',
                                                          textAlign: TextAlign.left,
                                                          style: TextStyle(fontSize: 11, color: Color(0xFF9B9B9B))),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              (changeMode) ? Container(
                                                width: 50,
                                                height: 80,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(17.0),
                                                  child: InkWell(
                                                    child: SvgPicture.asset('assets/svg_images/Icon.svg'),
                                                    onTap: () async {
                                                      if(Platform.isAndroid){
                                                        return showDialog(
                                                          context: context,
                                                          builder: (BuildContext context) {
                                                            return Padding(
                                                              padding: EdgeInsets.only(bottom: 0),
                                                              child: Dialog(
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                                                                child: Container(
                                                                    height: 130,
                                                                    width: 300,
                                                                    child: Column(
                                                                      children: <Widget>[
                                                                        InkWell(
                                                                          child: Container(
                                                                            padding: EdgeInsets.only(top: 20, bottom: 20),
                                                                            child: Center(
                                                                              child: Text("Удалить адрес",
                                                                                style: TextStyle(
                                                                                    color: Color(0xFFFF3B30),
                                                                                    fontSize: 20
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          onTap: () async {
                                                                            await myAddressesModelList[index].delete();
                                                                            Navigator.pushReplacement(
                                                                              context,
                                                                              new MaterialPageRoute(
                                                                                builder: (context) =>
                                                                                new MyAddressesScreen(),
                                                                              ),
                                                                            );
                                                                          },
                                                                        ),
                                                                        Divider(
                                                                          height: 1,
                                                                          color: Colors.grey,
                                                                        ),
                                                                        InkWell(
                                                                          child: Container(
                                                                            padding: EdgeInsets.only(top: 20, bottom: 20),
                                                                            child: Center(
                                                                              child: Text("Отмена",
                                                                                style: TextStyle(
                                                                                    color: Color(0xFF007AFF),
                                                                                    fontSize: 20
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          onTap: (){
                                                                            Navigator.pop(context);
                                                                          },
                                                                        ),
                                                                      ],
                                                                    )),
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      }
                                                      return showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) {
                                                          return Container(
                                                            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.65),
                                                            child: Column(
                                                              children: [
                                                                Dialog(
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                                                  child: InkWell(
                                                                    child: Container(
                                                                      height: 50,
                                                                      width: 100,
                                                                      child: Center(
                                                                        child: Text("Удалить адрес",
                                                                          style: TextStyle(
                                                                              color: Color(0xFFFF3B30),
                                                                              fontSize: 20
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    onTap: () async {
                                                                      await myAddressesModelList[index].delete();
                                                                      Navigator.pushReplacement(
                                                                        context,
                                                                        new MaterialPageRoute(
                                                                          builder: (context) =>
                                                                          new MyAddressesScreen(),
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                                Dialog(
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                                                  child: InkWell(
                                                                    child: Container(
                                                                      height: 50,
                                                                      width: 100,
                                                                      child: Center(
                                                                        child: Text("Отмена",
                                                                          style: TextStyle(
                                                                              color: Color(0xFF007AFF),
                                                                              fontSize: 20
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    onTap: (){
                                                                      Navigator.pop(context);
                                                                    },
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ) : Container()
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    onTap: () async {
                                      if (await Internet.checkConnection()) {
                                        Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (context) {
                                                return new AddMyAddressScreen(
                                                  myAddressesModel:
                                                  myAddressesModelList[index],
                                                );
                                              }),
                                        );
                                      } else {
                                        noConnection(context);
                                      }
                                    },
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Padding(
                      padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
                      child: Center(
                        child: SpinKitFadingCircle(
                          color: AppColor.mainColor,
                          size: 50.0,
                        ),
                      ),
                    );
                  }
                },
              ),
              (addressScreenButton) ? Container() : Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20.0, right: 10, left: 10),
                    child: FlatButton(
                      child: Text('Добавить адрес',
                          style: TextStyle(
                              fontSize: 16.0,
                              color: AppColor.textColor)),
                      color: AppColor.mainColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.only(left: 100, top: 20, right: 100, bottom: 20),
                      onPressed: () async {
                        if (await Internet.checkConnection()) {
                          setState(() {
                            addressScreenButton = true;
                          });
                        } else {
                          noConnection(context);
                        }
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        )
    );
  }
}