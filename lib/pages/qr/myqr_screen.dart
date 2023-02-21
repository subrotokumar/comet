import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:comet/services/functions/functions.dart';
import 'package:comet/services/models/network.dart';

import '../../services/providers/walletprovider.dart';
import '../../utils/theme.dart';

class MyQrScreen extends StatefulWidget {
  const MyQrScreen({super.key});

  @override
  State<MyQrScreen> createState() => _ScanQRScreenState();
}

class _ScanQRScreenState extends State<MyQrScreen> {
  @override
  Widget build(BuildContext context) {
    String address =
        context.read<WalletProvider>().getPublicAddress.hex.toString();
    Network currentNetwork = context.read<WalletProvider>().getNetwork;
    return Scaffold(
      backgroundColor: AppTheme.bodyBackgroundColor,
      appBar: AppBar(
        title: const Text('Scan QR'),
        elevation: 0,
        centerTitle: true,
        backgroundColor: AppTheme.bodyBackgroundColor,
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Card(),
            PrettyQr(
              image: AssetImage(
                  'assets/images/${currentNetwork.chainId == '1' || currentNetwork.chainId == '5' ? 'ethereum' : 'polygon'}.png'),
              typeNumber: 3,
              size: 220,
              data: address,
              errorCorrectLevel: QrErrorCorrectLevel.M,
              roundEdges: true,
              elementColor: Colors.white,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                title: Text(
                    'Your ${currentNetwork.chainId == '1' || currentNetwork.chainId == '5' ? 'Ethereum' : 'Polygon'} Address'),
                subtitle: Text(shortAddress(address, isLong: true)),
                trailing: Card(
                  child: InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: address)).then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 100, vertical: 100),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            content: const Text(
                              "Address copied to clipboard",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: AppTheme.textColor),
                            ),
                            backgroundColor: Colors.white38,
                          ),
                        );
                      });
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('Copy'),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                // color: Colors.white30,
                gradient: LinearGradient(
                  colors: [Colors.purple.shade300, Colors.pink.shade200],
                ),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(25),
                onTap: () {
                  Share.share(
                      'My ${currentNetwork.chainId == '1' || currentNetwork.chainId == '5' ? 'Ethereum' : 'Polygon'} address : $address');
                },
                child: const Center(
                  child: Text(
                    'Share your Address',
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
    );
  }
}
