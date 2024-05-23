import 'dart:async';

import 'package:easy_container/easy_container.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quran/quran.dart';
import 'package:quran_tutorial/globalhelpers/constants.dart';
import 'package:quran_tutorial/widgets/basmallah.dart';
import 'package:quran_tutorial/widgets/header_widget.dart';
import 'package:wakelock/wakelock.dart';

class QuranViewPage extends StatefulWidget {
  int pageNumber;
  var jsonData;
  var shouldHighlightText;
  var highlightVerse;
  QuranViewPage({
    Key? key,
    required this.pageNumber,
    required this.jsonData,
    required this.shouldHighlightText,
    required this.highlightVerse,
  }) : super(key: key);

  @override
  State<QuranViewPage> createState() => _QuranViewPageState();
}

class _QuranViewPageState extends State<QuranViewPage> {
  var highlightVerse;
  var shouldHighlightText;
  List<GlobalKey> richTextKeys = List.generate(
    604, // Replace with the number of pages in your PageView
    (_) => GlobalKey(),
  );
  setIndex() {
    setState(() {
      index = widget.pageNumber;
    });
  }

  int index = 0;
  late PageController _pageController;
  late Timer timer;
  String selectedSpan = "";

  highlightVerseFunction() {
    setState(() {
      shouldHighlightText = widget.shouldHighlightText;
    });
    if (widget.shouldHighlightText) {
      setState(() {
        highlightVerse = widget.highlightVerse;
      });

      Timer.periodic(const Duration(milliseconds: 400), (timer) {
        if (mounted) {
          setState(() {
            shouldHighlightText = false;
          });
        }
        Timer(const Duration(milliseconds: 200), () {
          if (mounted) {
            setState(() {
              shouldHighlightText = true;
            });
          }
          if (timer.tick == 4) {
            if (mounted) {
              setState(() {
                highlightVerse = "";

                shouldHighlightText = false;
              });
            }
            timer.cancel();
          }
        });
      });
    }
  }

  @override
  void initState() {
    setIndex();
    _pageController = PageController(initialPage: index);
    highlightVerseFunction();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    Wakelock.enable();
// TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // timer.cancel();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    Wakelock.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
        body: PageView.builder(
      reverse: true,
      scrollDirection: Axis.horizontal,
      onPageChanged: (a) {
        setState(() {
          selectedSpan = "";
        });
        index = a;
        // print(index)  ;
      },
      controller: _pageController,
      // onPageChanged: _onPageChanged,
      itemCount: totalPagesCount + 1 /* specify the total number of pages */,
      itemBuilder: (context, index) {
        bool isEvenPage = index.isEven;

        if (index == 0) {
          return Container(
            color: const Color(0xffFFFCE7),
            child: Image.asset(
              "assets/images/jpg",
              fit: BoxFit.fill,
            ),
          );
        }

        return Container(
          decoration: const BoxDecoration(
            color: quranPagesColor,
          ),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(right: 12.0, left: 12),
                child: SingleChildScrollView(
                  // physics: const ClampingScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(
                        width: screenSize.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: (screenSize.width * .27),
                              child: Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: const Icon(
                                        Icons.arrow_back_ios,
                                        size: 24,
                                      )),
                                  Text(
                                      widget.jsonData[getPageData(index)[0]
                                              ["surah"] -
                                          1]["name"],
                                      style: const TextStyle(
                                          fontFamily: "Taha", fontSize: 14)),
                                ],
                              ),
                            ),
                            EasyContainer(
                              borderRadius: 12,
                              color: Colors.orange.withOpacity(.5),
                              showBorder: true,
                              height: 20,
                              width: 120,
                              padding: 0,
                              margin: 0,
                              child: Center(
                                child: Text(
                                  "${"page"} $index ",
                                  style: const TextStyle(
                                    fontFamily: 'aldahabi',
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: (screenSize.width * .27),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.settings,
                                        size: 24,
                                      ))
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      if ((index == 1 || index == 2))
                        SizedBox(
                          height: (screenSize.height * .15),
                        ),
                      const SizedBox(
                        height: 30,
                      ),
                      Directionality(
                          textDirection: TextDirection.rtl,
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: RichText(
                                key: richTextKeys[index - 1],
                                textDirection: TextDirection.rtl,
                                textAlign:
                                 TextAlign.center,
                                softWrap: true,
                                locale: const Locale("ar"),
                                text: TextSpan(
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 26,
                                  ),
                                  children: getPageData(index).expand((e) {
                                    List<InlineSpan> spans = [];
                                    for (var i = e["start"];
                                        i <= e["end"];
                                        i++) {
                                      // Header
                                      if (i == 1) {
                                        spans.add(WidgetSpan(
                                          child: HeaderWidget(
                                              e: e, jsonData: widget.jsonData),
                                        ));
                                        if (index != 187 && index != 1) {
                                          spans.add(WidgetSpan(
                                            child: Basmallah(index: 1),
                                          ));
                                        }
                                        if (index == 187) {
                                          spans.add(WidgetSpan(
                                            child: Container(
                                              height: 10,
                                            ),
                                          ));
                                        }
                                      }

                                      // Verses
                                      spans.add(TextSpan(
                                        recognizer: LongPressGestureRecognizer()
                                          ..onLongPress = () {
                                            print("longpressed");
                                          }
                                          ..onLongPressDown = (details) {
                                            setState(() {
                                              selectedSpan = " ${e["surah"]}$i";
                                            });
                                          }
                                          ..onLongPressUp = () {
                                            setState(() {
                                              selectedSpan = "";
                                            });
                                            print("finished long press");
                                          }
                                          ..onLongPressCancel =
                                              () => setState(() {
                                                    selectedSpan = "";
                                                  }),
                                        text: i == e["start"]
                                            ? "${getVerseQCF(e["surah"], i).replaceAll(" ", "").substring(0, 1)}\u200A${getVerseQCF(e["surah"], i).replaceAll(" ", "").substring(1)}"
                                            : getVerseQCF(e["surah"], i)
                                                .replaceAll(' ', ''),
                                        //  i == e["start"]
                                        // ? "${getVerseQCF(e["surah"], i).replaceAll(" ", "").substring(0, 1)}\u200A${getVerseQCF(e["surah"], i).replaceAll(" ", "").substring(1).substring(0,  getVerseQCF(e["surah"], i).replaceAll(" ", "").substring(1).length - 1)}"
                                        // :
                                        // getVerseQCF(e["surah"], i).replaceAll(' ', '').substring(0,  getVerseQCF(e["surah"], i).replaceAll(' ', '').length - 1),
                                        style: TextStyle(
                                          color: Colors.black,
                                          height: (index == 1 || index == 2)
                                              ? 2
                                              : 1.95,
                                          letterSpacing: 0,
                                          wordSpacing: 0,
                                          fontFamily:
                                              "QCF_P${index.toString().padLeft(3, "0")}",
                                          fontSize: index == 1 || index == 2
                                              ? 28
                                              : index == 145 || index == 201
                                                  ? index == 532 || index == 533
                                                      ? 24.5
                                                      : 24.4
                                                  : 24.9,
                                          backgroundColor: shouldHighlightText
                                              ? getVerse(e["surah"], i) ==
                                                      widget.highlightVerse
                                                  ? Colors.orange
                                                      .withOpacity(.25)
                                                  : selectedSpan ==
                                                          " ${e["surah"]}$i"
                                                      ? Colors.orange
                                                          .withOpacity(.25)
                                                      : Colors.transparent
                                              : selectedSpan ==
                                                      " ${e["surah"]}$i"
                                                  ? Colors.orange
                                                      .withOpacity(.25)
                                                  : Colors.transparent,
                                        ),
                                      ));
                                    }
                                    return spans;
                                  }).toList(),
                                ),
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ); /* Your page content */
      },
    ));
  }
}
