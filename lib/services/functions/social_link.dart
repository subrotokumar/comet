import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchInBrowser(String link) async {
  Uri url = Uri.parse(link);
  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) {
    throw 'Could not launch $url';
  }
}

Widget GitHub({required String username}) {
  return InkWell(
    borderRadius: BorderRadius.circular(20),
    onTap: () => launchInBrowser('https://www.github.com/$username'),
    child: Container(
      margin: EdgeInsets.all(5),
      width: 100,
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: Colors.black,
        ),
        color: Colors.black87,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/icons/ic_github.png'),
            Text(
              'GitHub   ',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget Twitter({required String username}) {
  return InkWell(
    borderRadius: BorderRadius.circular(20),
    onTap: () => launchInBrowser("https://www.twitter.com/$username"),
    child: Container(
      margin: EdgeInsets.all(5),
      width: 100,
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: Colors.blueAccent,
        ),
        color: Colors.blue,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              child: Image.asset('assets/icons/ic_twitter.png'),
              radius: 15,
              backgroundColor: Colors.white,
            ),
            Text(
              '   Twitter  ',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    ),
  );
}
