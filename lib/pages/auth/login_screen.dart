import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

import 'enter_recovery.dart';
import 'recovery_phase_screen.dart';

import '../../utils/theme.dart';

class LoginScreen extends StatelessWidget {
  static const route = '/login';
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bodyBackgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(height: 50),
          Expanded(
            child: LottieBuilder.asset('assets/lotties/crypto-wallet.json'),
          ),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              PageTransition(
                child: const RecoveryPhaseScreen(),
                type: PageTransitionType.rightToLeftWithFade,
                duration: const Duration(milliseconds: 500),
              ),
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: AppTheme.splashButtonColor,
              ),
              child: InkWell(
                onTap: () => Navigator.push(
                  context,
                  PageTransition(
                    child: const RecoveryPhaseScreen(),
                    type: PageTransitionType.rightToLeftWithFade,
                    duration: const Duration(milliseconds: 500),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Create new wallet',
                    style: TextStyle(
                      color: AppTheme.textColorBlack,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            height: 60,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(25),
              onTap: () => Navigator.push(
                context,
                PageTransition(
                  child: const EnterRecoveryScreen(),
                  type: PageTransitionType.rightToLeftWithFade,
                  duration: const Duration(milliseconds: 500),
                ),
              ),
              child: const Center(
                child: Text(
                  'I already have a wallet',
                  style: TextStyle(
                    color: AppTheme.textColor,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
