import 'package:apple_shop_application/bloc/home/home_event.dart';
import 'package:apple_shop_application/bloc/home/home_state.dart';
import 'package:apple_shop_application/data/repository/banner_repository.dart';
import 'package:apple_shop_application/data/repository/category_repository.dart';
import 'package:apple_shop_application/data/repository/product_repository.dart';
import 'package:apple_shop_application/di/di.dart';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final IBannerRepository _bannerRepository = locator.get();
  final ICategoryRepository _categoryRepository = locator.get();
  final IProductRepository _productRepository = locator.get();
  HomeBloc() : super(HomeInitState()) {
    on<HomeGetInitilzeData>(
      (event, emit) async {
        emit(HomeLoadinState());
        var bannerList = await _bannerRepository.getBanners();
        var categoryList = await _categoryRepository.getCategorys();
        var productList = await _productRepository.getProducts();
        var bestSellerProductList =
            await _productRepository.getBestSellerProducts();
        var hotestProductList = await _productRepository.getHotestProducts();
        emit(
          HomeRequestSuccessState(
            bannerList,
            categoryList,
            productList,
            bestSellerProductList,
            hotestProductList,
          ),
        );
      },
    );

    on<HomeSearchProductsEvent>(
      (event, emit) async {
        var response =
            await _productRepository.getProductSearch(event.keywordVale);
        emit(
          HomeSearchProductsState(response),
        );
        if (event.keywordVale.isEmpty) {
          add(HomeGetInitilzeData());
        }
      },
    );
  }
}
