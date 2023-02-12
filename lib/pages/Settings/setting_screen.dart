import 'package:comet/pages/Settings/show_privatekey_screen.dart';
import 'package:comet/pages/auth/set_passcode_screen.dart';
import 'package:comet/pages/Settings/show_recovery_phase_screen.dart';
import 'package:comet/pages/home.dart';
import 'package:comet/pages/splash/splash_screen.dart';
import 'package:comet/utils/constants.dart';
import 'package:comet/services/functions/functions.dart';
import 'package:comet/utils/theme.dart';
import 'package:comet/services/providers/walletprovider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: AppTheme.bodyBackgroundColor,
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 40, right: 20, left: 15, bottom: 20),
                  child: const Text(
                    'Settings',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: AppTheme.textColor,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Consumer<WalletProvider>(
              builder: (context, value, child) => CustomButton(
                title: 'Network',
                value: value.getNetwork.name,
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.grey.shade900,
                    builder: (context) {
                      int index = -1;
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return Container(
                            // padding: EdgeInsets.all(20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(height: 20),
                                Text(
                                  'Select Network',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Divider(),
                                for (int i = 0; i < 4; i++)
                                  ListTile(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    title: Text(network[i].name),
                                    trailing: index == i
                                        ? Icon(Icons.verified)
                                        : Text(''),
                                    onTap: () {
                                      setState(() => index = i);
                                    },
                                  ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, bottom: 20),
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      minimumSize: Size(double.maxFinite, 50),
                                    ),
                                    onPressed: () {
                                      if (index == -1) {
                                        Navigator.pop(context);
                                      }
                                      Provider.of<WalletProvider>(context,
                                              listen: false)
                                          .changeNetwork(index);
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        PageTransition(
                                          child: HomeScreen(),
                                          type: PageTransitionType.fade,
                                        ),
                                        (route) => false,
                                      );
                                    },
                                    child: Text('Save'),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
            CustomButton(
              title: 'Change Password',
              onTap: () async {
                if (await passwordAuth(context)) {
                  Navigator.push(
                    context,
                    PageTransition(
                      child: SetPasscodeScreen(
                        context.read<WalletProvider>().mnemonics ?? '',
                        hide: true,
                      ),
                      type: PageTransitionType.rightToLeft,
                    ),
                  );
                }
              },
            ),
            CustomButton(
              title: 'Recovery Phase',
              onTap: () async {
                bool allowed = await passwordAuth(context);
                if (allowed) {
                  Navigator.push(
                    context,
                    PageTransition(
                      child: ShowRecoveryPhaseScreen(),
                      type: PageTransitionType.bottomToTop,
                    ),
                  );
                }
              },
            ),
            CustomButton(
              title: 'Export Private Key',
              onTap: () async {
                bool allowed = await passwordAuth(context);
                if (allowed) {
                  Navigator.push(
                    context,
                    PageTransition(
                      child: ShowPrivatekeyScreen(),
                      type: PageTransitionType.bottomToTop,
                    ),
                  );
                }
              },
            ),
            Visibility(
              visible: false,
              child: CustomButton(
                  title: 'Currency',
                  onTap: () {
                    showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      context: context,
                      builder: (context) {
                        int index = 0;
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return Container(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Select Currency',
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Divider(),
                                  ListTile(
                                    title: Text('USD'),
                                    trailing: index == 0
                                        ? Icon(Icons.verified)
                                        : Text(''),
                                    onTap: () => setState(() => index = 0),
                                  ),
                                  ListTile(
                                    title: Text('INR'),
                                    trailing: index == 1
                                        ? Icon(Icons.verified)
                                        : Text(''),
                                    onTap: () => setState(() => index = 1),
                                  ),
                                  OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      minimumSize: Size(double.maxFinite, 50),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Save'),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                  value: 'USD'),
            ),
            CustomButton(
              title: 'Rate Us',
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: Colors.white.withOpacity(0.95),
                      content: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/images/logo.png',
                              height: 150,
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Your opinion matters to us!',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 14),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                minimumSize: Size(double.maxFinite, 50),
                              ),
                              onPressed: () {},
                              child: Text('Rate us on Playstore'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Not Now'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            CustomButton(
              title: 'About',
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: Colors.white.withOpacity(0.95),
                      content: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'COMET',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            Spacer(),
            Text(
              'v 1 . 0 . 0',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 15,
              ),
            ),
            OutlinedButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () async {
                bool allowed = false;
                await showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Disclaimer',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Before continue, make sure to backup your secure recovery phase.',
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Not Now'),
                              ),
                              SizedBox(width: 10),
                              TextButton(
                                onPressed: () {
                                  allowed = true;
                                  Navigator.pop(context);
                                },
                                child: Text('Sign Out'),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                );
                if (!allowed) {
                  return;
                }
                allowed = await passwordAuth(context);
                if (allowed) {
                  await Provider.of<WalletProvider>(context, listen: false)
                      .SignOut();
                  Navigator.pushAndRemoveUntil(
                    context,
                    PageTransition(
                      child: SplashScreen(),
                      type: PageTransitionType.fade,
                    ),
                    (route) => false,
                  );
                  var box = Hive.box('crypto');
                  box.clear();
                }
              },
              child: Text(
                'Sign Out',
                style: GoogleFonts.poppins(
                  color: Colors.redAccent.shade200,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  CustomButton(
      {required this.title, this.value = '', required this.onTap, super.key});
  String title;
  VoidCallback onTap;
  String value = '';

  @override
  Widget build(BuildContext context) {
    if (value.isEmpty) {
      return ListTile(
        leading: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios_rounded),
        onTap: onTap,
      );
    }
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
      ),
      subtitle: Text(
        value,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios_rounded),
      onTap: onTap,
    );
  }
}
