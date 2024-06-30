import 'package:apple_shop_application/bloc/category/category_bloc.dart';
import 'package:apple_shop_application/bloc/category/category_state.dart';
import 'package:apple_shop_application/constants/colors.dart';
import 'package:apple_shop_application/data/model/category.dart';
import 'package:apple_shop_application/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundScreenColor,
      body: SafeArea(
        child: CustomScrollView(
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
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        Image.asset('assets/images/icon_apple_blue.png'),
                        const Expanded(
                          child: Text(
                            'دسته بندی',
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
            BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                if (state is CategoryLoadingState) {
                  return const SliverToBoxAdapter(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is CategoryResponseState) {
                  return state.response.fold(
                    (l) => SliverToBoxAdapter(
                      child: Text(l),
                    ),
                    (categoryList) => CategoryList(categoryList: categoryList),
                  );
                }

                return const SliverToBoxAdapter(
                  child: Text('خطایی رخ داده, مجدد تلاش کن'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryList extends StatelessWidget {
  const CategoryList({
    super.key,
    required this.categoryList,
  });

  final List<Category>? categoryList;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: 44,
      ),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          childCount: categoryList?.length ?? 0,
          (context, index) {
            return CachedImage(
              imageUrl: categoryList![index].thumbnail,
            );
          },
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20.0,
          mainAxisSpacing: 20.0,
        ),
      ),
    );
  }
}
