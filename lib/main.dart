import 'package:firebase_core/firebase_core.dart';
import 'package:flukefy_admin/utils/colors.dart';
import 'package:flukefy_admin/view/screens/splash/splash_screen.dart';
import 'package:flukefy_admin/view_model/brand_provider.dart';
import 'package:flukefy_admin/view_model/products_provider.dart';
import 'package:flukefy_admin/view_model/splash_provider.dart';
import 'package:flukefy_admin/view_model/users_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SplashProvider()),
        ChangeNotifierProvider(create: (_) => UsersProvider()),
        ChangeNotifierProvider(create: (_) => ProductsProvider()),
        ChangeNotifierProvider(create: (_) => BrandsProvider()),
      ],
      child: MaterialApp(
        title: 'Flukefy admin',
        theme: ThemeData(
          colorScheme: ColorScheme.light(primary: DefaultColors.primaryColor, background: DefaultColors.backgroundColor),
          fontFamily: 'Averta',
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
