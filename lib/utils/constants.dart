import 'package:comet/services/models/network.dart';
import 'package:comet/utils/credential.dart';

List network = [
  Network(
    id: 1,
    name: 'Etheruem',
    chainId: '1',
    mainnet: true,
    currency: 'ETH',
    logo: 'assets/images/ethereum.png',
    rpc: mainnetRPC,
    blockExplorer: 'https://etherscan.io',
    etherscanUrl: 'api.etherscan.io',
  ),
  Network(
    id: 2,
    name: 'Polygon',
    chainId: '137',
    mainnet: true,
    currency: 'MATIC',
    logo: 'assets/images/polygon.png',
    rpc: polygonRRC,
    blockExplorer: 'https://polygonscan.com',
    etherscanUrl: 'api.polygonscan.com',
  ),
  Network(
    id: 3,
    name: 'Mumbai',
    chainId: '80001',
    mainnet: false,
    currency: 'MATIC',
    logo: 'assets/images/polygon.png',
    rpc: mumbaiRPC,
    blockExplorer: 'https://mumbai.polygonscan.com',
    etherscanUrl: 'api-testnet.polygonscan.com',
  ),
  Network(
    id: 4,
    name: 'Goerli',
    chainId: '5',
    mainnet: false,
    currency: 'GoerliETH',
    logo: 'assets/images/ethereum.png',
    rpc: goerliRPC,
    blockExplorer: 'https://goerli.etherscan.io',
    etherscanUrl: 'api-goerli.etherscan.io',
  ),
];
