import 'package:bip39/bip39.dart' as bip39;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';

import 'package:comet/pages/auth/set_passcode_screen.dart';
import 'package:comet/services/functions/functions.dart';

import '../../utils/theme.dart';

class RecoveryPhaseScreen extends StatefulWidget {
  const RecoveryPhaseScreen({super.key});

  @override
  State<RecoveryPhaseScreen> createState() => _RecoveryPhaseScreenState();
}

class _RecoveryPhaseScreenState extends State<RecoveryPhaseScreen> {
  late final String mnemonic;
  bool view = false;

  @override
  void initState() {
    mnemonic = bip39.generateMnemonic();
    super.initState();
  }

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
                'Back up your Wallet',
                style: TextStyle(
                  color: AppTheme.textColor,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Your secret recovery phase is used to recover your crypto if you lose your phone or switch to different wallet.\n\nSave these 12 words in a secure location, such as a password manager, and never share them with anyone.',
                style: TextStyle(
                  color: AppTheme.textColor,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () => setState(() => view = !view),
                child: Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppTheme.containerBorderColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            mnemonic,
                            style: TextStyle(
                              fontSize: view ? 16 : 0,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 40,
                        height: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.horizontal(
                              right: Radius.circular(10)),
                        ),
                        child: Icon(
                          view
                              ? Icons.remove_red_eye
                              : Icons.remove_red_eye_outlined,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              TextButton.icon(
                style:
                    TextButton.styleFrom(foregroundColor: AppTheme.textColor),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: mnemonic)).then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 100, vertical: 200),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        content: const Text(
                          "Copied to clipboard",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppTheme.textColor),
                        ),
                        backgroundColor: Colors.white60,
                      ),
                    );
                  });
                },
                label: const Text('Copy to clipboard'),
                icon: const Icon(Icons.copy),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  if (bip39.validateMnemonic(mnemonic)) {
                    Navigator.push(
                      context,
                      PageTransition(
                        child: SetPasscodeScreen(mnemonic),
                        type: PageTransitionType.fade,
                        duration: const Duration(milliseconds: 500),
                      ),
                    );
                  } else {
                    snackBar('Something went wrong!', context, vertical: 150);
                  }
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
