import 'package:comet/pages/auth/login_screen.dart';
import 'package:comet/utils/lottie_asset.dart';
import 'package:comet/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../services/providers/walletprovider.dart';

class WelcomeSplashScreen extends StatefulWidget {
  static const route = '/welcome-splash';
  WelcomeSplashScreen({super.key});

  @override
  State<WelcomeSplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<WelcomeSplashScreen> {
  int page = 0;

  @override
  void initState() {
    WalletProvider walletProvider =
        Provider.of<WalletProvider>(context, listen: false);
    walletProvider.initialize();
    Hive.openBox('Crypto');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bodyBackgroundColor,
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 20),
                for (int i = 0; i < 2; i++)
                  Container(
                    height: 3,
                    width: page == i ? 40 : 10,
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: i <= 1 ? Colors.white : Colors.white12,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  )
              ],
            ),
            Expanded(
              child: Container(
                child: PageView.builder(
                  itemBuilder: (context, index) => [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(40.0),
                          child: LottieBuilder.asset(LottieFiles.createWallet),
                        ),
                        Text(
                          'Created with 🤍 for everyone',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Secure • Powerfull • Easy',
                          style: GoogleFonts.poppins(fontSize: 15),
                        ),
                        SizedBox(height: 30),
                        InkWell(
                          onTap: () => Navigator.push(
                            context,
                            PageTransition(
                              child: const LoginScreen(),
                              childCurrent: widget,
                              type: PageTransitionType.rightToLeftJoined,
                              duration: const Duration(milliseconds: 500),
                            ),
                          ),
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(23),
                              color: Colors.purpleAccent,
                            ),
                            child: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.white60,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(40.0),
                          child: LottieBuilder.asset(
                            LottieFiles.WalletAdd,
                          ),
                        ),
                        Text('Secure, '),
                      ],
                    ),
                  ][page],
                  onPageChanged: (value) {
                    // page = value;
                    setState(() {
                      page = value;
                    });
                  },
                  itemCount: 1,
                ),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
