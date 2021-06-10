import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/CityScreen/API/getFilteredCities.dart';
import 'package:flutter_app/Screens/CityScreen/Model/FilteredCities.dart';
import 'package:flutter_app/data/data.dart';
import 'package:flutter_app/data/globalVariables.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../Config/config.dart';
import '../../MyAddressesScreen/Model/NecessaryAddressModel.dart';
import 'city_screen.dart';

class CityAutocomplete extends StatefulWidget {
  GlobalKey<CityAutocompleteState> key;
  AsyncCallback onSelected;
  String initialValue;
  CityAutocomplete(this.key, {this.onSelected, this.initialValue}) : super(key: key);

  @override
  CityAutocompleteState createState() {
    return new CityAutocompleteState(onSelected, initialValue);
  }
}

class CityAutocompleteState extends State<CityAutocomplete> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;
  CityAutocompleteState(this.onSelected, this.initialValue);
  String initialValue;
  List<FilteredCities> suggestions;
  TextEditingController controller;
  AutocompleteList autocompleteList;
  FilteredCities selectedValue;
  AsyncCallback onSelected;
  FocusNode node;

  @override
  void initState(){
    autocompleteList = AutocompleteList(suggestions, this, new GlobalKey(), initialValue);
    controller = new TextEditingController(text: (initialValue != null) ? initialValue :  '');
    suggestions = new List<FilteredCities>();
    node = new FocusNode();
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
    controller.dispose();
    node.dispose();
  }

  Widget build(BuildContext context) {
    return Container(
      color: AppColor.themeColor,
      child: Column(
        children: [
          // Container(
          //     child: Row(
          //       children: [
          //         Stack(
          //           children: [
          //             Container(
          //               padding: const EdgeInsets.only(top: 15),
          //               width: MediaQuery.of(context).size.width * 0.9,
          //               child: TextField(
          //                 controller: controller,
          //                 focusNode: node,
          //                 decoration: new InputDecoration(
          //                   suffix: Padding(
          //                     padding: const EdgeInsets.only(right:8.0, top: 3),
          //                     child: Cross(controller, autocompleteList),
          //                   ),
          //                   contentPadding: EdgeInsets.only(left: 10, right: 5, bottom: 10),
          //                   border: OutlineInputBorder(
          //                       borderRadius: BorderRadius.circular(10)),
          //                 ),
          //                 onChanged: (text) async {
          //                   var temp = await findAddress(text);
          //                   if(temp != null && autocompleteList.autoCompleteListKey.currentState != null){
          //                     autocompleteList.autoCompleteListKey.currentState.setState(() {
          //                       autocompleteList.autoCompleteListKey.currentState.suggestions = temp;
          //                     });
          //                   }
          //                 },
          //               ),
          //             ),
          //             Align(
          //                 alignment: Alignment.topLeft,
          //                 child: Padding(
          //                   padding: const EdgeInsets.only(left: 20),
          //                   child: Container(
          //                     color: Colors.white,
          //                     child: Padding(
          //                       padding: EdgeInsets.all(5),
          //                       child: Text(
          //                         'Город',
          //                         style: TextStyle(
          //                             fontSize: 12,
          //                             color: Colors.grey
          //                         ),
          //                       ),
          //                     ),
          //                   ),
          //                 )
          //             ),
          //           ],
          //         ),
          //       ],
          //     )
          // ),
          autocompleteList
        ],
      ),
    );
  }

  Future<List<FilteredCities>> findAddress(String searchText) async {
    // Результирующий список
    List<FilteredCities> necessaryAddressDataItems;

    try {
      // Если в поле автокомплита был введен текст
      if (true) {
        // то получаем релеватные подсказки с сервера
        necessaryAddressDataItems =
            (await getFilteredCities()).filteredCitiesList;
      }
//      else {
//        // иначе получаем список рекомендаций для заполнения с того же сервера
//        List<RecommendationAddressModel> temp = await RecommendationAddress.getRecommendations("target");
//        // который загоняем в подсказски автокомплита
//        necessaryAddressDataItems = temp.map<FilteredCities>((item) => item.address).toList();
//      }
    }
    catch (e) {
      print("Error getting addresses.");
    }
    return necessaryAddressDataItems;
  }
}


class AutocompleteList extends StatefulWidget {
  List<FilteredCities> suggestions;
  CityAutocompleteState parent;
  String initialValue;
  GlobalKey<AutocompleteListState> autoCompleteListKey;
  AutocompleteList(this.suggestions, this.parent, this.autoCompleteListKey, this.initialValue) : super(key: autoCompleteListKey);

  @override
  AutocompleteListState createState() {
    return new AutocompleteListState(suggestions, parent, initialValue);
  }
}

class AutocompleteListState extends State<AutocompleteList> {

  List<FilteredCities> suggestions;
  CityAutocompleteState parent;
  String initialValue;
  AutocompleteListState(this.suggestions, this.parent, this.initialValue);

  @override
  void initState(){
    super.initState();
    suggestions = new List<FilteredCities>();
  }


  Widget suggestionRow(){
    return Container(
      width: MediaQuery.of(context).size.width,
      color: AppColor.themeColor,
      height: MediaQuery.of(context).size.height * 0.65,
      child: ListView(
          padding: EdgeInsets.zero,
          children: List.generate(suggestions.length, (index){
            return InkWell(
              child: Padding(
                  padding: const EdgeInsets.only(left: 5, top: 10, right: 15, bottom: 0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(suggestions[index].name,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 16
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(suggestions[index].meta.description,
                            style: TextStyle(
                                fontSize: 12,
                                color: AppColor.additionalTextColor
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Divider(color: Colors.grey,),
                        )
                      ],
                    ),
                  )
              ),
              onTap: () async {
                parent.selectedValue = suggestions[index];
                parent.controller.text = suggestions[index].name;
                selectedCity = parent.selectedValue;
                //ecessaryDataForAuth.city = selectedCity;
                await NecessaryDataForAuth.saveData();
                Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => new CityScreen()),
                );
                // Избегаем потери фокуса и ставим курсор в конец
                // parent.node.requestFocus();
                // parent.controller.selection = TextSelection.fromPosition(TextPosition(offset: parent.controller.text.length));
                // if(parent.onSelected != null){
                //   await parent.onSelected();
                // }
                // FocusScope.of(context).requestFocus(new FocusNode());
              },
            );
          })
      ),
    );
  }

  Widget build(BuildContext context) {
    if(suggestions == null || suggestions.length == 0){
      return FutureBuilder(
        future: parent.findAddress((initialValue == null) ? '' : initialValue),
        builder: (BuildContext context, AsyncSnapshot<List<FilteredCities>> snapshot){
          if(snapshot.hasData){
            if(snapshot.connectionState == ConnectionState.done){
              if(snapshot.data != null){
                suggestions = snapshot.data;
              }
              return suggestionRow();
            }
          }
          return Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Center(
              child: SpinKitThreeBounce(
                color: AppColor.mainColor,
                size: 20.0,
              ),
            ),
          );
        },
      );
    }
    return suggestionRow();
  }
}