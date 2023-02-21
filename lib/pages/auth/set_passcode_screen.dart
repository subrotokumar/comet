import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import 'package:comet/pages/home.dart';
import 'package:comet/services/providers/walletprovider.dart';

import '../../utils/theme.dart';

class SetPasscodeScreen extends StatefulWidget {
  SetPasscodeScreen(this._recovery, {super.key, this.hide = false});
  final String _recovery;
  final bool hide;

  @override
  State<SetPasscodeScreen> createState() => _SetPasscodeScreenState();
}

class _SetPasscodeScreenState extends State<SetPasscodeScreen> {
  String n = '';
  void addN(String nn) {
    if (n.length < 6) {
      setState(() => n += nn);
    }
  }

  void clear() => setState(() => {n = ''});

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.hide
          ? null
          : AppBar(
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
                        color: i <= 2 ? Colors.white : Colors.white12,
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
                'Create Passcode',
                style: TextStyle(
                  color: AppTheme.textColor,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'This extra layer of security helps prevent someone with your phone from accessing your funds.',
                style: TextStyle(
                  color: AppTheme.textColor,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          for (int i = 1; i <= 6; i++)
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Center(
                                child: Text(
                                  n.toString().length >= i ? '💠' : ' ',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                              onTap: () => addN('1'), child: NumberButton(1)),
                          GestureDetector(
                              onTap: () => addN('2'), child: NumberButton(2)),
                          GestureDetector(
                              onTap: () => addN('3'), child: NumberButton(3)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                              onTap: () => addN('4'), child: NumberButton(4)),
                          GestureDetector(
                              onTap: () => addN('5'), child: NumberButton(5)),
                          GestureDetector(
                              onTap: () => addN('6'), child: NumberButton(6)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                              onTap: () => addN('7'), child: NumberButton(7)),
                          GestureDetector(
                              onTap: () => addN('8'), child: NumberButton(8)),
                          GestureDetector(
                              onTap: () => addN('9'), child: NumberButton(9)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              backgroundColor:
                                  Colors.redAccent.withOpacity(0.5),
                              child: const Center(
                                child: Icon(Icons.clear, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () async {
                  setState(() {
                    isLoading = true;
                  });
                  await Provider.of<WalletProvider>(context, listen: false)
                      .storage
                      .write(key: 'loginPasscode', value: n);
                  await Provider.of<WalletProvider>(context, listen: false)
                      .getLoggedFirstTime(widget._recovery);
                  Navigator.push(
                    context,
                    PageTransition(
                      child: HomeScreen(),
                      type: PageTransitionType.fade,
                      duration: const Duration(milliseconds: 500),
                    ),
                  );
                  isLoading = false;
                },
                child: Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.white30,
                  ),
                  child: Center(
                    child: isLoading
                        ? CircularProgressIndicator()
                        : Text(
                            'Create Passcode',
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
}
