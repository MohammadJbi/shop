import 'package:apple_shop_application/bloc/basket/basket_bloc.dart';
import 'package:apple_shop_application/constants/colors.dart';
import 'package:apple_shop_application/data/model/product.dart';
import 'package:apple_shop_application/di/di.dart';
import 'package:apple_shop_application/screens/product_detail_screen.dart';
import 'package:apple_shop_application/util/extensions/double_extension.dart';
import 'package:apple_shop_application/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductItem extends StatelessWidget {
  const ProductItem(
    this.product, {
    super.key,
  });
  final Product product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BlocProvider<BasketBloc>.value(
              value: locator.get<BasketBloc>(),
              child: ProductDetailScreen(product),
            ),
          ),
        );
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          width: 160,
          height: 216,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                height: 10,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  const Center(),
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: Center(
                      child: CachedImage(
                        imageUrl: product.thumbnail,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 10,
                    child: Image.asset(
                      width: 20,
                      'assets/images/active_fav_product.png',
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: CustomColors.red,
                        borderRadius: BorderRadius.circular(7.5),
                      ),
                      child: Text(
                        '%${product.persent!.round().toString()}',
                        textDirection: TextDirection.ltr,
                        style: const TextStyle(
                          fontFamily: 'SB',
                          fontSize: 11,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10, bottom: 10),
                    child: Text(
                      product.name,
                      style: const TextStyle(
                        fontFamily: 'SM',
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  Container(
                    height: 53,
                    decoration: const BoxDecoration(
                      color: CustomColors.bluIndicator,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: CustomColors.blue,
                          blurRadius: 25,
                          spreadRadius: -12,
                          offset: Offset(0.0, 15),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 10,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Image.asset(
                            height: 20,
                            width: 20,
                            'assets/images/icon_right_arrow_cricle.png',
                          ),
                          const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                product.price.convertToPrice(),
                                style: const TextStyle(
                                  fontFamily: 'SM',
                                  fontSize: 12,
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: Colors.white,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                product.realPrice!.convertToPrice(),
                                style: const TextStyle(
                                  fontFamily: 'SM',
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text(
                            'تومان',
                            style: TextStyle(
                              fontFamily: 'SM',
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
