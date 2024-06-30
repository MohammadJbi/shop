import 'package:apple_shop_application/bloc/basket/basket_bloc.dart';
import 'package:apple_shop_application/data/datasource/authentication_datasource.dart';
import 'package:apple_shop_application/data/datasource/banner_datasource.dart';
import 'package:apple_shop_application/data/datasource/basket_datasource.dart';
import 'package:apple_shop_application/data/datasource/category_datasource.dart';
import 'package:apple_shop_application/data/datasource/category_product_datasource.dart';
import 'package:apple_shop_application/data/datasource/comment_datasource.dart';
import 'package:apple_shop_application/data/datasource/product_datasource.dart';
import 'package:apple_shop_application/data/datasource/product_detail_datasource.dart';
import 'package:apple_shop_application/data/repository/authentication_repository.dart';
import 'package:apple_shop_application/data/repository/banner_repository.dart';
import 'package:apple_shop_application/data/repository/basket_repository.dart';
import 'package:apple_shop_application/data/repository/category_product_repository.dart';
import 'package:apple_shop_application/data/repository/category_repository.dart';
import 'package:apple_shop_application/data/repository/comment_repository.dart';
import 'package:apple_shop_application/data/repository/product_detail_repository.dart';
import 'package:apple_shop_application/data/repository/product_repository.dart';
import 'package:apple_shop_application/util/dio_provider.dart';
import 'package:apple_shop_application/util/payment_handler.dart';
import 'package:apple_shop_application/util/url_handler.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zarinpal/zarinpal.dart';

var locator = GetIt.instance;
Future<void> getItInit() async {
  await _initComponents();
  //dataSources
  _initDatasources();
  //repositorys
  _initRepositories();

  //bloc
  locator
      .registerSingleton<BasketBloc>(BasketBloc(locator.get(), locator.get()));
}

Future<void> _initComponents() async {
  locator.registerSingleton<SharedPreferences>(
    await SharedPreferences.getInstance(),
  );
  locator.registerSingleton<PaymentRequest>(
    PaymentRequest(),
  );
  locator.registerSingleton<UrlHandler>(
    UrlLauncher(),
  );
  locator.registerSingleton<PaymentHandler>(
    ZarinpalPaymentHandler(
      locator.get(),
      locator.get(),
    ),
  );

  locator.registerSingleton<Dio>(DioProvider.createDio());
}

void _initDatasources() {
  locator.registerSingleton<IAuthenticationDatasource>(
    AuthenticationRemote(),
  );

  locator.registerSingleton<ICategoryDatasource>(
    CategoryDatasource(),
  );

  locator.registerSingleton<IBannerDatasource>(
    BannerDatasource(),
  );

  locator.registerSingleton<IProductDatasource>(
    ProductDatasource(),
  );
  locator.registerSingleton<IDetailProductDatasource>(
    DetailProductRemoteDatasource(),
  );
  locator.registerSingleton<ICategoryProductDatasource>(
    CategoryProductRemoteDatasource(),
  );
  locator.registerSingleton<IBasketDatasource>(
    BasketLocalDatasource(),
  );
  locator.registerSingleton<ICommentDatasource>(
    CommentRemoteDatasource(),
  );
}

void _initRepositories() {
  locator.registerSingleton<IAuthenRepository>(
    AuthenticationRepository(),
  );

  locator.registerSingleton<ICategoryRepository>(
    CategoryRepository(),
  );
  locator.registerSingleton<IBannerRepository>(
    BannerRepository(),
  );
  locator.registerSingleton<IProductRepository>(
    ProductRepository(),
  );
  locator.registerSingleton<IDetailProductRepository>(
    DetailProductRepository(),
  );
  locator.registerSingleton<ICategoryProductRepository>(
    CategoryProductRepository(),
  );
  locator.registerSingleton<IBasketRepository>(
    BasketRepository(),
  );
  locator.registerSingleton<ICommentRepository>(
    CommentRepository(),
  );
}
