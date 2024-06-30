import 'package:apple_shop_application/data/datasource/product_detail_datasource.dart';
import 'package:apple_shop_application/data/model/category.dart';
import 'package:apple_shop_application/data/model/product_variant.dart';
import 'package:apple_shop_application/data/model/property.dart';
import 'package:apple_shop_application/data/model/variant_type.dart';
import 'package:apple_shop_application/di/di.dart';
import 'package:apple_shop_application/data/model/product_image.dart';
import 'package:apple_shop_application/util/api_exception.dart';
import 'package:dartz/dartz.dart';

abstract class IDetailProductRepository {
  Future<Either<String, List<ProductImage>>> getProductImages(String productId);
  Future<Either<String, List<VariantType>>> getVariantTypes();
  Future<Either<String, List<ProductVariant>>> getProductVariants(
      String productId);
  Future<Either<String, Category>> getProductCategory(String productId);
  Future<Either<String, List<Property>>> getProductProperties(String productId);
}

class DetailProductRepository extends IDetailProductRepository {
  final IDetailProductDatasource _dataSource = locator.get();

  @override
  Future<Either<String, List<ProductImage>>> getProductImages(
    String productId,
  ) async {
    try {
      List<ProductImage> response = await _dataSource.getGallery(productId);
      return Right(response);
    } on ApiException catch (ex) {
      return Left(ex.message ?? 'خطا, محتوایی برای نمایش وجود ندارد');
    }
  }

  @override
  Future<Either<String, List<VariantType>>> getVariantTypes() async {
    try {
      List<VariantType> response = await _dataSource.getVariantTypes();
      return Right(response);
    } on ApiException catch (ex) {
      return Left(ex.message ?? 'خطا, محتوایی برای نمایش وجود ندارد');
    }
  }

  @override
  Future<Either<String, List<ProductVariant>>> getProductVariants(
      String productId) async {
    try {
      List<ProductVariant> response =
          await _dataSource.getProductVariants(productId);
      return Right(response);
    } on ApiException catch (ex) {
      return Left(ex.message ?? 'خطا, محتوایی برای نمایش وجود ندارد');
    }
  }

  @override
  Future<Either<String, Category>> getProductCategory(String productId) async {
    try {
      Category response = await _dataSource.getProductCategory(productId);
      return Right(response);
    } on ApiException catch (ex) {
      return Left(ex.message ?? 'خطا, محتوایی برای نمایش وجود ندارد');
    }
  }

  @override
  Future<Either<String, List<Property>>> getProductProperties(
      String productId) async {
    try {
      List<Property> response =
          await _dataSource.getProductProperties(productId);
      return Right(response);
    } on ApiException catch (ex) {
      return Left(ex.message ?? 'خطا, محتوایی برای نمایش وجود ندارد');
    }
  }
}
