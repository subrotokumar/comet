import 'package:comet/pages/home.dart';
import 'package:comet/services/functions/functions.dart';
import 'package:comet/services/providers/walletprovider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../utils/theme.dart';

class PasswordScreen extends StatefulWidget {
  PasswordScreen({super.key});

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  bool isLoading = false;
  String n = '';
  void addN(String nn) {
    if (n.length < 6) {
      setState(() => n += nn);
    }
  }

  @override
  Widget build(BuildContext context) {
    WalletProvider walletProvider =
        Provider.of<WalletProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: AppTheme.bodyBackgroundColor,
      body: Container(
        padding: EdgeInsets.all(20),
        width: double.infinity,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Text(
                'Enter Password',
                style: GoogleFonts.poppins(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 1; i <= 6; i++)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Center(
                        child: Text(
                          n.toString().length >= i ? '🔹' : ' ',
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                      onTap: () => addN('1'), child: NumberButton(1)),
                  GestureDetector(
                      onTap: () => addN('2'), child: NumberButton(2)),
                  GestureDetector(
                      onTap: () => addN('3'), child: NumberButton(3)),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                      onTap: () => addN('4'), child: NumberButton(4)),
                  GestureDetector(
                      onTap: () => addN('5'), child: NumberButton(5)),
                  GestureDetector(
                      onTap: () => addN('6'), child: NumberButton(6)),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                      onTap: () => addN('7'), child: NumberButton(7)),
                  GestureDetector(
                      onTap: () => addN('8'), child: NumberButton(8)),
                  GestureDetector(
                      onTap: () => addN('9'), child: NumberButton(9)),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.transparent,
                  ),
                  GestureDetector(
                      onTap: () => addN('0'), child: NumberButton(0)),
                  GestureDetector(
                    onTap: () => clear(),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.redAccent.withOpacity(0.5),
                      child: const Center(
                        child: Icon(Icons.clear, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: () async {
                  setState(() {
                    isLoading = true;
                  });
                  bool flag = await walletProvider.getLoggedByPassword(n);
                  if (flag) {
                    Navigator.pushReplacement(
                      context,
                      PageTransition(
                          child: HomeScreen(),
                          type: PageTransitionType.bottomToTop),
                    );
                  } else {
                    snackBar('Wrong Password', context, vertical: 50);
                  }
                  setState(() {
                    isLoading = false;
                  });
                },
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: n.length < 6
                      ? Colors.blueGrey.withOpacity(0.2)
                      : Colors.blue,
                  foregroundColor:
                      Colors.white.withOpacity(n.length < 6 ? 0.2 : 1),
                  child: isLoading
                      ? CircularProgressIndicator()
                      : Icon(
                          Icons.arrow_forward,
                          size: 40,
                        ),
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget NumberButton(int n) {
    return CircleAvatar(
      radius: 30,
      backgroundColor: Colors.blueGrey.withOpacity(0.5),
      child: Center(
        child: Text(
          '$n',
          style: const TextStyle(
            color: AppTheme.textColor,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void clear() => setState(() => {n = ''});
}
