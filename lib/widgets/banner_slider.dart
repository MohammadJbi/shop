import 'package:apple_shop_application/constants/colors.dart';
import 'package:apple_shop_application/data/model/banner.dart';
import 'package:apple_shop_application/widgets/cached_image.dart';

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BannerSlidar extends StatelessWidget {
  const BannerSlidar({super.key, required this.bannerList});
  final List<BannerCampain> bannerList;
  @override
  Widget build(BuildContext context) {
    var controller = PageController(
      viewportFraction: 0.8,
      initialPage: 1,
    );
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SizedBox(
          height: 177,
          child: PageView.builder(
            controller: controller,
            itemCount: bannerList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: CachedImage(
                  radius: 15,
                  imageUrl: bannerList[index].thumbnail,
                ),
              );
            },
          ),
        ),
        Positioned(
          bottom: 8,
          child: SmoothPageIndicator(
            controller: controller,
            count: 4,
            effect: const ExpandingDotsEffect(
              expansionFactor: 5,
              dotHeight: 6,
              dotWidth: 6,
              dotColor: Colors.white,
              activeDotColor: CustomColors.bluIndicator,
              radius: 2.5,
            ),
          ),
        ),
      ],
    );
  }
}
