import 'package:flutter/material.dart';
import 'package:quran_tutorial/views/my_home_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(392.72727272727275, 800.7272727272727),
        builder: (context, child) =>  MaterialApp(
      title: 'Flutter Demo',
  
      home: MyHomePage(),
    ));
  }
}
