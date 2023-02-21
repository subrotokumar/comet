import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'package:comet/pages/send_transaction/send_token_screen.dart';
import 'package:comet/services/functions/functions.dart';

import '../../services/providers/walletprovider.dart';

class CryptoTab extends StatefulWidget {
  const CryptoTab({super.key});

  @override
  State<CryptoTab> createState() => _CryptoTabState();
}

class _CryptoTabState extends State<CryptoTab> {
  late Box crypto;
  @override
  void initState() {
    crypto = Hive.box('crypto');
    super.initState();
  }

  var col = [
    Colors.greenAccent.shade100,
    Colors.yellowAccent.shade100,
    Colors.redAccent.shade100,
    Colors.blueAccent.shade100,
  ];

  @override
  Widget build(BuildContext context) {
    WalletProvider walletProvider =
        Provider.of<WalletProvider>(context, listen: false);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white10,
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 12),
              leading: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.white10,
                child: Image.asset(
                  walletProvider.getNetwork.chainId == '1' ||
                          walletProvider.getNetwork.chainId == '5'
                      ? 'assets/images/ethereum.png'
                      : 'assets/images/polygon.png',
                  height: 40,
                ),
              ),
              title: Text(
                walletProvider.getNetwork.name,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.amber.shade100,
                ),
              ),
              subtitle: Text(
                walletProvider.getNetwork.currency,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueAccent.shade100,
                ),
              ),
              trailing: FutureBuilder<String>(
                future: Provider.of<WalletProvider>(context, listen: false)
                    .getBalance(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Shimmer.fromColors(
                      baseColor: Colors.black,
                      highlightColor: Colors.grey,
                      child: Text('Loading ...'),
                    );
                  return Text(
                    (double.parse(snapshot.data!) / 1e18).toString(),
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                },
              ),
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            child: ListView.builder(
              padding: EdgeInsets.all(0),
              itemBuilder: (context, index) {
                Map data = crypto.getAt(index);
                if (data['id'] == walletProvider.getNetwork.id)
                  return Container(
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white10,
                    ),
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
                            backgroundColor: col[index % 4].withOpacity(0.5),
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
                      trailing: FutureBuilder<List>(
                        future: readFunction(
                          functionName: 'balanceOf',
                          args: [walletProvider.getPublicAddress],
                          contractAddress: data['address'] ?? '',
                          contractName: data['name'] ?? '',
                          web3client: walletProvider.web3client,
                        ),
                        builder: (context, snapshot) {
                          int decimal = data['decimals'];
                          print(decimal);
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
                      onTap: () async {
                        await showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(10)),
                          ),
                          context: context,
                          builder: (context) {
                            return Padding(
                              padding: EdgeInsets.all(20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                // mainAxisSize: MainAxisSize.min,
                                children: [
                                  OutlinedButton.icon(
                                    icon: Icon(Icons.call_made_rounded),
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                        context,
                                        PageTransition(
                                          child: SendTokenScreen(index),
                                          type: PageTransitionType.bottomToTop,
                                        ),
                                      );
                                    },
                                    label: Text('Send Token'),
                                  ),
                                  OutlinedButton.icon(
                                    icon: Icon(Icons.clear_all_rounded),
                                    onPressed: () {
                                      crypto.deleteAt(index);
                                      Navigator.pop(context);
                                    },
                                    label: Text('Remove Token'),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                        setState(() {});
                      },
                    ),
                  );
                else
                  return Container();
              },
              itemCount: crypto.length,
            ),
          ),
        ],
      ),
    );
  }
}
