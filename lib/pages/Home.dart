import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

class _HomePageState extends State<Home> with TickerProviderStateMixin {
  late int currentIndex;
  late PageController _pageController;
  late List<Widget> _pages;
  
  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialTab ?? 0;
    _pageController = PageController(initialPage: currentIndex);
    
    // 初始化页面列表
    _pages = [
      const MovieList(),
      const Ticket(),
      const CinemaList(),
      const UserInfo(),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DictController dictController = Get.find();
    Get.put(dictController);

    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Container(
            height: 120.h,
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(0, Icons.movie_outlined, Icons.movie, S.of(context).home_home),
                _buildNavItem(1, Icons.confirmation_number_outlined, Icons.confirmation_number, S.of(context).home_ticket),
                _buildNavItem(2, Icons.theaters_outlined, Icons.theaters, S.of(context).home_cinema),
                _buildNavItem(3, Icons.person_outline, Icons.person, S.of(context).home_me),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData unselectedIcon, IconData selectedIcon, String label) {
    final isSelected = currentIndex == index;
    
    return GestureDetector(
      onTap: () => _changeTab(index),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF1989FA).withOpacity(0.1) : Colors.transparent,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                isSelected ? selectedIcon : unselectedIcon,
                size: 40.sp,
                color: isSelected ? const Color(0xFF1989FA) : Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 22.sp,
                color: isSelected ? const Color(0xFF1989FA) : Colors.grey.shade600,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _changeTab(int index) {
    setState(() {
      currentIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  void _onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }
}
