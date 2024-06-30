abstract class BasketEvent {}

class BasketFetchFromHiveEvent extends BasketEvent {}

class BasketPaymentInitEvent extends BasketEvent {}

class BasketPaymentRequestEvent extends BasketEvent {}

class BasketRemoveProductEvent extends BasketEvent {
  final int index;
  BasketRemoveProductEvent(this.index);
}

class BasketClearProductsEvent extends BasketEvent {}
