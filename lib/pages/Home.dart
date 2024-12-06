import 'package:flutter/material.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:otaku_movie/pages/tab/MovieList.dart';
import 'package:otaku_movie/pages/tab/CinemaList.dart';
import 'package:otaku_movie/pages/user/User.dart';
import 'package:otaku_movie/pages/setting.dart';
import 'package:otaku_movie/controller/DictController.dart';
import '../controller/LanguageController.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home> with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final DictController dictController = Get.find();

    Get.put(dictController);

    List<Map<String, dynamic>> tab = [
    {
      "icon": const Icon(Icons.movie),
      "title": S.of(context).home_home,
      // "body": const Setting(),
      "body": const MovieList(),
    },
    {
      "icon": const Icon(Icons.theaters_sharp),
      "title": S.of(context).home_cinema,
      // "body": const Setting(),
      "body": const CinemaList(),
    },
    {
      "icon": const Icon(Icons.account_circle),
      "title": S.of(context).home_me,
      "body": const UserInfo(),
    }
  ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: tab[currentIndex]['body'],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        unselectedIconTheme: const IconThemeData(),
        items: tab.map<BottomNavigationBarItem>((tabItem) {
          return BottomNavigationBarItem(
            icon: tabItem['icon'],
            label: tabItem['title'], // 使用 label 替代 title
          );
        }).toList(),
        selectedFontSize: 12.0,
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        selectedItemColor: Colors.blue,
        onTap: _changeTab,
      ),
    );
  }

  void _changeTab(int index) {
    setState(() {
      currentIndex = index;
    });
  }
}
