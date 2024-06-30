import 'package:apple_shop_application/data/model/category.dart';
import 'package:dartz/dartz.dart';

abstract class CategoryState {}

class CategoryInitState implements CategoryState {}

class CategoryLoadingState implements CategoryState {}

class CategoryResponseState implements CategoryState {
  Either<String, List<Category>> response;

  CategoryResponseState(this.response);
}
