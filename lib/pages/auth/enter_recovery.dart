import 'package:bip39/bip39.dart' as bip39;
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'set_passcode_screen.dart';
import '../../services/functions/functions.dart';

import '../../utils/theme.dart';

class EnterRecoveryScreen extends StatefulWidget {
  const EnterRecoveryScreen({super.key});

  @override
  State<EnterRecoveryScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<EnterRecoveryScreen> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.appBarColor,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 1; i <= 2; i++)
              Container(
                height: 4,
                width: 20,
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: i <= 1 ? Colors.white : Colors.white12,
                  borderRadius: const BorderRadius.horizontal(
                    right: Radius.circular(2),
                  ),
                ),
              )
          ],
        ),
        centerTitle: true,
      ),
      backgroundColor: AppTheme.bodyBackgroundColor,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                'Sign in with a recovery phrase',
                style: TextStyle(
                  color: AppTheme.textColor,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Enter your 12-word phase that you were given when you created your previous wallet',
                style: TextStyle(
                  color: AppTheme.textColor,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: controller,
                minLines: 3,
                maxLines: 3,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  if (!bip39.validateMnemonic(controller.text)) {
                    snackBar('Invalid Recovery Phase', context);
                    return;
                  }
                  Navigator.push(
                    context,
                    PageTransition(
                      child: SetPasscodeScreen(controller.text),
                      type: PageTransitionType.fade,
                      duration: const Duration(milliseconds: 500),
                    ),
                  );
                },
                child: Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.white30,
                  ),
                  child: const Center(
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        color: AppTheme.textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
