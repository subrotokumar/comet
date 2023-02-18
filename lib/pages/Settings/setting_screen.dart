import 'dart:io';

import 'package:comet/pages/Settings/show_privatekey_screen.dart';
import 'package:comet/pages/auth/set_passcode_screen.dart';
import 'package:comet/pages/Settings/show_recovery_phase_screen.dart';
import 'package:comet/pages/home.dart';
import 'package:comet/pages/splash/splash_screen.dart';
import 'package:comet/services/functions/social_link.dart';
import 'package:comet/utils/constants.dart';
import 'package:comet/services/functions/functions.dart';
import 'package:comet/utils/theme.dart';
import 'package:comet/services/providers/walletprovider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
              title: 'Legal',
              onTap: () {
                // ----
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.grey.shade900,
                  builder: (context) {
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return Container(
                          // padding: EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: 30),
                              ListTile(
                                leading: Text(
                                  'Privacy Policy',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                trailing: Icon(Icons.link_rounded),
                                onTap: () async {
                                  await launchUrlString(
                                      'https://subrotokumar.github.io/privacy-policy/comet.html');
                                },
                              ),
                              CustomButton(
                                title: 'Terms and Condition',
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        backgroundColor:
                                            Colors.white.withOpacity(0.95),
                                        content: Container(
                                          height: 400,
                                          padding: EdgeInsets.all(10),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '\nTerms & Conditions\n',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black),
                                                ),
                                                Text(
                                                  'By downloading or using the app, these terms will automatically apply to you \– you should make sure therefore that you read them carefully before using the app. You\’re not allowed to copy or modify the app, any part of the app, or our trademarks in any way. You\’re not allowed to attempt to extract the source code of the app, and you also shouldn’t try to translate the app into other languages or make derivative versions. The app itself, and all the trademarks, copyright, database rights, and other intellectual property rights related to it, still belong to Subroto Kumar.\n\nSubroto Kumar is committed to ensuring that the app is as useful and efficient as possible. For that reason, we reserve the right to make changes to the app or to charge for its services, at any time and for any reason. We will never charge you for the app or its services without making it very clear to you exactly what you’re paying for.\n\nThe Comet app stores and processes personal data that you have provided to us, to provide my Service. It’s your responsibility to keep your phone and access to the app secure. We therefore recommend that you do not jailbreak or root your phone, which is the process of removing software restrictions and limitations imposed by the official operating system of your device. It could make your phone vulnerable to malware/viruses/malicious programs, compromise your phone’s security features and it could mean that the Comet app won’t work properly or at all.\n\n\n\nYou should be aware that there are certain things that Subroto Kumar will not take responsibility for. Certain functions of the app will require the app to have an active internet connection. The connection can be Wi-Fi or provided by your mobile network provider, but Subroto Kumar cannot take responsibility for the app not working at full functionality if you don’t have access to Wi-Fi, and you don’t have any of your data allowance left.\n\nIf you’re using the app outside of an area with Wi-Fi, you should remember that the terms of the agreement with your mobile network provider will still apply. As a result, you may be charged by your mobile provider for the cost of data for the duration of the connection while accessing the app, or other third-party charges. In using the app, you’re accepting responsibility for any such charges, including roaming data charges if you use the app outside of your home territory (i.e. region or country) without turning off data roaming. If you are not the bill payer for the device on which you’re using the app, please be aware that we assume that you have received permission from the bill payer for using the app.\n\nAlong the same lines, Subroto Kumar cannot always take responsibility for the way you use the app i.e. You need to make sure that your device stays charged – if it runs out of battery and you can’t turn it on to avail the Service, Subroto Kumar cannot accept responsibility.\n\nWith respect to Subroto Kumar\’s responsibility for your use of the app, when you’re using the app, it’s important to bear in mind that although we endeavor to ensure that it is updated and correct at all times, we do rely on third parties to provide information to us so that we can make it available to you. Subroto Kumar accepts no liability for any loss, direct or indirect, you experience as a result of relying wholly on this functionality of the app.\n\nAt some point, we may wish to update the app. The app is currently available on Android & iOS – the requirements for the both systems(and for any additional systems we decide to extend the availability of the app to) may change, and you’ll need to download the updates if you want to keep using the app. Subroto Kumar does not promise that it will always update the app so that it is relevant to you and/or works with the Android & iOS version that you have installed on your device. However, you promise to always accept updates to the application when offered to you, We may also wish to stop providing the app, and may terminate use of it at any time without giving notice of termination to you. Unless we tell you otherwise, upon any termination, (a) the rights and licenses granted to you in these terms will end; (b) you must stop using the app, and (if needed) delete it from your device.\n\nChanges to This Terms and Conditions\n\nI may update our Terms and Conditions from time to time. Thus, you are advised to review this page periodically for any changes. I will notify you of any changes by posting the new Terms and Conditions on this page.\n\nThese terms and conditions are effective as of 2023-02-12\n\nContact Us\n\nIf you have any questions or suggestions about my Terms and Conditions, do not hesitate to contact me at isubrotokumar@gmail.com.\n\nThis Terms and Conditions page was generated by App Privacy Policy Generator',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                                SizedBox(height: 20),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    ElevatedButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context),
                                                      child: Text('Close'),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
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
                              onPressed: () {
                                if (Platform.isAndroid) {
                                  launchUrlString(
                                      'https://play.google.com/store/apps/details?id=com.subrotokumar.comet');
                                }
                              },
                              child: Text(
                                  'Rate us on ${Platform.isAndroid ? 'Playstore' : 'Appstore'}'),
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
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Divider(
                              thickness: 0.5,
                              color: Colors.black12,
                            ),
                            Text(
                              'Comet is a simple yet powerful crypto and NFT management application. Comet has been developed to simplify the process of viewing, transferring, and storing your digital assets while maintaining the security of your funds with its encrypted private key storage. In Comet, you can easily create, transfer and manage your digital assets.',
                              textAlign: TextAlign.justify,
                              style: TextStyle(color: Colors.black87),
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Connect With Me',
                                  style: GoogleFonts.poppins(
                                    color: Colors.black87,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GitHub(username: 'subrotokumar'),
                                Twitter(username: 'isubrotokumar')
                              ],
                            )
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
