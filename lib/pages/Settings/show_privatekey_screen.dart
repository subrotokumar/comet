import 'package:comet/services/providers/walletprovider.dart';
import 'package:provider/provider.dart';
import '../../utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShowPrivatekeyScreen extends StatelessWidget {
  ShowPrivatekeyScreen({super.key});

  bool view = false;

  @override
  Widget build(BuildContext context) {
    var walletProvider = Provider.of<WalletProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.appBarColor,
        title: Text('Private Key'),
        centerTitle: true,
      ),
      backgroundColor: AppTheme.bodyBackgroundColor,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                'Private key must be kept secret. It allows anyone who has it to spend your fund and access their value.\nNever share this Private key to anyone else.',
                style: TextStyle(
                  color: AppTheme.textColor,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),
              StatefulBuilder(builder: (context, setState) {
                return InkWell(
                  onTap: () => setState(() => view = !view),
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppTheme.containerBorderColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              walletProvider.getPrivateKey(
                                  walletProvider.mnemonics ?? ''),
                              style: TextStyle(
                                fontSize: view ? 16 : 0,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 40,
                          height: double.infinity,
                          decoration: const BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.horizontal(
                                right: Radius.circular(10)),
                          ),
                          child: Icon(
                            view
                                ? Icons.remove_red_eye
                                : Icons.remove_red_eye_outlined,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
              TextButton.icon(
                style:
                    TextButton.styleFrom(foregroundColor: AppTheme.textColor),
                onPressed: () {
                  Clipboard.setData(ClipboardData(
                          text: walletProvider
                              .getPrivateKey(walletProvider.mnemonics ?? '')))
                      .then((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 100, vertical: 100),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        content: const Text(
                          "Copied to clipboard",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppTheme.textColor),
                        ),
                        backgroundColor: Colors.white60,
                      ),
                    );
                  });
                },
                label: const Text('Copy to clipboard'),
                icon: const Icon(Icons.copy),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.white30,
                  ),
                  child: const Center(
                    child: Text(
                      'Close',
                      style: TextStyle(
                        color: AppTheme.textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
