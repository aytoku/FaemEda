import 'package:equatable/equatable.dart';
import 'package:flutter_app/Screens/HomeScreen/Model/AllStoreCategories.dart';



abstract class RestaurantEvent extends Equatable {
  const RestaurantEvent();
}

class CategoryFilterApplied extends RestaurantEvent {
  final AllStoreCategories category;
  final List<AllStoreCategories> categories;
  final bool selectedCategoryFromHomeScreen;

  const CategoryFilterApplied({this.category, this.selectedCategoryFromHomeScreen, this.categories});

  @override
  List<Object> get props => [category.uuid, category];

}

class InitialLoad extends RestaurantEvent {
  @override
  List<Object> get props => [];

  @override
  String toString() => 'CategoryChanged';
}