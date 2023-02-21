import 'package:flutter/material.dart';
import 'package:universal_image/universal_image.dart';
import '../../services/models/nft_model.dart';

class NFTScreen extends StatelessWidget {
  NFTScreen(this.nftData, {super.key});

  NFTModel nftData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              UniversalImage(
                nftData.mediaGateWay,
                width: MediaQuery.of(context).size.width,
                scale: 0.3,
              ),
              Transform.scale(
                scaleY: -1,
                child: UniversalImage(
                  nftData.mediaGateWay,
                  height: MediaQuery.of(context).size.height * 0.5,
                  scale: 0.3,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  // Colors.transparent,
                  // Colors.black26,
                  // Colors.black.withOpacity(0.5),
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.80),
                  Colors.black.withOpacity(0.95),
                  Colors.black.withOpacity(0.95),
                  Colors.black,
                  Colors.black
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Container(
            child: Column(
              // ignore: prefer_const_literals_to_create_immutables
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: const CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white54,
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.black87,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Hero(
                            tag: 'NFT',
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1,
                                ),
                              ),
                              child: UniversalImage(
                                nftData.mediaGateWay,
                                width: 250,
                                height: 250,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${nftData.contractName}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                fontFamily: 'Poppins'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InfoNavigationBar(nftData: nftData)
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class InfoNavigationBar extends StatefulWidget {
  const InfoNavigationBar({
    Key? key,
    required this.nftData,
  }) : super(key: key);

  final NFTModel nftData;

  @override
  State<InfoNavigationBar> createState() => _InfoNavigationBarState();
}

class _InfoNavigationBarState extends State<InfoNavigationBar> {
  // NFTModel get nftData=>widget.nftData;
  int option = 1;
  List<MaterialColor> col = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.brown
  ];

  Widget detailWidget(BuildContext context) => Container(
        height: MediaQuery.of(context).size.height * 0.5,
        child: SingleChildScrollView(
          // reverse: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              dataTile(
                context,
                col: col[0],
                name: 'Name',
                value: widget.nftData.contractName,
                iconData: Icons.title,
              ),
              dataTile(
                context,
                col: col[1],
                name: 'Symbol',
                value: widget.nftData.contractSymbol,
                iconData: Icons.receipt_long_outlined,
              ),
              dataTile(
                context,
                col: col[2],
                name: 'Contract Address',
                value: widget.nftData.address,
                iconData: Icons.account_tree_sharp,
              ),
              dataTile(
                context,
                col: col[3],
                name: 'Description',
                value: widget.nftData.description,
                iconData: Icons.line_style_outlined,
              ),
              dataTile(
                context,
                col: col[4],
                name: 'Token ID',
                value: widget.nftData.tokenId,
                iconData: Icons.settings_input_svideo_outlined,
              ),
              dataTile(
                context,
                col: col[5],
                name: 'Token Type',
                value: widget.nftData.tokenType,
                iconData: Icons.category,
              ),
              dataTile(
                context,
                col: col[6],
                name: 'Total Supply',
                value: widget.nftData.totalSupply,
                iconData: Icons.account_balance_wallet_sharp,
              ),
              dataTile(
                context,
                col: col[0],
                name: 'Deployer Address',
                value: widget.nftData.contractDeloyer,
                iconData: Icons.person,
              ),
            ],
          ),
        ),
      );

  Widget tokenIdWidget(BuildContext context) => Visibility(
        visible: widget.nftData.tokenId != "",
        child: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white12,
            border: Border.all(color: Colors.white30),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: const [
                  Icon(
                    Icons.settings_input_svideo_outlined,
                    size: 20,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'Token ID',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(widget.nftData.tokenId),
            ],
          ),
        ),
      );

  Widget dataTile(BuildContext context,
      {String? name, Color? col, String? value, IconData? iconData}) {
    return Visibility(
      visible: value != null && value.isNotEmpty,
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: col?.withOpacity(0.4) ?? Colors.white12,
          border: Border.all(
            color: col?.withOpacity(0.9) ?? Colors.white30,
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(iconData, size: 20),
                const SizedBox(width: 6),
                Text(
                  name!,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(value!),
          ],
        ),
      ),
    );
  }

  Widget attributesWidget(BuildContext context) => Container(
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: SingleChildScrollView(
          reverse: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              for (int i = 0; i < widget.nftData.attributes.length; i++)
                Card(
                  color: Colors.white10,
                  child: ListTile(
                    title: Text(
                      widget.nftData.attributes[i]['trait_type']
                          .toString()
                          .toUpperCase(),
                      style: TextStyle(color: Colors.blue.shade200),
                    ),
                    subtitle: Text(
                      widget.nftData.attributes[i]['value']
                          .toString()
                          .toUpperCase(),
                      style: TextStyle(color: Colors.red.shade200),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Row(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RotatedBox(
                  quarterTurns: 3,
                  child: TextButton(
                    style: TextButton.styleFrom(
                        foregroundColor:
                            option == 1 ? Colors.amber : Colors.grey),
                    onPressed: () {
                      if (option != 1) {
                        setState(() {
                          option = 1;
                        });
                      }
                    },
                    child: const Text('Infomation'),
                  ),
                ),
                Visibility(
                  visible: widget.nftData.attributes.isNotEmpty,
                  child: RotatedBox(
                    quarterTurns: 3,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor:
                              option == 3 ? Colors.amber : Colors.grey),
                      onPressed: () {
                        if (option != 3) {
                          setState(() {
                            option = 3;
                          });
                        }
                      },
                      child: const Text('Atrributes'),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
          Expanded(
              child: Container(
            margin: const EdgeInsets.only(bottom: 50, right: 20),
            child: [
              const Text(''),
              detailWidget(context),
              Text('data'),
              attributesWidget(context),
            ][option],
          ))
        ],
      ),
    );
  }
}
