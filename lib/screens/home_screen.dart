import 'package:apple_shop_application/bloc/home/home_bloc.dart';
import 'package:apple_shop_application/bloc/home/home_event.dart';
import 'package:apple_shop_application/bloc/home/home_state.dart';
import 'package:apple_shop_application/constants/colors.dart';
import 'package:apple_shop_application/data/model/banner.dart';
import 'package:apple_shop_application/data/model/category.dart';
import 'package:apple_shop_application/data/model/product.dart';
import 'package:apple_shop_application/widgets/banner_slider.dart';
import 'package:apple_shop_application/widgets/category_icon_item_chip.dart';
import 'package:apple_shop_application/widgets/loading_animation.dart';
import 'package:apple_shop_application/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundScreenColor,
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return _getHomeScreenContent(state, context);
          },
        ),
      ),
    );
  }
}

Widget _getHomeScreenContent(HomeState state, BuildContext context) {
  if (state is HomeLoadinState) {
    return const LoadingAnimation();
  } else {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<HomeBloc>().add(HomeGetInitilzeData());
      },
      child: CustomScrollView(
        slivers: [
          const GetSearchBox(),
          if (state is HomeSearchLoadingState) ...{
            const SliverToBoxAdapter(
              child: LoadingAnimation(),
            )
          },
          if (state is HomeSearchProductsState) ...{
            state.response.fold(
              (exceptionMessage) {
                return SliverToBoxAdapter(
                  child: Text(exceptionMessage),
                );
              },
              (productListBuyCategory) {
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 44,
                  ),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      childCount: productListBuyCategory.length,
                      (context, index) {
                        return ProductItem(productListBuyCategory[index]);
                      },
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2 / 2.7,
                      crossAxisSpacing: 22.0,
                      mainAxisSpacing: 22.0,
                    ),
                  ),
                );
              },
            ),
          },
          if (state is HomeRequestSuccessState) ...{
            state.bannerList.fold(
              (exceptionMessage) => SliverToBoxAdapter(
                child: Text(exceptionMessage),
              ),
              (bannerCampain) => GetBanners(
                bannerCampain: bannerCampain,
              ),
            ),
          },
          if (state is HomeRequestSuccessState) ...{
            const GetCategoryListTitle(),
            state.categoryList.fold(
              (exceptionMessage) {
                return SliverToBoxAdapter(
                  child: Text(exceptionMessage),
                );
              },
              (categoryList) {
                return GetCategoryList(categoryList);
              },
            ),
          },
          if (state is HomeRequestSuccessState) ...{
            const GetBestSellerTitle(),
            state.bestSellerProductList.fold(
              (exceptionMessage) {
                return SliverToBoxAdapter(
                  child: Text(exceptionMessage),
                );
              },
              (productList) {
                return GetBestSellerProducts(productList);
              },
            ),
          },
          if (state is HomeRequestSuccessState) ...{
            const GetMostViewedTitle(),
            state.hotestProductList.fold(
              (exceptionMessage) {
                return SliverToBoxAdapter(
                  child: Text(exceptionMessage),
                );
              },
              (productList) {
                return GetMostViewedProducts(productList);
              },
            ),
          },
          const SliverPadding(padding: EdgeInsets.only(bottom: 24))
        ],
      ),
    );
  }
}

class GetMostViewedProducts extends StatelessWidget {
  const GetMostViewedProducts(
    this.productList, {
    super.key,
  });
  final List<Product> productList;
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(right: 44),
        child: SizedBox(
          height: 216,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: productList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 20),
                child: ProductItem(productList[index]),
              );
            },
          ),
        ),
      ),
    );
  }
}

class GetMostViewedTitle extends StatelessWidget {
  const GetMostViewedTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 44,
          right: 44,
          bottom: 20,
          top: 32,
        ),
        child: Row(
          children: [
            const Text(
              'پر بازدید ترین ها',
              style: TextStyle(
                fontFamily: 'SB',
                fontSize: 12,
                color: CustomColors.grey,
              ),
            ),
            const Spacer(),
            const Text(
              'مشاهده همه',
              style: TextStyle(
                fontFamily: 'SB',
                fontSize: 12,
                color: CustomColors.blue,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Image.asset('assets/images/icon_left_categroy.png'),
          ],
        ),
      ),
    );
  }
}

class GetBestSellerProducts extends StatelessWidget {
  const GetBestSellerProducts(
    this.productList, {
    super.key,
  });
  final List<Product> productList;
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(right: 44),
        child: SizedBox(
          height: 216,
          child: ListView.builder(
            itemCount: productList.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 20),
                child: ProductItem(
                  productList[index],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class GetBestSellerTitle extends StatelessWidget {
  const GetBestSellerTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 44,
          right: 44,
          bottom: 20,
        ),
        child: Row(
          children: [
            const Text(
              'پرفروشترین ها',
              style: TextStyle(
                fontFamily: 'SB',
                fontSize: 12,
                color: CustomColors.grey,
              ),
            ),
            const Spacer(),
            const Text(
              'مشاهده همه',
              style: TextStyle(
                fontFamily: 'SB',
                fontSize: 12,
                color: CustomColors.blue,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Image.asset('assets/images/icon_left_categroy.png'),
          ],
        ),
      ),
    );
  }
}

class GetCategoryList extends StatelessWidget {
  const GetCategoryList(
    this.categoryList, {
    super.key,
  });
  final List<Category> categoryList;
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(right: 44, bottom: 32),
        child: SizedBox(
          height: 83,
          child: ListView.builder(
            itemCount: categoryList.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 20),
                child: CategoryItemChip(categoryList[index]),
              );
            },
          ),
        ),
      ),
    );
  }
}

class GetCategoryListTitle extends StatelessWidget {
  const GetCategoryListTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(
          right: 44,
          bottom: 20,
          top: 32,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'دسته بندی',
              style: TextStyle(
                fontFamily: 'SB',
                fontSize: 12,
                color: CustomColors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GetBanners extends StatelessWidget {
  const GetBanners({
    super.key,
    required this.bannerCampain,
  });
  final List<BannerCampain> bannerCampain;
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: BannerSlidar(bannerList: bannerCampain),
    );
  }
}

class GetSearchBox extends StatelessWidget {
  const GetSearchBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
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
                Image.asset('assets/images/icon_search.png'),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      context
                          .read<HomeBloc>()
                          .add(HomeSearchProductsEvent(value));
                    },
                    decoration: const InputDecoration(
                      hintText: 'جستجوی محصولات',
                      hintStyle: TextStyle(
                        fontFamily: 'SB',
                        fontSize: 16,
                        color: Color.fromARGB(255, 22, 22, 22),
                      ),
                      border: InputBorder.none,
                      labelStyle: TextStyle(
                        fontFamily: 'SM',
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Image.asset('assets/images/icon_apple_blue.png'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
