import 'package:apple_shop_application/bloc/basket/basket_event.dart';
import 'package:apple_shop_application/bloc/basket/basket_state.dart';
import 'package:apple_shop_application/data/repository/basket_repository.dart';
import 'package:apple_shop_application/util/payment_handler.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BasketBloc extends Bloc<BasketEvent, BasketState> {
  final IBasketRepository _basketRepository;
  final PaymentHandler _paymentHandler;
  BasketBloc(this._basketRepository, this._paymentHandler)
      : super(BasketinitState()) {
    on<BasketFetchFromHiveEvent>(
      (event, emit) async {
        var basketItemList = await _basketRepository.getAllBasketItems();
        var finalPrice = await _basketRepository.getBasketFinalPrice();
        emit(
          BasketDataFetchedState(basketItemList, finalPrice),
        );
      },
    );

    on<BasketPaymentInitEvent>(
      (event, emit) async {
        var finalPrice = await _basketRepository.getBasketFinalPrice();
        _paymentHandler.initPaymentRequest(finalPrice);
      },
    );

    on<BasketPaymentRequestEvent>(
      (event, emit) {
        _paymentHandler.sendPaymentRequest();
      },
    );
    on<BasketRemoveProductEvent>(
      (event, emit) async {
        var response = await _basketRepository.removeProduct(event.index);
        emit(BasketRemoveProsductState(response));
        var basketItemList = await _basketRepository.getAllBasketItems();
        var finalPrice = await _basketRepository.getBasketFinalPrice();

        emit(
          BasketDataFetchedState(basketItemList, finalPrice),
        );
      },
    );
    on<BasketClearProductsEvent>(
      (event, emit) async {
        _basketRepository.removeAllProduct();
      },
    );
  }
}
