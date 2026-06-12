import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:otaku_movie/components/CustomAppBar.dart';
import 'package:otaku_movie/generated/l10n.dart';
import 'package:otaku_movie/utils/index.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String version = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      version = info.version;
    });
  }

  Widget _buildDataDisclaimer(BuildContext context) {
    const email = 'support@otaku-movie.com';
    final text = S.of(context).about_dataDisclaimer;
    final emailIndex = text.indexOf(email);
    final baseStyle = TextStyle(
      fontSize: 26.sp,
      color: Colors.grey.shade700,
      height: 1.7,
    );

    if (emailIndex < 0) {
      return Text(
        text,
        style: baseStyle,
        textAlign: TextAlign.left,
      );
    }

    return RichText(
      textAlign: TextAlign.left,
      text: TextSpan(
        style: baseStyle,
        children: [
          TextSpan(text: text.substring(0, emailIndex)),
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: GestureDetector(
              onTap: () => launchURL('mailto:$email'),
              child: Text(
                email,
                style: baseStyle.copyWith(
                  color: const Color(0xFF1989FA),
                  decoration: TextDecoration.underline,
                  decorationColor: const Color(0xFF1989FA).withValues(alpha: 0.35),
                  decorationThickness: 1.0,
                ),
              ),
            ),
          ),
          TextSpan(text: text.substring(emailIndex + email.length)),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: CustomAppBar(
        title: S.of(context).about_title,
        backgroundColor: const Color(0xFF1989FA),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
        child: Column(
          children: [
            // 头部区域
            Container(
              height: 280.h,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1989FA),
                    Color(0xFF667EEA),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // 背景装饰
                  Positioned(
                    top: -30.h,
                    right: -30.w,
                    child: Container(
                      width: 120.w,
                      height: 120.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -20.h,
                    left: -20.w,
                    child: Container(
                      width: 80.w,
                      height: 80.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                  ),
                  // 内容
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 应用图标（品牌 logo）
                        Container(
                          width: 110.w,
                          height: 110.w,
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(28.r),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.6),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.12),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Image.asset(
                            'assets/image/logo.png',
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stack) => Icon(
                              Icons.movie_rounded,
                              size: 56.sp,
                              color: const Color(0xFF1989FA),
                            ),
                          ),
                        ),
                        SizedBox(height: 18.h),
                        // 应用名称
                        Text(
                          'シネコ',
                          style: TextStyle(
                            fontSize: 44.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.5,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        // 版本信息
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            '${S.of(context).about_version}: $version',
                            style: TextStyle(
                              fontSize: 22.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // 主要内容
            Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                children: [
                  SizedBox(height: 20.h),

                  // 第三方内容版权声明：电影名称/海报/剧照等版权归原权利人所有，
                  // 本应用不主张版权，仅作信息展示与购票用途。
                  Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: _buildDataDisclaimer(context),
                  ),

                  SizedBox(height: 16.h),

                  // 数据来源
                  Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Text(
                      S.of(context).about_dataSource,
                      style: TextStyle(
                        fontSize: 26.sp,
                        color: Colors.grey.shade700,
                        height: 1.7,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // 非官方声明
                  Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Text(
                      S.of(context).about_nonOfficial,
                      style: TextStyle(
                        fontSize: 26.sp,
                        color: Colors.grey.shade700,
                        height: 1.7,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),

                  SizedBox(height: 12.h),
                ],
              ),
            ),
          ],
        ),
            ),
          ),
          // 版权信息（固定在页面最底部）
          Padding(
            padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 24.h),
            child: Text(
              S.of(context).about_copyright,
              style: TextStyle(
                fontSize: 22.sp,
                color: Colors.grey.shade500,
                height: 1.4,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCompactFeatureCard({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Container(
      height: 60.h,
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 28.w,
            height: 28.w,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(
              icon,
              size: 14.sp,
              color: color,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF323233),
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

