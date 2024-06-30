import 'dart:ui';
import 'package:apple_shop_application/bloc/basket/basket_bloc.dart';
import 'package:apple_shop_application/bloc/category/category_bloc.dart';
import 'package:apple_shop_application/bloc/category/category_event.dart';
import 'package:apple_shop_application/bloc/home/home_bloc.dart';
import 'package:apple_shop_application/bloc/home/home_event.dart';
import 'package:apple_shop_application/constants/colors.dart';
import 'package:apple_shop_application/di/di.dart';
import 'package:apple_shop_application/screens/card_screen.dart';
import 'package:apple_shop_application/screens/category_screen.dart';
import 'package:apple_shop_application/screens/home_screen.dart';
import 'package:apple_shop_application/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashbordScreen extends StatefulWidget {
  const DashbordScreen({super.key});

  @override
  State<DashbordScreen> createState() => _DashbordScreenState();
}

class _DashbordScreenState extends State<DashbordScreen> {
  int _selectedBottomNavigationIndex = 3;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: IndexedStack(
          index: _selectedBottomNavigationIndex,
          children: getScreens(),
        ),
        bottomNavigationBar: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 40.0,
              sigmaY: 40.0,
            ),
            child: BottomNavigationBar(
              onTap: (int index) {
                setState(() {
                  _selectedBottomNavigationIndex = index;
                });
              },
              currentIndex: _selectedBottomNavigationIndex,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedLabelStyle: const TextStyle(
                fontFamily: 'SB',
                fontSize: 10,
                color: CustomColors.blue,
              ),
              unselectedLabelStyle: const TextStyle(
                fontFamily: 'SB',
                fontSize: 10,
                color: Colors.black,
              ),
              items: [
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Image.asset(
                      'assets/images/icon_profile.png',
                    ),
                  ),
                  activeIcon: Container(
                    margin: const EdgeInsets.only(bottom: 3),
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: CustomColors.blue,
                          blurRadius: 20,
                          spreadRadius: -7,
                          offset: Offset(
                            0.0,
                            13,
                          ),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/icon_profile_active.png',
                    ),
                  ),
                  label: 'حساب کاربری',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Image.asset(
                      'assets/images/icon_basket.png',
                    ),
                  ),
                  activeIcon: Container(
                    margin: const EdgeInsets.only(bottom: 3),
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: CustomColors.blue,
                          blurRadius: 20,
                          spreadRadius: -7,
                          offset: Offset(
                            0.0,
                            10,
                          ),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/icon_basket_active.png',
                    ),
                  ),
                  label: 'سبد خرید',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Image.asset(
                      'assets/images/icon_category.png',
                    ),
                  ),
                  activeIcon: Container(
                    margin: const EdgeInsets.only(bottom: 3),
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: CustomColors.blue,
                          blurRadius: 20,
                          spreadRadius: -7,
                          offset: Offset(
                            0.0,
                            10,
                          ),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/icon_category_active.png',
                    ),
                  ),
                  label: 'دسته بندی',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Image.asset(
                      'assets/images/icon_home.png',
                    ),
                  ),
                  activeIcon: Container(
                    margin: const EdgeInsets.only(bottom: 3),
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: CustomColors.blue,
                          blurRadius: 20,
                          spreadRadius: -7,
                          offset: Offset(
                            0.0,
                            10,
                          ),
                        )
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/icon_home_active.png',
                    ),
                  ),
                  label: 'خانه',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> getScreens() {
    return <Widget>[
      BlocProvider<BasketBloc>.value(
        value: locator.get<BasketBloc>(),
        child: const ProfileScreen(),
      ),
      BlocProvider<BasketBloc>.value(
        value: locator.get<BasketBloc>(),
        child: const CardScreen(),
      ),
      BlocProvider(
        create: (context) {
          var categoryBloc = CategoryBloc();
          categoryBloc.add(CategoryRequestList());
          return categoryBloc;
        },
        child: const CategoryScreen(),
      ),
      Directionality(
        textDirection: TextDirection.rtl,
        child: BlocProvider(
          create: (context) {
            var homeBloc = HomeBloc();
            homeBloc.add(HomeGetInitilzeData());
            return homeBloc;
          },
          child: const HomeScreen(),
        ),
      ),
    ];
  }
}
