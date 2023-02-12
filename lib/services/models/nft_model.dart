// ignore_for_file: public_member_api_docs, sort_constructors_first

class NFTModel {
  late final String address;
  late final String contractDeloyer;
  late final String contractName;
  late final String title;
  late final String description;
  late final String totalSupply;
  // late final String tokenURL;
  late final String tokenId;
  late final String tokenType;
  // late final String tokenUriRaw;
  // late final String tokenUriGateway;
  // late final String mediaRaw;
  late final String mediaGateWay;
  late final String mediaFormat;
  late final List attributes;
  late final String contractSymbol;

  NFTModel({
    required this.address,
    required this.title,
    required this.description,
    // required this.tokenURL,
    required this.tokenId,
    required this.tokenType,
    // required this.tokenUriRaw,
    // required this.tokenUriGateway,
    // required this.mediaRaw,
    required this.mediaGateWay,
    // required this.mediaFormat,
    required this.attributes,
    required this.contractName,
    required this.contractDeloyer,
    required this.totalSupply,
    required this.contractSymbol,
  });

  factory NFTModel.fromMap(Map<String, dynamic> map) {
    return NFTModel(
      contractName: map['contractMetadata']['name'] ?? '',
      address: map['contract']!["address"] ?? "",
      title: map['metadata']['contractName'] ?? map['title'] ?? "",
      description: map['metadata']['description'] ?? map['description'] ?? '',
      // tokenURL: "",
      tokenId: map['id']['tokenId'] ?? "",
      tokenType: map['contractMetadata']['tokenType'] ??
          map['id']!['tokenMetadata']['tokenType'] ??
          '',
      // tokenUriRaw: map['tokenUri']!['raw'] ?? '',
      // tokenUriGateway: map!['tokenUri']!['gateway']! ?? '',
      // mediaRaw: '',
      mediaGateWay: map['contractMetadata']['openSea']['imageUrl'] ??
          map['media'][0]['gateway']! ??
          map['metadata']['image'] ??
          map['tokenUri']['gateway'] ??
          '',
      // mediaFormat: map['media']!['format'] ?? '',
      attributes: map['metadata']!['attributes'] ?? [],
      contractDeloyer: map['contractMetadata']['contractDeployer'] ?? '',
      totalSupply: map['contractMetadata']['totalSupply'] ?? '',
      contractSymbol: map['contractMetadata']['symbol'] ?? '',
    );
  }
}
