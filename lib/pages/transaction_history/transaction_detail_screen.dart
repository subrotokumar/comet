import 'package:comet/services/models/transaction_model.dart';
import 'package:comet/services/functions/functions.dart';
import 'package:comet/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web3dart/web3dart.dart';
import '../../services/providers/walletprovider.dart';

class TransactionDetailScreen extends StatelessWidget {
  TransactionDetailScreen(this.transaction, {super.key});
  TransactionModel transaction;

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

  var titleTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.1,
    color: Colors.green.shade100,
  );
  @override
  Widget build(BuildContext context) {
    var data = transaction;
    DateTime d =
        DateTime.fromMillisecondsSinceEpoch(int.parse(data.timeStamp) * 1000);

    var val = EtherAmount.inWei(BigInt.parse(data.value)).getInWei.toString();
    var valueInEthers = (double.parse(val) / 1e18).toString();
    if (valueInEthers.length > 6) {
      valueInEthers = valueInEthers.substring(0, 7);
    }
    bool flag = data.from ==
        Provider.of<WalletProvider>(context, listen: false)
            .getPublicAddress
            .hex;
    String currency =
        Provider.of<WalletProvider>(context, listen: false).getNetwork.currency;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.bodyBackgroundColor,
          title: Text(
            flag ? 'Sent $currency' : 'Received $currency',
            style: TextStyle(
                color: flag
                    ? Colors.blueAccent.shade100
                    : Colors.greenAccent.shade100),
          ),
          centerTitle: true,
        ),
        backgroundColor: AppTheme.bodyBackgroundColor,
        body: Column(
          children: [
            SizedBox(
              height: 80,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    val,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'WEI',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Divider(thickness: 1),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: Text(
                        'Time',
                        style: titleTextStyle,
                      ),
                      trailing: Text(
                          '${d.day} ${month[d.month]} ${d.hour}:${d.minute}:${d.microsecond} ${d.timeZoneName}'),
                    ),
                    ListTile(
                      leading: Text(
                        'From',
                        style: titleTextStyle,
                      ),
                      trailing: Text(shortAddress(data.from, isLong: true)),
                    ),
                    if (data.to.isNotEmpty)
                      ListTile(
                        leading: Text(
                          'To',
                          style: titleTextStyle,
                        ),
                        trailing: Text(shortAddress(data.to, isLong: true)),
                      ),
                    ListTile(
                      leading: Text(
                        'Hash',
                        style: titleTextStyle,
                      ),
                      trailing: Text(shortAddress(data.hash, isLong: true)),
                    ),
                    ListTile(
                      leading: Text(
                        'Nonce',
                        style: titleTextStyle,
                      ),
                      trailing: Text(data.nonce),
                    ),
                    if (data.functionName.isNotEmpty)
                      ListTile(
                        leading: Text(
                          'Function',
                          style: titleTextStyle,
                        ),
                        trailing: Text(data.functionName),
                      ),
                    ListTile(
                      leading: Text(
                        'Block Number',
                        style: titleTextStyle,
                      ),
                      trailing: Text(data.blockNumber),
                    ),
                    if (data.contractAddress.isNotEmpty)
                      ListTile(
                        leading: Text(
                          'Contract Number',
                          style: titleTextStyle,
                        ),
                        trailing: Text(
                            shortAddress(data.contractAddress, isLong: true)),
                      ),
                    if (data.gas.isNotEmpty)
                      ListTile(
                        leading: Text(
                          'Gas',
                          style: titleTextStyle,
                        ),
                        trailing: Text(data.gas),
                      ),
                    if (data.gasPrice.isNotEmpty)
                      ListTile(
                        leading: Text(
                          'Gas Price',
                          style: titleTextStyle,
                        ),
                        trailing: Text(data.gasPrice),
                      ),
                    if (data.gasUsed.isNotEmpty)
                      ListTile(
                        leading: Text(
                          'Gas Used',
                          style: titleTextStyle,
                        ),
                        trailing: Text(data.gasUsed),
                      ),
                    if (data.cumulativeGasUsed.isNotEmpty)
                      ListTile(
                        leading: Text(
                          'Cumulative Gas Used',
                          style: titleTextStyle,
                        ),
                        trailing: Text(data.cumulativeGasUsed),
                      ),
                  ],
                ),
              ),
            ),
            Divider(thickness: 1),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                WalletProvider walletProvider =
                    Provider.of<WalletProvider>(context, listen: false);

                await launchUrl(Uri.parse(
                    '${walletProvider.getNetwork.blockExplorer}/tx/${data.hash}'));
              },
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: LinearGradient(
                    colors: [Colors.purple.shade300, Colors.pink.shade200],
                  ),
                ),
                child: const Center(
                  child: Text(
                    'View on Block',
                    style: TextStyle(
                      color: AppTheme.textColor,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
