import 'package:apple_shop_application/data/model/category.dart';
import 'package:apple_shop_application/data/model/product_variant.dart';
import 'package:apple_shop_application/data/model/property.dart';
import 'package:apple_shop_application/data/model/variant.dart';
import 'package:apple_shop_application/data/model/variant_type.dart';
import 'package:apple_shop_application/di/di.dart';
import 'package:apple_shop_application/data/model/product_image.dart';
import 'package:apple_shop_application/util/api_exception.dart';
import 'package:dio/dio.dart';

abstract class IDetailProductDatasource {
  Future<List<ProductImage>> getGallery(String productId);
  Future<List<VariantType>> getVariantTypes();
  Future<List<Variant>> getVariant(String productId);
  Future<List<ProductVariant>> getProductVariants(String productId);
  Future<Category> getProductCategory(String categoryId);
  Future<List<Property>> getProductProperties(String productId);
}

class DetailProductRemoteDatasource extends IDetailProductDatasource {
  final Dio _dio = locator.get();
  @override
  Future<List<ProductImage>> getGallery(String productId) async {
    try {
      Map<String, String> qParams = {'filter': 'product_id="$productId"'};
      var response = await _dio.get('collections/gallery/records',
          queryParameters: qParams);
      return (response.data['items'])
          .map<ProductImage>(
            (jsonObject) => ProductImage.fromJsonObject(jsonObject),
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
  Future<List<VariantType>> getVariantTypes() async {
    try {
      var response = await _dio.get('collections/variants_type/records');
      return (response.data['items'])
          .map<VariantType>(
            (jsonObject) => VariantType.fromJsonObject(jsonObject),
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
  Future<List<Variant>> getVariant(String productId) async {
    try {
      Map<String, String> qParams = {'filter': 'product_id="$productId"'};
      var response = await _dio.get('collections/variants/records',
          queryParameters: qParams);
      return response.data['items']
          .map<Variant>(
            (jsonObject) => Variant.fromJsonObject(jsonObject),
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
  Future<List<ProductVariant>> getProductVariants(String productId) async {
    var variantTypeList = await getVariantTypes();
    var variantList = await getVariant(productId);

    List<ProductVariant> productVariantList = [];

    try {
      for (var variantType in variantTypeList) {
        var variant = variantList
            .where(
              (element) => element.typeId == variantType.id,
            )
            .toList();
        productVariantList.add(
          ProductVariant(variantType, variant),
        );
      }
    } on DioError catch (ex) {
      throw ApiException(
        ex.response?.statusCode,
        ex.response?.data['message'],
      );
    } catch (ex) {
      throw ApiException(0, 'unknown error');
    }
    return productVariantList;
  }

  @override
  Future<Category> getProductCategory(String categoryId) async {
    try {
      Map<String, String> qParams = {'filter': 'id="$categoryId"'};
      var response = await _dio.get(
        'collections/category/records',
        queryParameters: qParams,
      );
      return Category.fromJsonObject(response.data['items'][0]);
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
  Future<List<Property>> getProductProperties(String productId) async {
    try {
      Map<String, String> qParams = {'filter': 'product_id="$productId"'};
      var response = await _dio.get('collections/properties/records',
          queryParameters: qParams);
      return response.data['items']
          .map<Property>(
            (jsonObject) => Property.fromJsonObject(jsonObject),
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
}
