import 'package:apple_shop_application/bloc/basket/basket_bloc.dart';
import 'package:apple_shop_application/bloc/basket/basket_event.dart';
import 'package:apple_shop_application/bloc/basket/basket_state.dart';
import 'package:apple_shop_application/constants/colors.dart';
import 'package:apple_shop_application/screens/login_screen.dart';
import 'package:apple_shop_application/util/auth_manager.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BasketBloc, BasketState>(builder: (context, state) {
      return Scaffold(
        backgroundColor: CustomColors.backgroundScreenColor,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
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
                            'حساب کاربری',
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
              const Text(
                'محمد مهدی جباری',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: 'SB',
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              const Text(
                '09367912983',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: 'SM',
                  fontSize: 10,
                  color: CustomColors.grey,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 44,
                  right: 44,
                  top: 20,
                ),
                child: Wrap(
                  textDirection: TextDirection.rtl,
                  spacing: 33.0,
                  runSpacing: 20.0,
                  children: [
                    // CategoryItemChip(),
                    // CategoryItemChip(),
                    // CategoryItemChip(),
                    // CategoryItemChip(),
                    // CategoryItemChip(),
                    // CategoryItemChip(),
                    // CategoryItemChip(),
                    // CategoryItemChip(),
                    // CategoryItemChip(),
                    // CategoryItemChip(),
                  ],
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  AuthManager.logout();
                  context.read<BasketBloc>().add(BasketClearProductsEvent());
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                },
                child: const Text(
                  'خروج از حساب کاربری',
                  style: TextStyle(
                    fontFamily: 'SB',
                    fontSize: 15,
                    color: CustomColors.red,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                'اپل شاپ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'SM',
                  fontSize: 10,
                  color: CustomColors.grey,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Text(
                'V-1.0.00',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'SM',
                  fontSize: 10,
                  color: CustomColors.grey,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Text(
                'Instagram.com/MaohammadJI_',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'SM',
                  fontSize: 10,
                  color: CustomColors.grey,
                ),
              ),
              const SizedBox(
                height: 32,
              ),
            ],
          ),
        ),
      );
    });
  }
}
