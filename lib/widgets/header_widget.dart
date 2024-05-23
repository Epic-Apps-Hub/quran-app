import 'package:flutter/material.dart';

import 'package:quran/quran.dart';

class HeaderWidget extends StatelessWidget {
  var e;
  var jsonData;

  HeaderWidget(
      {super.key, required this.e, required this.jsonData, });

  @override
  Widget build(BuildContext context) {
 
    return SizedBox(
      height: 50,
      child: Stack(
        children: [
          Center(
            child: Image.asset(
              "assets/images/888-02.png",
              width: MediaQuery.of(context).size.width,
              height: 50,
    
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.7, vertical: 7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  textAlign: TextAlign.center,
                  "اياتها\n${getVerseCount(e["surah"])}",
                  style: const TextStyle(
        
                      fontSize: 5,
                      fontFamily: "UthmanicHafs13"),
                ),
                Center(
                    child: Text(
                  textAlign: TextAlign.center,
                  getSurahNameArabic(e["surah"]),
                  style: const TextStyle(
                    fontFamily: "uthmanic",
                    fontSize: 22,
             
                  ),
                )),
                Text(
                  "ترتيبها\n${e["surah"]}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
             
                      fontSize: 5,
                      fontFamily: "UthmanicHafs13"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
