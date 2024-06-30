import 'package:apple_shop_application/data/datasource/comment_datasource.dart';
import 'package:apple_shop_application/data/model/comment.dart';
import 'package:apple_shop_application/di/di.dart';
import 'package:apple_shop_application/util/api_exception.dart';
import 'package:dartz/dartz.dart';

abstract class ICommentRepository {
  Future<Either<String, List<Comment>>> getComments(String productId);
  Future<Either<String, String>> postComment(String productId, String comment);
}

class CommentRepository extends ICommentRepository {
  final ICommentDatasource _datasource = locator.get();
  @override
  Future<Either<String, List<Comment>>> getComments(String productId) async {
    try {
      List<Comment> response = await _datasource.getComments(productId);
      return Right(response);
    } on ApiException catch (ex) {
      return Left(ex.message ?? 'خطا, محتوایی برای نمایش وجود ندارد');
    }
  }

  @override
  Future<Either<String, String>> postComment(
      String productId, String comment) async {
    try {
      await _datasource.postComment(productId, comment);
      return const Right('نظر شما ثبت شد');
    } on ApiException catch (ex) {
      return Left(ex.message ?? 'خطا, محتوایی برای نمایش وجود ندارد');
    }
  }
}
