import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:comet/pages/auth/login_screen.dart';
import 'package:comet/pages/home.dart';
import 'package:comet/pages/splash/welcome_splash_screen.dart';
import 'package:comet/services/providers/nft_provider.dart';
import 'package:comet/services/providers/transaction_provider.dart';
import 'package:comet/services/providers/walletprovider.dart';

import 'pages/splash/splash_screen.dart';

var isLogged = true;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('crypto');
  var pref = await SharedPreferences.getInstance();
  isLogged = pref.getBool('isLogged') ?? false;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<WalletProvider>(
          create: (context) => WalletProvider(),
        ),
        ChangeNotifierProvider<TransactionProvider>(
          create: (context) => TransactionProvider(),
        ),
        ChangeNotifierProvider<NFTProvider>(
          create: (context) => NFTProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Comet',
        theme: ThemeData.dark(useMaterial3: true),
        initialRoute: isLogged ? SplashScreen.route : WelcomeSplashScreen.route,
        routes: {
          SplashScreen.route: (context) => SplashScreen(),
          WelcomeSplashScreen.route: (context) => WelcomeSplashScreen(),
          HomeScreen.route: (context) => HomeScreen(),
          LoginScreen.route: (context) => const LoginScreen(),
        },
      ),
    );
  }
}
