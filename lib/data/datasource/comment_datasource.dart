import 'package:apple_shop_application/data/model/comment.dart';
import 'package:apple_shop_application/di/di.dart';
import 'package:apple_shop_application/util/api_exception.dart';
import 'package:apple_shop_application/util/auth_manager.dart';
import 'package:dio/dio.dart';

abstract class ICommentDatasource {
  Future<List<Comment>> getComments(String productId);
  Future<void> postComment(String productId, String comment);
}

class CommentRemoteDatasource extends ICommentDatasource {
  final Dio _dio = locator.get();
  final String userId = AuthManager.readId();
  @override
  Future<List<Comment>> getComments(String productId) async {
    try {
      Map<String, dynamic> qParams = {
        'filter': 'product_id="$productId"',
        'expand': 'user_id',
        'perPage': 500,
      };
      var response = await _dio.get('collections/comment/records',
          queryParameters: qParams);
      return response.data['items']
          .map<Comment>(
            (jsonObject) => Comment.fromJsonObject(jsonObject),
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

  @override
  Future<void> postComment(String productId, String comment) async {
    try {
      await _dio.post('collections/comment/records', data: {
        'text': comment,
        'user_id': userId,
        'product_id': productId,
      });
    } on DioException catch (ex) {
      throw ApiException(ex.response?.statusCode, ex.response?.data['message']);
    } catch (ex) {
      throw ApiException(0, 'unknown error');
    }
  }
}
