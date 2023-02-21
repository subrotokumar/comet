import 'dart:convert';

import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'package:comet/pages/dashboard/crypto_tab.dart';
import 'package:comet/pages/dashboard/nft_tab.dart';
import 'package:comet/pages/home.dart';
import 'package:comet/pages/qr/myqr_screen.dart';
import 'package:comet/pages/send_transaction/send_transaction_screen.dart';
import 'package:comet/services/functions/market.dart';
import 'package:comet/services/providers/walletprovider.dart';
import 'package:comet/utils/theme.dart';

import '../../services/functions/functions.dart';
import '../qr/scan_qr_screen.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var walletProvider = Provider.of<WalletProvider>(context, listen: false);
    TabController tabController = TabController(length: 2, vsync: this);

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppTheme.bodyBackgroundColor,
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(20),
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: RadialGradient(
                    colors: [
                      Colors.indigo.shade100,
                      Colors.indigo.shade200,
                      Colors.pink.shade200,
                      Colors.purple.shade200,
                      Colors.blue.shade400,
                    ],
                    radius: 2,
                    center: Alignment.topLeft,
                  ),
                ),
                child: Stack(
                  children: [
                    Container(
                      height: 200,
                      margin: EdgeInsets.only(bottom: 50, top: 40),
                      child: FutureBuilder(
                          future: getMarketChart(walletProvider),
                          builder: (context, snapshot) {
                            return snapshot.hasData
                                ? Sparkline(
                                    data: snapshot.data!,
                                    lineColor: Colors.indigo.withOpacity(0.5),
                                    lineWidth: 2,
                                    fillGradient: LinearGradient(
                                      colors: [
                                        Colors.indigo.shade200,
                                        Colors.indigo.shade300,
                                        Colors.pink.shade300,
                                        Colors.purple.shade300,
                                        Colors.blue.shade500,
                                      ],
                                    ),
                                    fillMode: FillMode.below,
                                    // fillColor:
                                    //     Colors.blue.shade400.withOpacity(0.7),
                                  )
                                : Container();
                          }),
                    ),
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(width: 5),
                                  Opacity(
                                    opacity: 0.9,
                                    child: Image.asset(
                                      'assets/icons/chip.png',
                                      width: 40,
                                    ),
                                  ),
                                  Spacer(),
                                  Opacity(
                                    opacity: 0,
                                    child: Image.asset(
                                      'assets/images/logo.png',
                                      width: 40,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '  NETWORK',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    '  PUBLIC ADDRESS',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    ' ' +
                                        walletProvider.getNetwork.name
                                            .toUpperCase(),
                                    style: GoogleFonts.fredoka(
                                      textStyle: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        shadows: const [
                                          Shadow(
                                            blurRadius: 2,
                                            color: Colors.purple,
                                            offset: Offset(1, 1),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Text(
                                    shortAddress(
                                        walletProvider.getPublicAddress.hex),
                                    style: GoogleFonts.fredoka(
                                      textStyle: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        shadows: const [
                                          Shadow(
                                            blurRadius: 2,
                                            color: Colors.purple,
                                            offset: Offset(1, 1),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        Container(
                          height: 50,
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.indigo.withOpacity(0.5),
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(20)),
                          ),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  FutureBuilder<dynamic>(
                                    future: walletProvider.getBalance(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Shimmer.fromColors(
                                          baseColor: Colors.transparent,
                                          highlightColor:
                                              Colors.pinkAccent.shade100,
                                          child: Container(
                                            height: 20,
                                            width: 20,
                                            color: Colors.transparent,
                                          ),
                                        );
                                      }
                                      double balance = double.parse(
                                              snapshot.data.toString()) /
                                          1e18;
                                      return Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            balance == 0
                                                ? '0.0'
                                                : balance
                                                    .toString()
                                                    .substring(0, 8),
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white
                                                    .withOpacity(0.7),
                                                shadows: const [
                                                  Shadow(
                                                    blurRadius: 10,
                                                    color: Colors.blueGrey,
                                                    offset: Offset(1, 1),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            walletProvider.getNetwork.currency,
                                            style: GoogleFonts.poppins(
                                              textStyle: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black
                                                    .withOpacity(0.7),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  Text(
                                    'Balance',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white70),
                                  ),
                                ],
                              ),
                              Spacer(),
                              walletProvider.getNetwork.chainId == '1' ||
                                      walletProvider.getNetwork.chainId == '5'
                                  ? Image.asset('assets/images/ethereum.png',
                                      height: 30)
                                  : Image.asset('assets/images/polygon.png',
                                      height: 30),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        PageTransition(
                          child: const MyQrScreen(),
                          type: PageTransitionType.bottomToTop,
                        ),
                      ),
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          color: Colors.indigo.shade400.withOpacity(0.7),
                        ),
                        child: const Icon(
                          Icons.call_received_rounded,
                          size: 30,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        PageTransition(
                          child: SendTransactionScreen(),
                          type: PageTransitionType.bottomToTop,
                        ),
                      ),
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          color: Colors.indigo.shade400.withOpacity(0.7),
                        ),
                        child: const Icon(
                          Icons.call_made_rounded,
                          size: 30,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            child: ScanQRScreen(),
                            type: PageTransitionType.bottomToTop,
                          ),
                        );
                      },
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          color: Colors.indigo.shade400.withOpacity(0.7),
                        ),
                        child: const Icon(
                          Icons.qr_code_scanner_rounded,
                          size: 30,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          PageTransition(
                            child: HomeScreen(index: 1),
                            type: PageTransitionType.rightToLeft,
                            duration: Duration(milliseconds: 400),
                          ),
                        );
                      },
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          color: Colors.indigo.shade400.withOpacity(0.7),
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/icons/ic_transaction.png',
                            height: 30,
                            width: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        Box crypto = Hive.box('crypto');
                        await showModalBottomSheet(
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(30),
                            ),
                          ),
                          builder: (context) {
                            TextEditingController controller =
                                TextEditingController();
                            return StatefulBuilder(
                              builder: (context, newState) {
                                submit() async {
                                  // crypto.deleteAt(0);
                                  // return;
                                  var res = await http.post(
                                    Uri.parse(walletProvider.getNetwork.rpc),
                                    body: jsonEncode({
                                      "id": 1,
                                      "jsonrpc": "2.0",
                                      "method": "alchemy_getTokenMetadata",
                                      "params": [
                                        controller.text,
                                      ]
                                    }),
                                    headers: {
                                      "accept": "application/json",
                                      "content-type": "application/json",
                                    },
                                  );
                                  if (res.statusCode == 200) {
                                    var data = jsonDecode(res.body)["result"];
                                    data['address'] = controller.text;
                                    data['id'] = walletProvider.getNetwork.id;
                                    crypto.add(data!);
                                    print(data);
                                    setState(() {});
                                    Navigator.pop(context);
                                  }
                                }

                                return Container(
                                  padding: EdgeInsets.fromLTRB(20, 20, 20,
                                      MediaQuery.of(context).viewInsets.bottom),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Import Token',
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      TextField(
                                        controller: controller,
                                        onSubmitted: (v) => submit,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide:
                                                BorderSide(color: Colors.grey),
                                          ),
                                          labelText: 'Contract Address',
                                          labelStyle:
                                              TextStyle(color: Colors.grey),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide:
                                                BorderSide(color: Colors.white),
                                          ),
                                          suffixIcon: InkWell(
                                            onTap: submit,
                                            child: Icon(
                                              Icons.arrow_forward_ios,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        );
                        setState(() {});
                      },
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          color: Colors.indigo.shade400.withOpacity(0.7),
                        ),
                        child: const Icon(
                          Icons.scatter_plot_rounded,
                          size: 30,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorColor: Colors.blue,
                  controller: tabController,
                  tabs: const [
                    Tab(text: "Assets"),
                    Tab(text: "NFTs"),
                  ],
                ),
              ),
              Flexible(
                child: TabBarView(
                  controller: tabController,
                  children: [
                    CryptoTab(),
                    NftTab(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
