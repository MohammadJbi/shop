import 'package:apple_shop_application/bloc/categoryProduct/category_product_bloc.dart';
import 'package:apple_shop_application/bloc/categoryProduct/category_product_event.dart';
import 'package:apple_shop_application/bloc/categoryProduct/category_product_state.dart';
import 'package:apple_shop_application/constants/colors.dart';
import 'package:apple_shop_application/data/model/category.dart';
import 'package:apple_shop_application/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductListScreen extends StatefulWidget {
  final Category category;
  const ProductListScreen(this.category, {super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  void initState() {
    BlocProvider.of<CategoryProductBloc>(context)
        .add(CategoryProductInitialize(widget.category.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundScreenColor,
      body: SafeArea(
        child: BlocBuilder<CategoryProductBloc, CategoryProductState>(
          builder: (context, state) {
            return CustomScrollView(
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
                            Expanded(
                              child: Text(
                                widget.category.title,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
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
                if (state is CategoryProductResponseSuccessState) ...{
                  state.productListByCategory.fold(
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
                            childAspectRatio: 2 / 2.8,
                            crossAxisSpacing: 22.0,
                            mainAxisSpacing: 22.0,
                          ),
                        ),
                      );
                    },
                  ),
                },
              ],
            );
          },
        ),
      ),
    );
  }
}
