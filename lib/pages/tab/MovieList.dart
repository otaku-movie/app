import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../components/CustomAppBar.dart';
import '../../generated/l10n.dart';
import 'NowShowing.dart';
import 'comingSoon.dart';

class MovieList extends StatefulWidget {
  const MovieList({super.key});

  @override
  State<MovieList> createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F8FA),
        appBar: CustomAppBar(
          title: GestureDetector(
            onTap: () {
              context.pushNamed('search');
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 24.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.of(context).search_placeholder,
                    style: TextStyle(
                      fontSize: 28.sp,
                      color: const Color(0xFF969799),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1989FA).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.search_outlined,
                      color: const Color(0xFF1989FA),
                      size: 20.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
          backgroundColor: const Color(0xFF1989FA),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(60.h),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
              child: TabBar(
                controller: _tabController,
                tabs: [
                  AnimatedBuilder(
                    animation: _tabController,
                    builder: (context, child) {
                      return _buildTab(
                        context,
                        S.of(context).movieList_tabBar_currentlyShowing,
                        _tabController.index == 0,
                      );
                    },
                  ),
                  AnimatedBuilder(
                    animation: _tabController,
                    builder: (context, child) {
                      return _buildTab(
                        context,
                        S.of(context).movieList_tabBar_comingSoon,
                        _tabController.index == 1,
                      );
                    },
                  ),
                ],
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 4.0,
                  ),
                  insets: EdgeInsets.symmetric(horizontal: 10.w),
                ),
                labelColor: Colors.transparent,
                unselectedLabelColor: Colors.transparent,
                labelStyle: const TextStyle(
                  fontSize: 0,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 0,
                ),
                dividerColor: Colors.transparent,
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                splashFactory: NoSplash.splashFactory
              ),
            ),
          ),
        ),
        body: Container(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: TabBarView(
              controller: _tabController,
              children: const <Widget>[
                NowShowing(),
                ComingSoon(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTab(BuildContext context, String text, bool isSelected) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
          fontSize: 32.sp,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          letterSpacing: 0.5,
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}