import 'package:apple_shop_application/data/model/basket_item.dart';
import 'package:hive/hive.dart';

abstract class IBasketDatasource {
  Future<void> addProduct(BasketItem basketItem);
  Future<List<BasketItem>> getAllBasketItems();
  Future<int> getBasketFinalPrice();
  Future<void> removeProduct(int index);
  Future<void> removeAllProduct();
}

class BasketLocalDatasource extends IBasketDatasource {
  var box = Hive.box<BasketItem>('CardBox');

  @override
  Future<void> addProduct(BasketItem basketItem) async {
    box.add(basketItem);
  }

  @override
  Future<List<BasketItem>> getAllBasketItems() async {
    List<BasketItem> basketItemList = box.values.toList();
    return basketItemList;
  }

  @override
  Future<int> getBasketFinalPrice() async {
    List<BasketItem> productList = box.values.toList();
    var finalPrice = productList.fold(
      0,
      (accumulator, product) => accumulator + (product.realPrice!),
    );
    return finalPrice;
  }

  @override
  Future<void> removeProduct(int index) async {
    box.deleteAt(index);
  }

  @override
  Future<void> removeAllProduct() async {
    box.clear();
  }
}
