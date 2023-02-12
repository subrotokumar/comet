class Network {
  late final int id;
  late final String name;
  late final String chainId;
  late final bool mainnet;
  late final String currency;
  late final String logo;
  late final String rpc;
  late final String blockExplorer;
  late final String etherscanUrl;
  Network({
    required this.id,
    required this.name,
    required this.chainId,
    required this.mainnet,
    required this.currency,
    required this.logo,
    required this.rpc,
    required this.blockExplorer,
    required this.etherscanUrl,
  });
}
