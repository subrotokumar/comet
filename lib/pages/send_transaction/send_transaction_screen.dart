import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:web3dart/web3dart.dart';

import 'package:comet/services/functions/functions.dart';
import 'package:comet/services/providers/transaction_provider.dart';
import 'package:comet/utils/theme.dart';

import '../../services/providers/walletprovider.dart';

class SendTransactionScreen extends StatefulWidget {
  SendTransactionScreen({super.key, this.address});
  String? address;
  @override
  State<SendTransactionScreen> createState() => _SendTransactionScreenState();
}

class _SendTransactionScreenState extends State<SendTransactionScreen> {
  @override
  void initState() {
    if (widget.address != null) {
      sentTo.text = widget.address!;
    }
    super.initState();
  }

  TextEditingController sentTo = TextEditingController();

  TextEditingController value = TextEditingController();

  @override
  Widget build(BuildContext context) {
    WalletProvider walletProvider = context.read<WalletProvider>();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Send Transaction'),
          centerTitle: true,
          backgroundColor: AppTheme.bodyBackgroundColor,
        ),
        backgroundColor: AppTheme.bodyBackgroundColor,
        body: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Image.asset(
                'assets/images/${walletProvider.getNetwork.chainId == '1' || walletProvider.getNetwork.chainId == '5' ? 'ethereum' : 'polygon'}.png',
                height: 140,
              ),
              SizedBox(height: 20),
              Column(
                children: [
                  FutureBuilder<String>(
                    future: Provider.of<WalletProvider>(context, listen: false)
                        .getBalance(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting)
                        return Shimmer.fromColors(
                          baseColor: Colors.black,
                          highlightColor: Colors.grey,
                          child: Text('Loading ...'),
                        );
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Text(
                              '  ' +
                                  (double.parse(snapshot.data!) / 1e18)
                                      .toString() +
                                  '  ',
                              style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            walletProvider.getNetwork.currency,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.greenAccent.shade100,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextField(
                controller: sentTo,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  hintText:
                      'Send ${walletProvider.getNetwork.currency} to 0x...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  label: Text('Receiver Address'),
                  labelStyle: TextStyle(color: Colors.greenAccent.shade100),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: value,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  hintText: 'Send ${walletProvider.getNetwork.currency} to 0x',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  label: Text('Amount'),
                  labelStyle: TextStyle(color: Colors.greenAccent.shade100),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffix: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(' ${walletProvider.getNetwork.currency} '),
                      )),
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () async {
                  if (!sentTo.text.contains('0x')) {
                    snackBar('Invalid Sender Address !', context);
                    return;
                  }
                  if (value.text.isEmpty) {
                    snackBar('Value Field is Empty', context);
                    return;
                  }
                  var walletProvider =
                      Provider.of<WalletProvider>(context, listen: false);
                  bool allowed = await passwordAuth(context);
                  if (allowed) {
                    String txt =
                        await walletProvider.web3client.sendTransaction(
                      walletProvider.privateKey,
                      Transaction(
                        to: EthereumAddress.fromHex(sentTo.text),
                        // gasPrice: EtherAmount.inWei(BigInt.one),
                        maxGas: 100000,
                        value: EtherAmount.fromBigInt(EtherUnit.gwei,
                            BigInt.from(double.parse(value.text) * 1000000000)),
                      ),
                      chainId: int.parse(walletProvider.getNetwork.chainId),
                    );
                    setState(() {});
                    print('txt :' + txt.toString());
                    await Provider.of<TransactionProvider>(context,
                            listen: false)
                        .fetch(walletProvider);
                    Navigator.pop(context);
                  }
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
                      'Next',
                      style: TextStyle(
                        color: AppTheme.textColor,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
