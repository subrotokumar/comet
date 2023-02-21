import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:comet/services/providers/walletprovider.dart';

Future<List> getCurrentPrice(WalletProvider walletProvider,
    {String cur = 'usd'}) async {
  String chainId = walletProvider.getNetwork.chainId;
  String bal = await walletProvider.getBalance();
  String id = chainId == '1' || chainId == '5' ? 'ethereum' : 'matic-network';
  var response = await http.get(Uri.parse(
      'https://api.coingecko.com/api/v3/simple/price?ids=$id&vs_currencies=$cur'));
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    var price = data[id]['usd'].toString();
    return [bal, price];
  } else {
    return [bal, '1'];
  }
}

Future<List<double>> getMarketChart(WalletProvider walletProvider,
    {String cur = 'usd'}) async {
  List<double> priceList = [];
  String chainId = walletProvider.getNetwork.chainId;
  String id = chainId == '1' || chainId == '5' ? 'ethereum' : 'matic-network';
  var response = await http.get(Uri.parse(
      'https://api.coingecko.com/api/v3/coins/$id/market_chart?vs_currency=$cur&days=1&interval=hourly'));
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    var prices = data['prices'] as List;
    for (var i in prices) {
      priceList.add(double.parse(i[1].toString()));
    }
    return priceList;
  } else {
    return priceList;
  }
}
