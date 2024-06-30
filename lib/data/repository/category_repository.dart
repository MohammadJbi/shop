import 'package:apple_shop_application/data/datasource/category_datasource.dart';
import 'package:apple_shop_application/di/di.dart';
import 'package:apple_shop_application/data/model/category.dart';
import 'package:apple_shop_application/util/api_exception.dart';
import 'package:dartz/dartz.dart';

abstract class ICategoryRepository {
  Future<Either<String, List<Category>>> getCategorys();
}

class CategoryRepository extends ICategoryRepository {
  final ICategoryDatasource _datasource = locator.get();

  @override
  Future<Either<String, List<Category>>> getCategorys() async {
    try {
      List<Category> response = await _datasource.getCategorys();
      return Right(response);
    } on ApiException catch (ex) {
      return Left(ex.message ?? 'خطا, محتوایی برای نمایش وجود ندارد');
    }
  }
}
