import 'package:apple_shop_application/data/model/comment.dart';
import 'package:apple_shop_application/data/repository/comment_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';

part 'comment_event.dart';
part 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final ICommentRepository commentRepository;
  CommentBloc(this.commentRepository) : super(CommentLoadingState()) {
    on<CommentInitialEvent>((event, emit) async {
      final comments = await commentRepository.getComments(event.productId);
      emit(CommentResponseState(comments));
    });

    on<CommentPostEvent>(
      (event, emit) async {
        emit(CommentLoadingState());

        await commentRepository.postComment(event.productId, event.comment);
        final comments = await commentRepository.getComments(event.productId);
        emit(CommentResponseState(comments));
      },
    );
  }
}
