import 'package:apple_shop_application/data/datasource/product_datasource.dart';
import 'package:apple_shop_application/di/di.dart';
import 'package:apple_shop_application/data/model/product.dart';
import 'package:apple_shop_application/util/api_exception.dart';
import 'package:dartz/dartz.dart';

abstract class IProductRepository {
  Future<Either<String, List<Product>>> getProducts();
  Future<Either<String, List<Product>>> getBestSellerProducts();
  Future<Either<String, List<Product>>> getHotestProducts();
  Future<Either<String, List<Product>>> getProductSearch(String query);
}

class ProductRepository implements IProductRepository {
  final IProductDatasource _dataSource = locator.get();
  @override
  Future<Either<String, List<Product>>> getProducts() async {
    try {
      List<Product> response = await _dataSource.getProducts();
      return Right(response);
    } on ApiException catch (ex) {
      return Left(ex.message ?? 'خطا, محتوایی برای نمایش وجود ندارد');
    }
  }

  @override
  Future<Either<String, List<Product>>> getBestSellerProducts() async {
    try {
      List<Product> response = await _dataSource.getBestSellerProducts();
      return Right(response);
    } on ApiException catch (ex) {
      return Left(ex.message ?? 'خطا, محتوایی برای نمایش وجود ندارد');
    }
  }

  @override
  Future<Either<String, List<Product>>> getHotestProducts() async {
    try {
      List<Product> response = await _dataSource.getHotestProducts();
      return Right(response);
    } on ApiException catch (ex) {
      return Left(ex.message ?? 'خطا, محتوایی برای نمایش وجود ندارد');
    }
  }

  @override
  Future<Either<String, List<Product>>> getProductSearch(query) async {
    try {
      List<Product> response = await _dataSource.getProductSearchResult(query);
      return Right(response);
    } on ApiException catch (ex) {
      return Left(ex.message ?? 'خطا, محتوایی برای نمایش وجود ندارد');
    }
  }
}
