import 'package:flutter/material.dart';
import 'package:flutter_app/Internet/check_internet.dart';
import 'package:flutter_app/Screens/ChatScreen/View/chat_screen.dart';
import 'package:flutter_app/Screens/FAQScreen/API/get_filtered_faq.dart';
import 'package:flutter_app/Screens/FAQScreen/Model/FAQ.dart';
import 'package:flutter_app/Screens/FAQScreen/View/widgets/faq_item.dart';
import 'package:flutter_app/Screens/HomeScreen/Bloc/restaurant_get_bloc.dart';
import 'package:flutter_app/Screens/HomeScreen/View/home_screen.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../data/globalVariables.dart';

class FaqScreen extends StatelessWidget {
  buildFaqList(FAQData faqData) {
    List<Widget> result = [];
    result.add(SizedBox(height: 6.5));
    if (faqData.faqList != null || faqData.faqList.length != 0) {
      faqData.faqList.forEach(
        (element) {
          result.add(
            FaqItem(
              question: element.question,
              answer: element.answer,
              padding: EdgeInsets.only(left: 20, right: 20, top: 6, bottom: 6),
            ),
          );
        },
      );
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          leading: InkWell(
            hoverColor: Colors.white,
            focusColor: Colors.white,
            splashColor: Colors.white,
            highlightColor: Colors.white,
            child: Container(
              child: Padding(
                padding: EdgeInsets.all(19),
                child: SvgPicture.asset('assets/svg_images/arrow_left.svg'),
              ),
            ),
            onTap: () {
              homeScreenKey = new GlobalKey<HomeScreenState>();
              Navigator.of(context).pushAndRemoveUntil(
                  new MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => RestaurantGetBloc(),
                      child: new HomeScreen(),
                    ),
                  ),
                  (Route<dynamic> route) => false);
            },
          ),
          centerTitle: true,
          title: Text(
            'Помощь',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF424242)),
          ),
        ),
        bottomSheet: SafeArea(
          bottom: true,
          minimum: EdgeInsets.only(bottom: 15),
          child: InkWell(
            child: Padding(
              padding: const EdgeInsets.only(left: 31, right: 31),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColor.mainColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text('Написать в поддержку', style: TextStyle(fontSize: 18.0, color: AppColor.textColor)),
                ),
              ),
            ),
            onTap: () async {
              if (await Internet.checkConnection()) {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => new ChatScreen(),
                  ),
                );
              } else {
                noConnection(context);
              }
            },
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: FutureBuilder<FAQData>(
            future: getFilteredFaq(),
            initialData: null,
            builder: (BuildContext context, AsyncSnapshot<FAQData> snapshot) {
              if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
                return Column(
                  children: buildFaqList(snapshot.data),
                );
              } else {
                return Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.4),
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
        ));
  }
}
