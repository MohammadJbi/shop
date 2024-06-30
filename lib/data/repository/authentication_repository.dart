import 'package:apple_shop_application/data/datasource/authentication_datasource.dart';
import 'package:apple_shop_application/di/di.dart';
import 'package:apple_shop_application/util/api_exception.dart';
import 'package:dartz/dartz.dart';

abstract class IAuthenRepository {
  Future<Either<String, String>> register(
      String username, String password, String passwordConfirm);

  Future<Either<String, String>> login(String username, String password);
}

class AuthenticationRepository implements IAuthenRepository {
  final IAuthenticationDatasource _dataSource = locator.get();

  @override
  Future<Either<String, String>> register(
      String username, String password, String passwordConfirm) async {
    try {
      await _dataSource.register(username, password, passwordConfirm);
      return const Right('ثبت نام با موفقیت انجام شد.');
    } on ApiException catch (ex) {
      return Left(ex.message ?? 'خطا محتوایی موجود نیست.');
    }
  }

  @override
  Future<Either<String, String>> login(String username, String password) async {
    try {
      String token = await _dataSource.login(username, password);
      if (token.isNotEmpty) {
        return const Right('ورود با موفقیت انجام شد');
      } else {
        return const Left('خطایی در ورود رخ داده است');
      }
    } on ApiException catch (ex) {
      return Left('${ex.message}');
    }
  }
}
