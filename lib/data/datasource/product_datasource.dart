import 'package:apple_shop_application/di/di.dart';
import 'package:apple_shop_application/data/model/product.dart';
import 'package:apple_shop_application/util/api_exception.dart';
import 'package:dio/dio.dart';

abstract class IProductDatasource {
  Future<List<Product>> getProducts();
  Future<List<Product>> getBestSellerProducts();
  Future<List<Product>> getHotestProducts();
  Future<List<Product>> getProductSearch(String keywordValue);
}

class ProductDatasource extends IProductDatasource {
  final Dio _dio = locator.get();
  @override
  Future<List<Product>> getProducts() async {
    try {
      var response = await _dio.get('collections/products/records');
      return (response.data['items'])
          .map<Product>(
            (jsonObject) => Product.fromJsonObject(jsonObject),
          )
          .toList();
    } on DioError catch (ex) {
      throw ApiException(
        ex.response?.statusCode,
        ex.response?.data['message'],
      );
    } catch (ex) {
      throw ApiException(0, 'unknown error');
    }
  }

  @override
  Future<List<Product>> getBestSellerProducts() async {
    try {
      Map<String, String> qParams = {'filter': 'popularity="Best Seller"'};
      var response = await _dio.get(
        'collections/products/records',
        queryParameters: qParams,
      );
      return (response.data['items'])
          .map<Product>(
            (jsonObject) => Product.fromJsonObject(jsonObject),
          )
          .toList();
    } on DioError catch (ex) {
      throw ApiException(
        ex.response?.statusCode,
        ex.response?.data['message'],
      );
    } catch (ex) {
      throw ApiException(0, 'unknown error');
    }
  }

  @override
  Future<List<Product>> getHotestProducts() async {
    try {
      Map<String, String> qParams = {'filter': 'popularity="Hotest"'};
      var response = await _dio.get(
        'collections/products/records',
        queryParameters: qParams,
      );
      return (response.data['items'])
          .map<Product>(
            (jsonObject) => Product.fromJsonObject(jsonObject),
          )
          .toList();
    } on DioError catch (ex) {
      throw ApiException(
        ex.response?.statusCode,
        ex.response?.data['message'],
      );
    } catch (ex) {
      throw ApiException(0, 'unknown error');
    }
  }

  @override
  Future<List<Product>> getProductSearch(String keywordValue) async {
    List<Product> productList = await getProducts();
    var productListBox = productList.where((element) {
      return element.name.toLowerCase().contains(keywordValue.toLowerCase());
    }).toList();
    return productListBox;
  }
}
