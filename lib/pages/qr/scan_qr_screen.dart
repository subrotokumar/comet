import 'package:comet/pages/send_transaction/send_transaction_screen.dart';
import 'package:comet/services/functions/functions.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:page_transition/page_transition.dart';

class ScanQRScreen extends StatefulWidget {
  ScanQRScreen({super.key});

  @override
  State<ScanQRScreen> createState() => _ScanQRScreenState();
}

class _ScanQRScreenState extends State<ScanQRScreen> {
  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  MobileScannerController cameraController = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Stack(
          children: [
            Expanded(
              child: MobileScanner(
                  allowDuplicates: false,
                  controller: cameraController,
                  onDetect: (barcode, args) {
                    if (barcode.rawValue == null || false) {
                      debugPrint('Failed to scan Barcode');
                    } else {
                      final String code = barcode.rawValue ?? '';
                      int i = code.indexOf('0x');
                      var code1 = code.substring(i, i + 42);
                      if (code.contains('0x') || code.contains('.eth') || true)
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(code1),
                                  Row(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.pushReplacement(
                                            context,
                                            PageTransition(
                                              child: SendTransactionScreen(
                                                  address: code1),
                                              type: PageTransitionType.fade,
                                              duration:
                                                  Duration(milliseconds: 500),
                                            ),
                                          );
                                        },
                                        child: Text('Send Crypto'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          if (Hive.box('crypto').isEmpty) {
                                            snackBar(
                                                'No token exist!', context);
                                          }
                                          Navigator.pop(context);
                                          Navigator.pushReplacement(
                                            context,
                                            PageTransition(
                                              child: SendTransactionScreen(
                                                  address: code1),
                                              type: PageTransitionType.fade,
                                              duration:
                                                  Duration(milliseconds: 500),
                                            ),
                                          );
                                        },
                                        child: Text('Send Token'),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      // Navigator.pop(context);
                    }
                  }),
            ),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.black54,
                    ),
                  ),
                  Container(
                    height: 400,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Colors.black54, width: 60),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      color: Colors.black54,
                      child: const Center(
                        child: Text(
                          'Send crypto by scaning QR',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            CustomAppBar(cameraController: cameraController),
          ],
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    Key? key,
    required this.cameraController,
  }) : super(key: key);

  final MobileScannerController cameraController;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: const Text('Scan QR'),
      centerTitle: true,
      actions: [
        IconButton(
          color: Colors.white,
          icon: ValueListenableBuilder(
            valueListenable: cameraController.torchState,
            builder: (context, state, child) {
              switch (state) {
                case TorchState.off:
                  return const Icon(Icons.flash_off, color: Colors.grey);
                case TorchState.on:
                  return const Icon(Icons.flash_on, color: Colors.yellow);
              }
            },
          ),
          iconSize: 20.0,
          onPressed: () => cameraController.toggleTorch(),
        ),
      ],
    );
  }
}
