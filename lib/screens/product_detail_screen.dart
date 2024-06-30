import 'dart:ui';
import 'package:apple_shop_application/bloc/basket/basket_bloc.dart';
import 'package:apple_shop_application/bloc/basket/basket_event.dart';
import 'package:apple_shop_application/bloc/comment/bloc/comment_bloc.dart';
import 'package:apple_shop_application/bloc/product/product_bloc.dart';
import 'package:apple_shop_application/bloc/product/product_event.dart';
import 'package:apple_shop_application/bloc/product/product_state.dart';
import 'package:apple_shop_application/constants/colors.dart';
import 'package:apple_shop_application/data/model/product.dart';
import 'package:apple_shop_application/data/model/product_variant.dart';
import 'package:apple_shop_application/data/model/product_image.dart';
import 'package:apple_shop_application/data/model/property.dart';
import 'package:apple_shop_application/data/model/variant.dart';
import 'package:apple_shop_application/data/model/variant_type.dart';
import 'package:apple_shop_application/di/di.dart';
import 'package:apple_shop_application/widgets/cached_image.dart';
import 'package:apple_shop_application/widgets/loading_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        var productBloc = ProductBloc();
        productBloc.add(
          ProductInitializeEvent(
            product.id,
            product.categoryId,
          ),
        );
        return productBloc;
      },
      child: DetailScreenContent(product: product),
    );
  }
}

class DetailScreenContent extends StatelessWidget {
  const DetailScreenContent({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundScreenColor,
      body: BlocConsumer<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductDetailAddToBasketState) {
            state.successMessageAddProduct.fold((exceptionMessage) {
              final snackBar = SnackBar(
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
                margin: const EdgeInsets.all(24),
              );
              context
                  .read<ProductBloc>()
                  .add(ProductInitializeEvent(product.id, product.categoryId));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }, (successMessage) {
              final snackBar = SnackBar(
                content: Text(
                  successMessage,
                  style: const TextStyle(
                    fontFamily: 'dana',
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.right,
                ),
                backgroundColor: CustomColors.blue,
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(24),
              );
              context
                  .read<ProductBloc>()
                  .add(ProductInitializeEvent(product.id, product.categoryId));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            });
          }
        },
        builder: (context, state) {
          if (state is ProductDetailLoadingState) {
            return const LoadingAnimation();
          } else {
            return SafeArea(
              child: CustomScrollView(
                slivers: [
                  if (state is ProductDetailResponseState) ...{
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
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              children: [
                                Image.asset(
                                    'assets/images/icon_apple_blue.png'),
                                Expanded(
                                  child: state.productCategory.fold(
                                    (exceptionMessage) {
                                      return const Text(
                                        'مشخصات محصول',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: 'SB',
                                          fontSize: 16,
                                          color: CustomColors.blue,
                                        ),
                                      );
                                    },
                                    (productCategory) {
                                      return Text(
                                        productCategory.title,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontFamily: 'SB',
                                          fontSize: 16,
                                          color: CustomColors.blue,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Image.asset(
                                    'assets/images/icon_back.png',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  },
                  if (state is ProductDetailResponseState) ...{
                    SliverToBoxAdapter(
                      child: Text(
                        product.name,
                        style: const TextStyle(
                          fontFamily: 'SB',
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                  },
                  if (state is ProductDetailResponseState) ...{
                    state.productImages.fold(
                      (exceptionMessage) {
                        return SliverToBoxAdapter(
                          child: Text(exceptionMessage),
                        );
                      },
                      (productImageList) {
                        return GalleryWidget(
                          productImageList,
                          product.thumbnail,
                        );
                      },
                    ),
                  },
                  if (state is ProductDetailResponseState) ...{
                    state.productVariant.fold(
                      (exceptionMessage) {
                        return SliverToBoxAdapter(
                          child: Text(exceptionMessage),
                        );
                      },
                      (productVariantList) {
                        return VariantContainerGenorator(productVariantList);
                      },
                    ),
                  },
                  if (state is ProductDetailResponseState) ...{
                    state.productProperties.fold(
                      (exceptionMessage) {
                        return SliverToBoxAdapter(
                          child: Text(exceptionMessage),
                        );
                      },
                      (properties) {
                        return ProductProperties(properties);
                      },
                    ),
                  },
                  if (state is ProductDetailResponseState) ...{
                    ProductDescription(product.description),
                  },
                  if (state is ProductDetailResponseState) ...{
                    SliverToBoxAdapter(
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            isDismissible: false,
                            useSafeArea: true,
                            showDragHandle: true,
                            scrollControlDisabledMaxHeightRatio: 0.5,
                            context: context,
                            builder: (context) {
                              return BlocProvider(
                                create: (context) {
                                  final commentBloc =
                                      CommentBloc(locator.get());
                                  commentBloc.add(
                                    CommentInitialEvent(
                                      product.id,
                                    ),
                                  );
                                  return commentBloc;
                                },
                                child: CommentBottomSheet(
                                  productId: product.id,
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                            top: 24,
                            left: 44,
                            right: 44,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          height: 46,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 1.0,
                              color: CustomColors.grey,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          child: Row(
                            children: [
                              Image.asset(
                                  'assets/images/icon_left_category.png'),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                'مشاهده',
                                style: TextStyle(
                                  fontFamily: 'SB',
                                  fontSize: 12,
                                  color: CustomColors.blue,
                                ),
                              ),
                              const Spacer(),
                              Stack(
                                alignment: Alignment.centerRight,
                                children: [
                                  Container(
                                    width: 26,
                                    height: 26,
                                    decoration: const BoxDecoration(
                                      color: CustomColors.red,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(right: 15),
                                    width: 26,
                                    height: 26,
                                    decoration: const BoxDecoration(
                                      color: Colors.orange,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(right: 30),
                                    width: 26,
                                    height: 26,
                                    decoration: const BoxDecoration(
                                      color: Colors.pink,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(right: 45),
                                    width: 26,
                                    height: 26,
                                    decoration: const BoxDecoration(
                                      color: Colors.blueAccent,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(right: 60),
                                    width: 26,
                                    height: 26,
                                    decoration: const BoxDecoration(
                                      color: CustomColors.grey,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        '+10',
                                        style: TextStyle(
                                          fontFamily: 'SB',
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                'نظرات کاربران:',
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                  fontFamily: 'SM',
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  },
                  if (state is ProductDetailResponseState) ...{
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 38,
                          bottom: 20,
                          left: 33,
                          right: 33,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const PriceTagButton(),
                            AddToBasketButton(product),
                          ],
                        ),
                      ),
                    )
                  },
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

class CommentBottomSheet extends StatelessWidget {
  CommentBottomSheet({
    required this.productId,
    super.key,
  });
  final String productId;
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentBloc, CommentState>(
      builder: (context, state) {
        if (state is CommentLoadingState) {
          return const LoadingAnimation();
        }
        return Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  if (state is CommentResponseState) ...{
                    state.comments.fold(
                      (exceptionMessage) {
                        return const SliverToBoxAdapter(
                          child: Text('خطایی در نمایش نظرات به وجود آمده'),
                        );
                      },
                      (commentList) {
                        if (commentList.isEmpty) {
                          return const SliverToBoxAdapter(
                            child: Text('نظراتی برای این محصول ثبت نشده است'),
                          );
                        }
                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            (commentList[index].username)
                                                    .isEmpty
                                                ? 'نام کاربری'
                                                : commentList[index].username,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            commentList[index].text,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    SizedBox(
                                      width: 50,
                                      height: 50,
                                      child:
                                          (commentList[index].avatar.isNotEmpty)
                                              ? CachedImage(
                                                  imageUrl: commentList[index]
                                                      .userThumnailUrl,
                                                )
                                              : Image.asset(
                                                  'assets/images/avatar.png',
                                                ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            childCount: commentList.length,
                          ),
                        );
                      },
                    )
                  }
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: textController,
                    decoration: const InputDecoration(
                      labelStyle: TextStyle(
                        fontFamily: 'SM',
                        fontSize: 18,
                        color: Colors.black,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                        borderSide: BorderSide(
                          width: 3.0,
                          color: Colors.black,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                        borderSide: BorderSide(
                          width: 3.0,
                          color: CustomColors.blue,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          height: 47,
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 19, 23, 41),
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (textController.text.isEmpty) {
                              return;
                            }
                            context.read<CommentBloc>().add(
                                  CommentPostEvent(
                                    productId,
                                    textController.text,
                                  ),
                                );
                            textController.text = '';
                          },
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 20,
                                sigmaY: 20,
                              ),
                              child: Container(
                                height: 53,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    'ثبت نظر',
                                    style: TextStyle(
                                      fontFamily: 'Sb',
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class ProductProperties extends StatefulWidget {
  final List<Property> _productPropertyList;
  const ProductProperties(
    this._productPropertyList, {
    super.key,
  });

  @override
  State<ProductProperties> createState() => _ProductPropertiesState();
}

class _ProductPropertiesState extends State<ProductProperties> {
  bool _isVisible = false;
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isVisible = !_isVisible;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(top: 24, left: 44, right: 44),
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 13,
              ),
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  width: 1.0,
                  color: CustomColors.grey,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              child: Row(
                children: [
                  Image.asset('assets/images/icon_left_category.png'),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    'مشاهده',
                    style: TextStyle(
                      fontFamily: 'SB',
                      fontSize: 12,
                      color: CustomColors.blue,
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'مشخصات فنی:',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: 'SM',
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: _isVisible,
            child: Container(
              margin: const EdgeInsets.only(top: 24, left: 44, right: 44),
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 13,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  width: 1.0,
                  color: CustomColors.grey,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget._productPropertyList.length,
                itemBuilder: (context, index) {
                  var propperty = widget._productPropertyList[index];
                  return Text(
                    '${propperty.value}:${propperty.title}',
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      fontFamily: 'SM',
                      fontSize: 14,
                      height: 1.8,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VariantContainerGenorator extends StatelessWidget {
  const VariantContainerGenorator(
    this.productVariantList, {
    super.key,
  });

  final List<ProductVariant> productVariantList;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 44),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (var productVariant in productVariantList) ...{
              if (productVariant.variantList.isNotEmpty) ...{
                VariantGeneratorChild(productVariant)
              }
            },
          ],
        ),
      ),
    );
  }
}

class ProductDescription extends StatefulWidget {
  final String productDescription;
  const ProductDescription(
    this.productDescription, {
    super.key,
  });

  @override
  State<ProductDescription> createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  bool _isVisible = false;
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isVisible = !_isVisible;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(top: 24, left: 44, right: 44),
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 13,
              ),
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  width: 1.0,
                  color: CustomColors.grey,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              child: Row(
                children: [
                  Image.asset('assets/images/icon_left_category.png'),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    'مشاهده',
                    style: TextStyle(
                      fontFamily: 'SB',
                      fontSize: 12,
                      color: CustomColors.blue,
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'توضیحات محصول:',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: 'SM',
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: _isVisible,
            child: Container(
              margin: const EdgeInsets.only(top: 24, left: 44, right: 44),
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 13,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  width: 1.0,
                  color: CustomColors.grey,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              child: Text(
                widget.productDescription,
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontFamily: 'SM',
                  fontSize: 14,
                  height: 1.8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GalleryWidget extends StatefulWidget {
  GalleryWidget(
    this.productImageList,
    this.defaultProductThumbnail, {
    super.key,
  });

  final List<ProductImage> productImageList;
  final String? defaultProductThumbnail;
  int _selectedItem = 0;
  @override
  State<GalleryWidget> createState() => _GalleryWidgetState();
}

class _GalleryWidgetState extends State<GalleryWidget> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 44,
          right: 44,
          bottom: 20,
          top: 20,
        ),
        child: Container(
          padding: const EdgeInsets.only(
            left: 10,
            right: 10,
            top: 10,
            bottom: 30,
          ),
          height: 284,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset('assets/images/icon_star.png'),
                        const SizedBox(
                          width: 5,
                        ),
                        const Text(
                          '4.6',
                          style: TextStyle(
                            fontFamily: 'SM',
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      child: SizedBox(
                        height: double.infinity,
                        child: CachedImage(
                          imageUrl: (widget.productImageList.isEmpty
                              ? widget.defaultProductThumbnail
                              : widget.productImageList[widget._selectedItem]
                                  .imageUrl),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Image.asset(
                      'assets/images/icon_favorite_deactive.png',
                    ),
                  ],
                ),
              ),
              if (widget.productImageList.isNotEmpty) ...{
                SizedBox(
                  height: 70,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.productImageList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(
                              () {
                                widget._selectedItem = index;
                              },
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(
                              left: 10,
                              right: 10,
                            ),
                            padding: const EdgeInsets.all(4),
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1.0,
                                color: CustomColors.grey,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Center(
                              child: CachedImage(
                                imageUrl:
                                    widget.productImageList[index].imageUrl,
                                radius: 10,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              }
            ],
          ),
        ),
      ),
    );
  }
}

class AddToBasketButton extends StatelessWidget {
  final Product product;
  const AddToBasketButton(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          width: 140,
          height: 47,
          margin: const EdgeInsets.only(bottom: 10),
          decoration: const BoxDecoration(
            color: CustomColors.blue,
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            context.read<ProductBloc>().add(ProductAddToBasket(product));

            context.read<BasketBloc>().add(BasketFetchFromHiveEvent());
          },
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 20,
                sigmaY: 20,
              ),
              child: Container(
                width: 160,
                height: 53,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'افزودن به سبد خرید',
                    style: TextStyle(
                      fontFamily: 'Sb',
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class PriceTagButton extends StatelessWidget {
  const PriceTagButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          width: 140,
          height: 47,
          margin: const EdgeInsets.only(bottom: 10),
          decoration: const BoxDecoration(
            color: CustomColors.green,
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
        ),
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 20,
              sigmaY: 20,
            ),
            child: Container(
              width: 160,
              height: 53,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Text(
                      'تومان',
                      style: TextStyle(
                        fontFamily: 'SM',
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '۴۶,۰۰۰,۰۰۰',
                          style: TextStyle(
                            fontFamily: 'SM',
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '۴۵,۳۵۰,۰۰۰',
                          style: TextStyle(
                            fontFamily: 'SM',
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      height: 15,
                      decoration: const BoxDecoration(
                        color: CustomColors.red,
                        borderRadius: BorderRadius.all(
                          Radius.circular(7.5),
                        ),
                      ),
                      child: const Text(
                        '%۵',
                        style: TextStyle(
                          fontFamily: 'SB',
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class ColorVariantList extends StatefulWidget {
  final List<Variant> variantList;
  const ColorVariantList(this.variantList, {super.key});

  @override
  State<ColorVariantList> createState() => _ColorVariantListState();
}

class _ColorVariantListState extends State<ColorVariantList> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        height: 26,
        child: ListView.builder(
          itemCount: widget.variantList.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            String color = 'FF${widget.variantList[index].value}';
            int hexColor = int.parse(color, radix: 16);
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(left: 10),
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: Color(hexColor),
                  border: (_selectedIndex == index)
                      ? Border.all(
                          strokeAlign: BorderSide.strokeAlignOutside,
                          color: CustomColors.blue,
                          width: 3,
                        )
                      : Border.all(
                          strokeAlign: BorderSide.strokeAlignOutside,
                          color: CustomColors.backgroundScreenColor,
                          width: 2,
                        ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class StorageVariantList extends StatefulWidget {
  final List<Variant> storageVariants;
  const StorageVariantList(this.storageVariants, {super.key});

  @override
  State<StorageVariantList> createState() => _StorageVariantListState();
}

class _StorageVariantListState extends State<StorageVariantList> {
  final int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        height: 26,
        child: ListView.builder(
          itemCount: widget.storageVariants.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.only(left: 10),
              padding: const EdgeInsets.symmetric(
                horizontal: 27,
                vertical: 4,
              ),
              width: 74,
              height: 26,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  width: 0.5,
                  color: CustomColors.grey,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              child: Text(
                widget.storageVariants[index].name!,
                style: const TextStyle(
                  fontFamily: 'SM',
                  fontSize: 12,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class VariantGeneratorChild extends StatelessWidget {
  final ProductVariant productVariant;
  const VariantGeneratorChild(this.productVariant, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          productVariant.variantType.title!,
          style: const TextStyle(
            fontFamily: 'SM',
            fontSize: 12,
          ),
          textAlign: TextAlign.end,
        ),
        const SizedBox(
          height: 10,
        ),
        if (productVariant.variantType.type == VariantTypeEnum.COLOR) ...{
          ColorVariantList(productVariant.variantList)
        },
        if (productVariant.variantType.type == VariantTypeEnum.STORAGE) ...{
          StorageVariantList(productVariant.variantList)
        },
      ],
    );
  }
}
