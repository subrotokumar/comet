import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:comet/pages/Settings/setting_screen.dart';
import 'package:comet/services/providers/walletprovider.dart';

import '../services/providers/nft_provider.dart';
import '../services/providers/transaction_provider.dart';
import '../utils/theme.dart';
import 'dashboard/wallet_screen.dart';
import 'transaction_history/transaction_screen.dart';

class HomeScreen extends StatefulWidget {
  static const route = '/home';
  HomeScreen({this.index = 0, super.key});
  final int index;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int page = 0;

  @override
  void initState() {
    page = widget.index;
    var walletProvider = Provider.of<WalletProvider>(context, listen: false);
    walletProvider.initialize();
    Provider.of<TransactionProvider>(context, listen: false)
        .fetch(walletProvider);
    Provider.of<NFTProvider>(context, listen: false).fetch(walletProvider);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bodyBackgroundColor,
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white10,
        destinations: [
          NavigationDestination(
            icon: Icon(
              Icons.wallet,
              size: 25,
              color: page == 0 ? Colors.white : Colors.white54,
            ),
            label: 'Wallet',
          ),
          NavigationDestination(
              icon: Icon(
                Icons.list_alt,
                size: 25,
                color: page == 1 ? Colors.white : Colors.white54,
              ),
              label: 'Transaction'),
          // NavigationDestination(
          //     icon: Icon(
          //       Icons.card_travel_rounded,
          //       size: 25,
          //       color: page == 2 ? Colors.white : Colors.white54,
          //     ),
          //     label: ''),
          // NavigationDestination(
          //     icon: Image.asset(
          //       'assets/icons/ic_news.png',
          //       color: page == 3 ? Colors.white : Colors.white54,
          //       height: 25,
          //     ),
          //     label: ''),
          NavigationDestination(
              icon: Image.asset(
                'assets/icons/ic_setting.png',
                color: page == 2 ? Colors.white : Colors.white54,
                height: 25,
              ),
              label: 'Settings'),
        ],
        onDestinationSelected: (value) {
          if (page != value)
            setState(() {
              page = value;
            });
        },
        selectedIndex: page,
      ),
      body: [
        WalletScreen(),
        TransactionScreen(),
        SettingsScreen(),
        // WelcomeSplashScreen(),
        // SettingsScreen(),
      ][page],
    );
  }
}
