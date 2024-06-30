import 'package:apple_shop_application/data/model/category.dart';
import 'package:apple_shop_application/data/model/product_image.dart';
import 'package:apple_shop_application/data/model/product_variant.dart';
import 'package:apple_shop_application/data/model/property.dart';

import 'package:dartz/dartz.dart';

abstract class ProductState {}

class ProductInitState extends ProductState {}

class ProductDetailLoadingState extends ProductState {}

class ProductDetailResponseState extends ProductState {
  Either<String, List<ProductImage>> productImages;
  Either<String, List<ProductVariant>> productVariant;
  Either<String, Category> productCategory;
  Either<String, List<Property>> productProperties;

  ProductDetailResponseState(
    this.productImages,
    this.productVariant,
    this.productCategory,
    this.productProperties,
  );
}

class ProductDetailAddToBasketState extends ProductState {
  Either<String, String> successMessageAddProduct;
  ProductDetailAddToBasketState(this.successMessageAddProduct);
}
