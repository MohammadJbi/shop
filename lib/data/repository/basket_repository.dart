import 'package:apple_shop_application/data/datasource/basket_datasource.dart';
import 'package:apple_shop_application/data/model/basket_item.dart';
import 'package:apple_shop_application/di/di.dart';
import 'package:dartz/dartz.dart';

abstract class IBasketRepository {
  Future<Either<String, String>> addProductToBasket(BasketItem basketItem);
  Future<Either<String, List<BasketItem>>> getAllBasketItems();
  Future<int> getBasketFinalPrice();
  Future<Either<String, String>> removeProduct(int index);
  Future<void> removeAllProduct();
}

class BasketRepository extends IBasketRepository {
  final IBasketDatasource _datasource = locator.get();
  @override
  Future<Either<String, String>> addProductToBasket(
      BasketItem basketItem) async {
    try {
      _datasource.addProduct(basketItem);
      return const Right('محصول با موفقیت به سبد خرید افزوده شد');
    } catch (ex) {
      return const Left('خطا در افزودن محصول در سبد خرید');
    }
  }

  @override
  Future<Either<String, List<BasketItem>>> getAllBasketItems() async {
    try {
      List<BasketItem> basketItemList = await _datasource.getAllBasketItems();
      return Right(basketItemList);
    } catch (ex) {
      return const Left('خطا در نمایش محصولات');
    }
  }

  @override
  Future<int> getBasketFinalPrice() async {
    int basketItemsRealPrice = await _datasource.getBasketFinalPrice();
    return basketItemsRealPrice;
  }

  @override
  Future<Either<String, String>> removeProduct(int index) async {
    try {
      _datasource.removeProduct(index);
      return const Right('محصول مورد نظر از سبد خرید شما حذف شد');
    } catch (ex) {
      return const Left('خطا در حذف محصول از سبد خرید شما');
    }
  }

  @override
  Future<void> removeAllProduct() async {
    _datasource.removeAllProduct();
  }
}
