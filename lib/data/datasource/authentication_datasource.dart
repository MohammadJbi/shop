import 'package:apple_shop_application/util/api_exception.dart';
import 'package:apple_shop_application/util/auth_manager.dart';
import 'package:apple_shop_application/util/dio_provider.dart';
import 'package:dio/dio.dart';

abstract class IAuthenticationDatasource {
  Future<void> register(
      String username, String password, String passwordConfirm);

  Future<String> login(String username, String password);
}

class AuthenticationRemote implements IAuthenticationDatasource {
  final Dio _dio = DioProvider.createDioWithoutHeader();

  @override
  Future<void> register(
      String username, String password, String passwordConfirm) async {
    try {
      final response = await _dio.post(
        'collections/users/records',
        data: {
          'username': username,
          'name': username,
          'password': password,
          'passwordConfirm': passwordConfirm,
        },
      );
      if (response.statusCode == 200) {
        login(username, password);
      }
    } on DioException catch (ex) {
      throw ApiException(ex.response?.statusCode, ex.response?.data['message'],
          response: ex.response);
    } catch (ex) {
      throw ApiException(0, 'unknown error');
    }
  }

  @override
  Future<String> login(String username, String password) async {
    try {
      var response =
          await _dio.post('collections/users/auth-with-password', data: {
        'identity': username,
        'password': password,
      });
      if (response.statusCode == 200) {
        AuthManager.saveToken(response.data['token']);
        AuthManager.saveId(response.data['record']['id']);

        return response.data['token'];
      }
    } on DioException catch (ex) {
      throw ApiException(
        ex.response?.statusCode,
        ex.response?.data['message'],
      );
    } catch (ex) {
      throw ApiException(0, 'unknown error');
    }
    return '';
  }
}
