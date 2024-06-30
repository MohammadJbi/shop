import 'package:apple_shop_application/data/datasource/category_product_datasource.dart';
import 'package:apple_shop_application/data/model/product.dart';
import 'package:apple_shop_application/di/di.dart';
import 'package:apple_shop_application/util/api_exception.dart';
import 'package:dartz/dartz.dart';

abstract class ICategoryProductRepository {
  Future<Either<String, List<Product>>> getProductByCategoryId(
      String categoryId);
}

class CategoryProductRepository extends ICategoryProductRepository {
  final ICategoryProductDatasource _dataSource = locator.get();
  @override
  Future<Either<String, List<Product>>> getProductByCategoryId(
    String categoryId,
  ) async {
    try {
      List<Product> response =
          await _dataSource.getProductByCategoryId(categoryId);
      return Right(response);
    } on ApiException catch (ex) {
      return Left(ex.message ?? 'خطا, محتوایی برای نمایش وجود ندارد');
    }
  }
}
