import 'package:apple_shop_application/bloc/basket/basket_bloc.dart';
import 'package:apple_shop_application/bloc/basket/basket_event.dart';
import 'package:apple_shop_application/bloc/basket/basket_state.dart';
import 'package:apple_shop_application/constants/colors.dart';
import 'package:apple_shop_application/data/model/basket_item.dart';
import 'package:apple_shop_application/util/extensions/double_extension.dart';
import 'package:apple_shop_application/util/extensions/string_extensions.dart';
import 'package:apple_shop_application/widgets/cached_image.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CardScreen extends StatefulWidget {
  const CardScreen({super.key});

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  @override
  void initState() {
    context.read<BasketBloc>().add(BasketFetchFromHiveEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BasketBloc, BasketState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: CustomColors.backgroundScreenColor,
          body: SafeArea(
            child: BlocConsumer<BasketBloc, BasketState>(
              listener: (context, state) {
                if (state is BasketRemoveProsductState) {
                  state.response.fold(
                    (exceptionMessage) {
                      var snackBar = SnackBar(
                        content: Text(
                          exceptionMessage,
                          style: const TextStyle(
                            fontFamily: 'dana',
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        backgroundColor: CustomColors.blue,
                        duration: const Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                        margin: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          bottom: 80,
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    (removeSuccessMessage) {
                      var snackBar = SnackBar(
                        content: Text(
                          removeSuccessMessage,
                          style: const TextStyle(
                            fontFamily: 'dana',
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        backgroundColor: CustomColors.blue,
                        duration: const Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                        margin: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 80),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                  );
                }
              },
              builder: (context, state) {
                return Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 44,
                              right: 44,
                              top: 20,
                              bottom: 32,
                            ),
                            child: Container(
                              height: 46,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Row(
                                  children: [
                                    Image.asset(
                                        'assets/images/icon_apple_blue.png'),
                                    const Expanded(
                                      child: Text(
                                        'سبد خرید',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'SB',
                                          fontSize: 16,
                                          color: CustomColors.blue,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (state is BasketDataFetchedState) ...{
                          state.basketItemList.fold(
                            (exceptionMessage) {
                              return SliverToBoxAdapter(
                                child: Text(exceptionMessage),
                              );
                            },
                            (basketItemList) {
                              return SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    return CardItem(
                                        basketItemList[index], index);
                                  },
                                  childCount: basketItemList.length,
                                ),
                              );
                            },
                          ),
                        },
                        const SliverPadding(
                          padding: EdgeInsets.only(bottom: 70),
                        ),
                      ],
                    ),
                    if (state is BasketDataFetchedState) ...{
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 44,
                          right: 44,
                          bottom: 20,
                        ),
                        child: SizedBox(
                          height: 53,
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              textStyle: const TextStyle(
                                fontFamily: 'SB',
                                fontSize: 16,
                              ),
                              backgroundColor: CustomColors.green,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            onPressed: () {
                              context
                                  .read<BasketBloc>()
                                  .add(BasketPaymentInitEvent());
                              context
                                  .read<BasketBloc>()
                                  .add(BasketPaymentRequestEvent());
                            },
                            child: Text(
                              (state.basketFinalPrice == 0)
                                  ? 'سبد خرید شما خالی است'
                                  : state.basketFinalPrice.convertToPrice(),
                            ),
                          ),
                        ),
                      ),
                    },
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class CardItem extends StatelessWidget {
  final BasketItem basketItem;
  final int index;
  const CardItem(
    this.basketItem,
    this.index, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 249,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(left: 44, right: 44, bottom: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 17),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          basketItem.name,
                          style: const TextStyle(
                            fontFamily: 'SB',
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'گارانتی 18 ماه مدیا پردازش',
                          style: TextStyle(
                            fontFamily: 'SM',
                            fontSize: 10,
                            color: CustomColors.grey,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: CustomColors.red,
                                borderRadius: BorderRadius.circular(7.5),
                              ),
                              child: Text(
                                '٪${basketItem.persent!.round().toString()}',
                                style: const TextStyle(
                                  fontFamily: 'SB',
                                  fontSize: 11,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Text(
                              'تومان',
                              style: TextStyle(
                                fontFamily: 'SM',
                                fontSize: 10,
                                color: CustomColors.grey,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              basketItem.price.convertToPrice(),
                              style: const TextStyle(
                                fontFamily: 'SM',
                                fontSize: 12,
                                color: CustomColors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Wrap(
                          direction: Axis.horizontal,
                          spacing: 8,
                          children: [
                            GestureDetector(
                              onTap: () {
                                context.read<BasketBloc>().add(
                                      BasketRemoveProductEvent(index),
                                    );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    width: 1.0,
                                    color: CustomColors.red,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'حذف',
                                      style: TextStyle(
                                        fontFamily: 'SM',
                                        fontSize: 10,
                                        color: CustomColors.red,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Image.asset('assets/images/icon_trash.png')
                                  ],
                                ),
                              ),
                            ),
                            const OptionCheap(
                              'آبی',
                              color: '0d54a1',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 18, right: 10),
                    child: SizedBox(
                      width: 104,
                      height: 75,
                      child: Center(
                        child: CachedImage(imageUrl: basketItem.thumbnail),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: DottedLine(
              lineThickness: 3.0,
              dashLength: 8.0,
              dashColor: CustomColors.grey.withOpacity(0.5),
              dashGapLength: 3.0,
              dashGapColor: Colors.transparent,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'تومان',
                  style: TextStyle(
                    fontFamily: 'SM',
                    fontSize: 12,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  basketItem.realPrice!.convertToPrice(),
                  style: const TextStyle(
                    fontFamily: 'SM',
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OptionCheap extends StatelessWidget {
  final String? color;
  final String title;
  const OptionCheap(
    this.title, {
    super.key,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          width: 1.0,
          color: CustomColors.grey,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (color != null) ...{
            SizedBox(
              width: 10,
              height: 10,
              child: CircleAvatar(
                backgroundColor: color.parseToColor(),
              ),
            ),
          },
          const SizedBox(
            width: 8,
          ),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'SM',
              fontSize: 10,
              color: CustomColors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
