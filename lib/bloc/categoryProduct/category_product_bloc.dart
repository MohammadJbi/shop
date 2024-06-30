import 'package:apple_shop_application/bloc/categoryProduct/category_product_event.dart';
import 'package:apple_shop_application/bloc/categoryProduct/category_product_state.dart';
import 'package:apple_shop_application/data/repository/category_product_repository.dart';
import 'package:apple_shop_application/di/di.dart';
import 'package:bloc/bloc.dart';

class CategoryProductBloc
    extends Bloc<CategoryProductEvent, CategoryProductState> {
  final ICategoryProductRepository _categoryProductRepository = locator.get();
  CategoryProductBloc() : super(CategoryProductLoadingState()) {
    on<CategoryProductInitialize>(
      (event, emit) async {
        emit(CategoryProductLoadingState());
        var productListByCategory = await _categoryProductRepository
            .getProductByCategoryId(event.categoryId);
        emit(CategoryProductResponseSuccessState(productListByCategory));
      },
    );
  }
}
