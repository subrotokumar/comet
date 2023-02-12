import 'package:comet/pages/transaction_history/transaction_detail_screen.dart';
import 'package:comet/services/functions/functions.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

import '../../services/providers/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:web3dart/web3dart.dart';

import '../../utils/theme.dart';
import '../../services/providers/walletprovider.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> month = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'June',
      'July',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    WalletProvider walletProvider =
        Provider.of<WalletProvider>(context, listen: false);
    TransactionProvider transactionProvider =
        Provider.of<TransactionProvider>(context, listen: false);
    return RefreshIndicator(
      onRefresh: () async {
        await transactionProvider.fetch(walletProvider);
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppTheme.bodyBackgroundColor,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
                child: const Text(
                  'Transactions',
                  style: TextStyle(
                    color: AppTheme.textColor,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Consumer<TransactionProvider>(
                  builder: (context, value, child) {
                    if (value.isLoading) {
                      return ListView.builder(
                        itemBuilder: (context, index) {
                          return Shimmer.fromColors(
                            baseColor: Colors.white10,
                            highlightColor: Colors.white12,
                            child: Container(
                              height: 70,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.yellow,
                              ),
                              child: const ListTile(
                                title: Text(''),
                              ),
                            ),
                          );
                        },
                        itemCount: 7,
                      );
                    } else if (!value.isLoading &&
                        value.transactionsList.isEmpty) {
                      return SizedBox(
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            LottieBuilder.asset('assets/lotties/wallet.json'),
                            SizedBox(height: 10),
                            Text(
                              'No Transaction Found !',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          ],
                        ),
                      );
                    } else {
                      return ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        itemBuilder: (context, index) {
                          var data = value.transactionsList[index];
                          DateTime d = DateTime.fromMillisecondsSinceEpoch(
                              int.parse(data.timeStamp) * 1000);
                          var val = EtherAmount.inWei(BigInt.parse(data.value))
                              .getInWei
                              .toString();
                          var address = context
                              .read<WalletProvider>()
                              .getPublicAddress
                              .hex
                              .toString();
                          var valueInEthers =
                              (double.parse(val) / 1e18).toString();
                          if (valueInEthers.length > 6) {
                            valueInEthers = valueInEthers.substring(0, 7);
                          }
                          return ListTile(
                            leading: CircleAvatar(
                              radius: 21,
                              backgroundColor: data.from == address
                                  ? Colors.blueAccent.shade100
                                  : Colors.greenAccent.shade100,
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: AppTheme.bodyBackgroundColor,
                                child: Icon(
                                  data.from == address
                                      ? Icons.call_made_sharp
                                      : Icons.call_received_rounded,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            title: Text(shortAddress(data.hash)),
                            subtitle: Text(
                                '${d.day} ${month[d.month]}, ${d.year} - ${d.hour}:${d.minute} ${d.timeZoneName}'),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  valueInEthers,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue.shade200,
                                  ),
                                ),
                                Text(walletProvider.getNetwork.currency),
                              ],
                            ),
                            onTap: () {
                              print(data.toString());
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      child: TransactionDetailScreen(data),
                                      type: PageTransitionType.bottomToTop,
                                      duration: Duration(milliseconds: 600)));
                            },
                          );
                        },
                        itemCount: value.transactionsList.length,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
