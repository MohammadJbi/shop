import 'package:apple_shop_application/data/model/banner.dart';
import 'package:apple_shop_application/data/model/category.dart';
import 'package:apple_shop_application/data/model/product.dart';
import 'package:dartz/dartz.dart';

abstract class HomeState {}

class HomeInitState implements HomeState {}

class HomeLoadinState implements HomeState {}

class HomeRequestSuccessState implements HomeState {
  Either<String, List<BannerCampain>> bannerList;
  Either<String, List<Category>> categoryList;
  Either<String, List<Product>> productList;
  Either<String, List<Product>> bestSellerProductList;
  Either<String, List<Product>> hotestProductList;

  HomeRequestSuccessState(
    this.bannerList,
    this.categoryList,
    this.productList,
    this.bestSellerProductList,
    this.hotestProductList,
  );
}

class HomeSearchLoadingState extends HomeState {}

class HomeSearchProductsState extends HomeState {
  Either<String, List<Product>> response;
  HomeSearchProductsState(this.response);
}
