import 'package:apple_shop_application/bloc/authentication/auth_bloc.dart';
import 'package:apple_shop_application/bloc/authentication/auth_event.dart';
import 'package:apple_shop_application/bloc/authentication/auth_state.dart';
import 'package:apple_shop_application/constants/colors.dart';
import 'package:apple_shop_application/screens/dashbord_screen.dart';
import 'package:apple_shop_application/screens/login_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});
  final _usernameTextController = TextEditingController(text: 'amirahmad');
  final _passwordTextController = TextEditingController(text: '12345678');
  final _passwordConfirmTextController =
      TextEditingController(text: '12345678');

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: ViewContainer(
        usernameTextController: _usernameTextController,
        passwordTextController: _passwordTextController,
        passwordConfirmTextController: _passwordConfirmTextController,
      ),
    );
  }
}

class ViewContainer extends StatelessWidget {
  const ViewContainer({
    super.key,
    required TextEditingController usernameTextController,
    required TextEditingController passwordTextController,
    required TextEditingController passwordConfirmTextController,
  })  : _usernameTextController = usernameTextController,
        _passwordTextController = passwordTextController,
        _passwordConfirmTextController = passwordConfirmTextController;

  final TextEditingController _usernameTextController;
  final TextEditingController _passwordTextController;
  final TextEditingController _passwordConfirmTextController;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 60,
                ),
                Image.asset(
                  'assets/images/register.jpg',
                  width: 200,
                  height: 200,
                ),
                const SizedBox(
                  height: 60,
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'نام کاربری:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'dana',
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        color: Colors.grey[200],
                        child: TextField(
                          controller: _usernameTextController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            labelStyle: TextStyle(
                              fontFamily: 'SM',
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 24, right: 24, bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'رمز عبور:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'dana',
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        color: Colors.grey[200],
                        child: TextField(
                          controller: _passwordTextController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            labelStyle: TextStyle(
                              fontFamily: 'SM',
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 24, right: 24, bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'تکرار رمز عبور:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'dana',
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        color: Colors.grey[200],
                        child: TextField(
                          controller: _passwordConfirmTextController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            labelStyle: TextStyle(
                              fontFamily: 'SM',
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthResponseState) {
                      state.response.fold(
                        (exceptionMessage) {
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
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        },
                        (r) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const DashbordScreen(),
                            ),
                          );
                        },
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is AuthInitiateState) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue[700],
                          textStyle: const TextStyle(
                            fontFamily: 'SB',
                            fontSize: 18,
                          ),
                          minimumSize: const Size(200, 48),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        onPressed: () {
                          context.read<AuthBloc>().add(
                                AuthRegisterRequest(
                                  _usernameTextController.text,
                                  _passwordTextController.text,
                                  _passwordConfirmTextController.text,
                                ),
                              );
                        },
                        child: const Text('ثبت نام'),
                      );
                    }
                    if (state is AuthLoadingState) {
                      return const CircularProgressIndicator(
                        color: Colors.green,
                      );
                    }
                    if (state is AuthResponseState) {
                      return state.response.fold(
                        (exceptionMessage) {
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.blue[700],
                              textStyle: const TextStyle(
                                fontFamily: 'SB',
                                fontSize: 18,
                              ),
                              minimumSize: const Size(200, 48),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                            ),
                            onPressed: () {
                              context.read<AuthBloc>().add(
                                    AuthRegisterRequest(
                                      _usernameTextController.text,
                                      _passwordTextController.text,
                                      _passwordConfirmTextController.text,
                                    ),
                                  );
                            },
                            child: const Text('ثبت نام'),
                          );
                        },
                        (successMessage) {
                          return Text(successMessage);
                        },
                      );
                    }
                    return const Text('خطایی رخ داده داداش');
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'اگر حساب کاربری وارد شوید',
                    style: TextStyle(
                      fontFamily: 'SM',
                      fontSize: 12,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
