import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:comet/services/providers/walletprovider.dart';
import 'package:comet/utils/credential.dart';

import '../models/transaction_model.dart';

class TransactionProvider with ChangeNotifier {
  // variable
  bool _isLoading = false;
  List<TransactionModel> _transactionsList = [];

  // getter
  bool get isLoading => _isLoading;
  List<TransactionModel> get transactionsList => _transactionsList;

  get methodId => null;

  //methods
  Future<void> fetch(WalletProvider walletProvider) async {
    _isLoading = true;
    notifyListeners();
    String chainId = walletProvider.getNetwork.chainId;
    Uri endpoint = Uri.https(
      walletProvider.getNetwork.etherscanUrl,
      '/api',
      {
        'module': 'account',
        'action': 'txlist',
        'address': walletProvider.getPublicAddress.hex,
        'startblock': '0',
        'endblock': '99999999',
        'page': '1',
        'offset': '0',
        'sort': 'desc',
        'apiKey':
            chainId == '1' || chainId == '5' ? etherscanApi : polygonscanApi,
      },
    );
    var response = await http.get(endpoint);
    // print(response.body);
    if (response.statusCode == 200) {
      _transactionsList = [];
      for (var item in jsonDecode(response.body)['result']) {
        _transactionsList.add(TransactionModel.fromMap(item));
      }
    } else {
      if (kDebugMode) {
        // print(response.reasonPhrase);
      }
    }
    _isLoading = false;
    notifyListeners();
  }
}
