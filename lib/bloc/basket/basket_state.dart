import 'package:apple_shop_application/data/model/basket_item.dart';
import 'package:dartz/dartz.dart';

abstract class BasketState {}

class BasketinitState extends BasketState {}

class BasketDataFetchedState extends BasketState {
  Either<String, List<BasketItem>> basketItemList;
  int basketFinalPrice;
  BasketDataFetchedState(this.basketItemList, this.basketFinalPrice);
}

class BasketRemoveProsductState extends BasketState {
//  Either<String, List<BasketItem>> basketItemList;
  Either<String, String> response;
  BasketRemoveProsductState(this.response);
}

class BasketRemoveAllProductState extends BasketState {}
