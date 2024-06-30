import 'package:apple_shop_application/bloc/categoryProduct/category_product_bloc.dart';
import 'package:apple_shop_application/data/model/category.dart';
import 'package:apple_shop_application/screens/product_list_screen.dart';
import 'package:apple_shop_application/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryItemChip extends StatelessWidget {
  const CategoryItemChip(
    this.category, {
    super.key,
  });
  final Category category;
  @override
  Widget build(BuildContext context) {
    String categoryColor = 'FF${category.color}';
    int hexColor = int.parse(categoryColor, radix: 16);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => CategoryProductBloc(),
              child: ProductListScreen(category),
            ),
          ),
        );
      },
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: ShapeDecoration(
                  color: Color(hexColor),
                  shadows: [
                    BoxShadow(
                      color: Color(hexColor),
                      blurRadius: 25,
                      spreadRadius: -12,
                      offset: const Offset(0.0, 15),
                    ),
                  ],
                  shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
              SizedBox(
                height: 26,
                width: 26,
                child: Center(
                  child: CachedImage(imageUrl: category.icon),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            category.title,
            style: const TextStyle(
              fontFamily: 'SB',
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
