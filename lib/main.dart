import 'package:apple_shop_application/data/model/basket_item.dart';
import 'package:apple_shop_application/di/di.dart';
import 'package:apple_shop_application/screens/dashbord_screen.dart';
import 'package:apple_shop_application/screens/login_screen.dart';
import 'package:apple_shop_application/util/auth_manager.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

GlobalKey<NavigatorState> globalNavigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(BasketItemAdapter());
  await Hive.openBox<BasketItem>('CardBox');
  await getItInit();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: globalNavigatorKey,
      home: Scaffold(
        body: (AuthManager.readAuth().isEmpty)
            ? LoginScreen()
            : const DashbordScreen(),
      ),
    );
  }
}
