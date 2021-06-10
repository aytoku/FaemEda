import 'package:flutter_app/Screens/CartScreen/Model/CartModel.dart';

class User{
  bool isLoggedIn;
  String name;
  CartModel cartModel;
  String phone;

  User({
    this.isLoggedIn = true,
    this.name,
    this.cartModel,
    this.phone
  });
}