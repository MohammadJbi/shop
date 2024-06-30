import 'package:apple_shop_application/di/di.dart';
import 'package:apple_shop_application/data/model/category.dart';
import 'package:apple_shop_application/util/api_exception.dart';
import 'package:dio/dio.dart';

abstract class ICategoryDatasource {
  Future<List<Category>> getCategorys();
}

class CategoryDatasource extends ICategoryDatasource {
  final Dio _dio = locator.get();
  @override
  Future<List<Category>> getCategorys() async {
    try {
      var response = await _dio.get('collections/category/records');
      return response.data['items']
          .map<Category>(
            (jsonObject) => Category.fromJsonObject(jsonObject),
          )
          .toList();
    } on DioException catch (ex) {
      throw ApiException(
        ex.response?.statusCode,
        ex.response?.data['message'],
      );
    } catch (ex) {
      throw ApiException(0, 'unknown error');
    }
  }
}
