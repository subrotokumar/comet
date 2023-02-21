import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';

import 'package:comet/services/providers/walletprovider.dart';

import '../../../utils/theme.dart';

void snackBar(String message, BuildContext context, {double vertical = 200}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      margin: EdgeInsets.symmetric(horizontal: 100, vertical: vertical),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(color: AppTheme.textColor),
      ),
      backgroundColor: Colors.white60,
    ),
  );
}

Future<bool> passwordAuth(BuildContext context) async {
  Widget NumberButton(int n) {
    return CircleAvatar(
      radius: 30,
      backgroundColor: Colors.blueGrey.withOpacity(0.5),
      child: Center(
        child: Text(
          '$n',
          style: const TextStyle(
            color: AppTheme.textColor,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  String n = '';

  bool flag = false;

  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          void addN(String nn) {
            if (n.length < 6) {
              setState(() => n += nn);
            }
          }

          void clear() => setState(() => {n = ''});
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Text(
                'Enter Password',
                style: GoogleFonts.poppins(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 1; i <= 6; i++)
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Center(
                          child: Text(
                            n.toString().length >= i ? '*' : ' ',
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                        onTap: () => addN('1'), child: NumberButton(1)),
                    GestureDetector(
                        onTap: () => addN('2'), child: NumberButton(2)),
                    GestureDetector(
                        onTap: () => addN('3'), child: NumberButton(3)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                        onTap: () => addN('4'), child: NumberButton(4)),
                    GestureDetector(
                        onTap: () => addN('5'), child: NumberButton(5)),
                    GestureDetector(
                        onTap: () => addN('6'), child: NumberButton(6)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                        onTap: () => addN('7'), child: NumberButton(7)),
                    GestureDetector(
                        onTap: () => addN('8'), child: NumberButton(8)),
                    GestureDetector(
                        onTap: () => addN('9'), child: NumberButton(9)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () => clear(),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.redAccent.withOpacity(0.5),
                        child: const Center(
                          child: Icon(Icons.clear, color: Colors.white),
                        ),
                      ),
                    ),
                    GestureDetector(
                        onTap: () => addN('0'), child: NumberButton(0)),
                    GestureDetector(
                      onTap: () async {
                        if (n.length < 6) return;
                        if (await context
                            .read<WalletProvider>()
                            .VerifyUser(n)) {
                          flag = true;
                        } else {
                          snackBar('Wrong Password', context, vertical: 100);
                        }
                        Navigator.pop(context);
                      },
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: n.length < 6
                            ? Colors.blueGrey.withOpacity(0.2)
                            : Colors.blue,
                        foregroundColor:
                            Colors.white.withOpacity(n.length < 6 ? 0.2 : 1),
                        child: Icon(
                          Icons.arrow_forward,
                          size: 40,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
            ],
          );
        },
      );
    },
  );
  return flag;
}

String shortAddress(String address, {bool isLong = false}) {
  int size = isLong ? 10 : 5;
  return '${address.substring(0, size + 1)}....${address.substring(address.length - size + 1)}';
}

Future<DeployedContract> loadContract(
    String contractAddress, String contractName) async {
  String abi = await rootBundle.loadString('assets/abi/IERC20.json');
  final contract = DeployedContract(
    ContractAbi.fromJson(abi, 'TOKEN'),
    EthereumAddress.fromHex(contractAddress),
  );
  print('load contracts successful');
  return contract;
}

Future<List<dynamic>> readFunction(
    {required String contractName,
    required String contractAddress,
    required String functionName,
    required List<dynamic> args,
    required Web3Client web3client}) async {
  String abi = await rootBundle.loadString('assets/abi/IERC20.json');
  final contract = DeployedContract(
    ContractAbi.fromJson(abi, contractName),
    EthereumAddress.fromHex(contractAddress, enforceEip55: true),
  );
  print(contract.toString());
  final ethFunction = contract.function(functionName);
  final result = await web3client.call(
      contract: contract, function: ethFunction, params: args);
  print(result.toString() + " " + contractName);

  return result;
}

Future<String> writeFunction({
  required String functionName,
  required List<dynamic> args,
  required String contractAddress,
  required String contractName,
  required EthPrivateKey privateKey,
  required Web3Client web3client,
  int maxGas = 100000,
}) async {
  DeployedContract contract = await loadContract(contractAddress, contractName);
  final ethFunction = contract.function(functionName);
  Transaction tranx = await Transaction.callContract(
    contract: contract,
    function: ethFunction,
    parameters: args,
    maxGas: maxGas,
  );
  final result =
      await web3client.sendTransaction(privateKey, tranx, chainId: 1);
  print(result);
  return result;
}
