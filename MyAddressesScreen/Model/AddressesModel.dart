import 'dart:convert';

import 'my_addresses_model.dart';


class AddressesModelData{
  List<MyFavouriteAddressesModel> addressModelList;

  AddressesModelData( {
    this.addressModelList,
  });

  factory AddressesModelData.fromJson(List<dynamic> parsedJson){
    List<MyFavouriteAddressesModel> favouriteAddressList = null;
    if(parsedJson != null){
      favouriteAddressList = parsedJson.map((i) => MyFavouriteAddressesModel.fromJson(i)).toList();
    }

    return AddressesModelData(
      addressModelList:favouriteAddressList,
    );
  }
}
