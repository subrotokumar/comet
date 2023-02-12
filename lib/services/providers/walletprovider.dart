import 'package:bip32/bip32.dart' as bip32;
import 'package:bip39/bip39.dart' as bip39;
import 'package:comet/services/models/network.dart';
import 'package:comet/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:hex/hex.dart';
import 'package:http/http.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart';

class WalletProvider with ChangeNotifier {
  String? _mnemonics;
  String? _privateKey;
  int _network = 0;
  Network get getNetwork => network[_network];
  SharedPreferences? pref;

  Future<String?> privateKey1() async => await storage.read(key: 'key');

  // Setter
  bool setMnemonics(String newMnemonics) {
    if (bip39.validateMnemonic(newMnemonics)) {
      _mnemonics = newMnemonics;
      _privateKey = getPrivateKey(newMnemonics);
      return true;
    }
    return false;
  }

  // Package
  late FlutterSecureStorage storage;
  late Client client;
  late Web3Client web3client;

  void saveMnemonics() => storage.write(key: 'mnemonics', value: mnemonics);

  // void getPrivateKey() => _mnemonics = generateMnemonic;

  // Initialize
  Future<void> initialize() async {
    pref = await SharedPreferences.getInstance();
    client = Client();
    _network = pref?.getInt('network') ?? 1;
    web3client = Web3Client(getNetwork.rpc, client);

    storage = const FlutterSecureStorage();
  }

  Future<void> changeNetwork(int i) async {
    _network = i;
    web3client = Web3Client(getNetwork.rpc, client);
    await pref?.setInt('network', _network);
    notifyListeners();
  }

  Future<void> getLogged() async {
    String new_mnemonics = await storage.read(key: 'MnemonicsCredential') ?? '';
    setMnemonics(new_mnemonics);
  }

  Future<void> getLoggedFirstTime(String recovery) async {
    setMnemonics(recovery);
    await pref!.setBool('isLogged', true);
    await storage.write(key: 'MnemonicsCredential', value: _mnemonics);
  }

  Future<bool> getLoggedByPassword(String passcode) async {
    String pass = await storage.read(key: 'loginPasscode') ?? '';
    if (pass == passcode) {
      await getLogged();
      return true;
    }
    return false;
  }

  Future<void> SignOut() async {
    await storage.deleteAll();
    await pref!.clear();
  }

  void savePrivateKey() => storage.write(key: 'privateKey', value: mnemonics);

  String get generateMnemonic {
    _mnemonics = bip39.generateMnemonic();
    return _mnemonics!;
  }

  Future<bool> VerifyUser(String password) async {
    String pass = await storage.read(key: 'loginPasscode') ?? '';
    if (password == pass) {
      return true;
    }
    return false;
  }

  String getPrivateKey(String mnemonic) {
    final seed = bip39.mnemonicToSeed(mnemonic);
    final root = bip32.BIP32.fromSeed(seed);
    final child = root.derivePath("m/44'/60'/0'/0/0");
    final privateKey = HEX.encode(child.privateKey!);
    return privateKey;
  }

  EthereumAddress get getPublicAddress {
    final private = EthPrivateKey.fromHex(_privateKey!);
    final address = private.address;
    return address;
  }

  Future<String> getBalance() async {
    String balance =
        (await web3client.getBalance(getPublicAddress)).getInWei.toString();
    return balance;
  }

  // getter
  String? get mnemonics => _mnemonics;

  EthPrivateKey get privateKey => EthPrivateKey.fromHex(_privateKey!);
}
