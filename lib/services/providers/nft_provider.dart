import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:comet/services/models/nft_model.dart';
import 'package:comet/services/providers/walletprovider.dart';

class NFTProvider with ChangeNotifier {
  bool isLoading = false;
  List<NFTModel> _list = [];
  List<NFTModel> get list => _list;

  Future<void> fetch(WalletProvider walletProvider) async {
    isLoading = true;
    var response = await http.get(Uri.parse(
        '${walletProvider.getNetwork.rpc}/getNFTs/?owner=${walletProvider.getPublicAddress.hex}'));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['ownedNfts'] as List;
      _list = [];
      for (var element in data) {
        var i = NFTModel.fromMap(element as Map<String, dynamic>);
        _list.add(i);
      }
    }
    isLoading = false;
    notifyListeners();
  }
}
