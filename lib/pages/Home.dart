import 'package:flutter/material.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:otaku_movie/pages/tab/MovieList.dart';
import 'package:otaku_movie/pages/tab/CinemaList.dart';
import 'package:otaku_movie/pages/tab/Ticket.dart';
import 'package:otaku_movie/pages/user/User.dart';
import 'package:otaku_movie/controller/DictController.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  final int? initialTab;
  
  const Home({super.key, this.initialTab});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home> with SingleTickerProviderStateMixin {
  late int currentIndex;
  
  @override
  void initState() {
    super.initState();
    // 使用传入的 initialTab 或默认为 0
    currentIndex = widget.initialTab ?? 0;
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
      "icon": const Icon(Icons.airplane_ticket),
      "title": S.of(context).home_ticket,
      // "body": const Setting(),
      "body": const Ticket(),
    },
     {
      "icon": const Icon(Icons.theaters),
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
