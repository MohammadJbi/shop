import 'package:apple_shop_application/data/datasource/banner_datasource.dart';
import 'package:apple_shop_application/di/di.dart';
import 'package:apple_shop_application/data/model/banner.dart';
import 'package:apple_shop_application/util/api_exception.dart';
import 'package:dartz/dartz.dart';

abstract class IBannerRepository {
  Future<Either<String, List<BannerCampain>>> getBanners();
}

class BannerRepository implements IBannerRepository {
  final IBannerDatasource _dataSource = locator.get();
  @override
  Future<Either<String, List<BannerCampain>>> getBanners() async {
    try {
      List<BannerCampain> response = await _dataSource.getBanners();
      return Right(response);
    } on ApiException catch (ex) {
      return Left(ex.message ?? 'خطا, محتوایی برای نمایش وجود ندارد');
    }
  }
}
