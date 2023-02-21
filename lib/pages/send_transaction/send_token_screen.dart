import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'package:comet/services/functions/functions.dart';
import 'package:comet/utils/theme.dart';

import '../../services/providers/walletprovider.dart';

class SendTokenScreen extends StatefulWidget {
  SendTokenScreen(this.tokenIndex, {super.key, this.address = ''});
  int tokenIndex = 0;
  String address;
  @override
  State<SendTokenScreen> createState() => _SendTokenScreenState();
}

class _SendTokenScreenState extends State<SendTokenScreen> {
  late Box crypto;
  late Map data;
  @override
  void initState() {
    crypto = Hive.box('crypto');
    data = crypto.getAt(widget.tokenIndex);
    sentTo.text = widget.address;
    super.initState();
  }

  TextEditingController sentTo = TextEditingController();

  TextEditingController value = TextEditingController();

  var col = [
    Colors.greenAccent.shade100,
    Colors.yellowAccent.shade100,
    Colors.redAccent.shade100,
    Colors.blueAccent.shade100,
  ];

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
              Card(
                margin: EdgeInsets.all(0),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.white10,
                    child: CachedNetworkImage(
                      imageUrl: data['logo'] ?? '',
                      height: 50,
                      errorWidget: (context, url, error) => CircleAvatar(
                        radius: 25,
                        backgroundColor:
                            col[widget.tokenIndex % 4].withOpacity(0.5),
                        child: Image.asset(
                          walletProvider.getNetwork.chainId == '1' ||
                                  walletProvider.getNetwork.chainId == '5'
                              ? 'assets/icons/ethereum_coins.png'
                              : 'assets/icons/polygon_coins.png',
                          height: 35,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    data['name'] ?? '',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.amber.shade100,
                    ),
                  ),
                  subtitle: Text(
                    data['symbol'] ?? '',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.blueAccent.shade100,
                    ),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      FutureBuilder<List>(
                        future: readFunction(
                          functionName: 'balanceOf',
                          args: [walletProvider.getPublicAddress],
                          contractAddress: data['address'] ?? '',
                          contractName: data['name'] ?? '',
                          web3client: walletProvider.web3client,
                        ),
                        builder: (context, snapshot) {
                          int decimal = data['decimals'];
                          if (snapshot.connectionState ==
                              ConnectionState.waiting)
                            return Shimmer.fromColors(
                              baseColor: Colors.black,
                              highlightColor: Colors.grey,
                              child: Text('Loading ...'),
                            );
                          var val = snapshot.data![0] as BigInt;

                          return Text(
                            (val.toDouble() / pow(10, decimal)).toString(),
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        },
                      ),
                      Text('Decimals: ${data['decimals']}'),
                    ],
                  ),
                  onTap: () async {
                    int val = await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          content: Container(
                            constraints: BoxConstraints(
                              maxHeight: 300,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                for (int i = 0; i < crypto.length; i++)
                                  ListTile(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    title: Text(
                                      crypto.getAt(i)['name'].toString(),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    subtitle: Text(
                                      crypto.getAt(i)['symbol'].toString(),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onTap: () => Navigator.pop(context, i),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                    data = crypto.getAt(val);
                    setState(() {});
                  },
                ),
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
                  bool allowed = await passwordAuth(context);
                  if (allowed) {
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
                      writeFunction(
                        functionName: 'transfer',
                        args: [
                          sentTo.text,
                          BigInt.from(double.parse(value.text) *
                              pow(10.0, data['decimals']))
                        ],
                        contractAddress: data['address'],
                        contractName: data['name'],
                        privateKey: walletProvider.privateKey,
                        web3client: walletProvider.web3client,
                      );
                      Navigator.pop(context);
                    }
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
