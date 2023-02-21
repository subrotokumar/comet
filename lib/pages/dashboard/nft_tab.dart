import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:universal_image/universal_image.dart';

import 'package:comet/pages/dashboard/nft.screen.dart';
import 'package:comet/services/providers/nft_provider.dart';

class NftTab extends StatelessWidget {
  const NftTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NFTProvider>(
      builder: (context, nftProvider, child) {
        if (nftProvider.isLoading) {
          return Padding(
            padding: EdgeInsets.all(10),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                return Shimmer.fromColors(
                  baseColor: Colors.white12,
                  highlightColor: Colors.white60,
                  direction: ShimmerDirection.ltr,
                  child: Card(
                    color: Colors.white12,
                  ),
                );
              },
              itemCount: 9,
            ),
          );
        } else {
          if (nftProvider.list.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LottieBuilder.asset(
                  'assets/lotties/nft-artwork.json',
                  width: 200,
                ),
                SizedBox(height: 10),
                Text(
                  'No NFT Found!',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            );
          }
          return Padding(
            padding: EdgeInsets.all(10),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                return Card(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return NFTScreen(nftProvider.list[index]);
                          },
                        ),
                      ),
                      child: Hero(
                        tag: 'NFT',
                        child: UniversalImage(
                          nftProvider.list[index].mediaGateWay,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                );
              },
              itemCount: nftProvider.list.length,
            ),
          );
        }
      },
    );
  }
}
