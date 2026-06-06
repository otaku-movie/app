import 'dart:async';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:otaku_movie/config/config.dart';
import 'package:otaku_movie/controller/LanguageController.dart';
import 'package:otaku_movie/log/index.dart';
import 'package:otaku_movie/service/splash_config_service.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// 启动页（splash）。
///
/// 设计目标：
/// - **后台可配置**：图片、标题、副标题、时长都从 `/app/splash/current` 拉取，
///   运营可以在不发版的前提下换档期主视觉。
/// - **快**：首次进入读本地缓存，0 等待；后台静默刷新，下次启动生效。
/// - **不偷跑**：最短展示时长（默认 1.5s）保证品牌曝光，
///   到达最长时长（默认 3.5s）后自动跳过，避免后端慢时卡住用户。
/// - **可追溯**：右下角显示版本号 + 环境标识，方便测试 / 反馈定位。
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  /// 当前展示用的配置：先用本地缓存初始化，再被后台刷新覆盖。
  SplashConfig _config = SplashConfig.fallback;
  String _appVersion = '';
  String _statusText = '';
  Timer? _maxTimer;
  bool _navigated = false;
  DateTime _shownAt = DateTime.now();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _scaleAnimation = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _bootstrap();
  }

  Future<void> _bootstrap() async {
    _shownAt = DateTime.now();
    _setStatus('init');

    // 1. 立即用本地缓存渲染（首屏 0 延迟）
    final cached = await SplashConfigService.instance.loadCached();
    if (!mounted) return;
    setState(() => _config = cached);

    // 2. 启动「最长展示」兜底定时器：哪怕后台拉不到，也保证不会卡住。
    _maxTimer = Timer(Duration(milliseconds: _maxMs(cached)), _goNext);

    // 3. 并行：拉版本号 + 后台刷新 splash 配置
    unawaited(_loadVersion());

    // 4. 后台静默拉取最新配置（不阻塞 minDuration）
    unawaited(_refreshConfigInBackground());

    // 5. 最短展示时长达到后就允许跳走（如果后台请求已结束就立刻走）
    await Future.delayed(Duration(milliseconds: _minMs(cached)));
    if (!mounted) return;
    _goNext();
  }

  Future<void> _refreshConfigInBackground() async {
    _setStatus('config');
    final remote = await SplashConfigService.instance.fetchRemote();
    if (!mounted || remote == null) return;
    setState(() => _config = remote);
    // 后台拉到了新配置就重置 maxTimer，让用户能多看一眼（但不会超过 max）
    final elapsed = DateTime.now().difference(_shownAt).inMilliseconds;
    final remaining = _maxMs(remote) - elapsed;
    if (remaining > 0) {
      _maxTimer?.cancel();
      _maxTimer = Timer(Duration(milliseconds: remaining), _goNext);
    }
  }

  Future<void> _loadVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (!mounted) return;
      setState(() {
        _appVersion = 'v${info.version}+${info.buildNumber}';
      });
    } catch (e) {
      log.w('Read package info failed: $e');
    }
  }

  void _setStatus(String key) {
    if (!mounted) return;
    final lang = Get.isRegistered<LanguageController>()
        ? Get.find<LanguageController>().locale.value.languageCode
        : 'zh';
    String text;
    switch (key) {
      case 'init':
        text = lang == 'zh'
            ? '正在准备...'
            : lang == 'ja'
                ? '準備中...'
                : 'Getting ready...';
        break;
      case 'config':
        text = lang == 'zh'
            ? '加载配置...'
            : lang == 'ja'
                ? '設定を取得中...'
                : 'Loading config...';
        break;
      default:
        text = '';
    }
    setState(() => _statusText = text);
  }

  /// 开发环境下给一个更长的展示下限，方便逐帧检查启动页效果；
  /// 其它环境严格按后台配置，避免拖慢真实用户进入主页。
  bool get _isDev => Config.currentEnvironment == EnvironmentType.dev;

  int _minMs(SplashConfig c) =>
      _isDev ? (c.minDurationMs < 3000 ? 3000 : c.minDurationMs) : c.minDurationMs;

  int _maxMs(SplashConfig c) =>
      _isDev ? (c.maxDurationMs < 5000 ? 5000 : c.maxDurationMs) : c.maxDurationMs;

  void _goNext() {
    if (_navigated || !mounted) return;
    _navigated = true;
    _maxTimer?.cancel();
    context.replaceNamed('home');
  }

  @override
  void dispose() {
    _controller.dispose();
    _maxTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = Get.isRegistered<LanguageController>()
        ? Get.find<LanguageController>().locale.value.languageCode
        : 'zh';
    final envLabel = _envLabel();

    return Scaffold(
      backgroundColor: const Color(0xFF0E1B2C),
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildBackground(),
          _buildVignette(),
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildLogo(),
                    SizedBox(height: 24.h),
                    Text(
                      _config.resolveTitle(lang).isEmpty
                          ? 'シネコ'
                          : _config.resolveTitle(lang),
                      style: TextStyle(
                        fontSize: 44.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 1.2,
                        shadows: const [
                          Shadow(blurRadius: 8, color: Colors.black54, offset: Offset(0, 2)),
                        ],
                      ),
                    ),
                    SizedBox(height: 36.h),
                    _buildProgressLine(),
                  ],
                ),
              ),
            ),
          ),
          // 跳过按钮：在最短展示时长后才出现，避免用户连品牌图都没看清
          Positioned(
            top: 40.h,
            right: 20.w,
            child: SafeArea(
              child: _buildSkipButton(),
            ),
          ),
          // 版本 + 环境标识
          Positioned(
            bottom: 16.h,
            right: 16.w,
            child: SafeArea(
              child: Text(
                [_appVersion, envLabel].where((s) => s.isNotEmpty).join(' · '),
                style: TextStyle(
                  fontSize: 18.sp,
                  color: Colors.white.withValues(alpha: 0.45),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    final url = _config.imageUrl;
    if (url != null && url.startsWith('http')) {
      // 运营在后台配置了（有版权授权的）主视觉时才走网络图；
      // 加载中用品牌渐变占位，避免黑屏，也不依赖任何 bundled 图片。
      return ExtendedImage.network(
        url,
        fit: BoxFit.cover,
        cache: true,
        loadStateChanged: (state) {
          if (state.extendedImageLoadState != LoadState.completed) {
            return _buildBrandBackground();
          }
          return null;
        },
      );
    }
    // 默认不再使用任何动漫/第三方图片，改用品牌渐变，规避版权风险。
    return _buildBrandBackground();
  }

  /// 品牌渐变背景：纯色 + 渐变，无第三方图片，避免版权问题。
  Widget _buildBrandBackground() {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF13294B),
            Color(0xFF0E1B2C),
            Color(0xFF1B1030),
          ],
          stops: [0.0, 0.55, 1.0],
        ),
      ),
    );
  }

  /// 整体压暗 + 底部渐变，提升文字可读性。
  Widget _buildVignette() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.25),
            Colors.black.withValues(alpha: 0.55),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 140.w,
      height: 140.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.35), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: _buildLogoContent(),
    );
  }

  /// Logo 优先级：后台配置的 [logoUrl]（远程，可不发版替换）
  /// > bundled 品牌 logo（assets/image/logo.png）> 图标兜底。
  Widget _buildLogoContent() {
    final logoUrl = _config.logoUrl;
    if (logoUrl != null && logoUrl.startsWith('http')) {
      return ExtendedImage.network(
        logoUrl,
        fit: BoxFit.cover,
        cache: true,
        loadStateChanged: (state) {
          if (state.extendedImageLoadState != LoadState.completed) {
            return _buildBundledLogo();
          }
          return null;
        },
      );
    }
    return _buildBundledLogo();
  }

  /// App 品牌 logo（戴 3D 眼镜的猫）。留少量内边距，避免贴满圆形描边。
  Widget _buildBundledLogo() {
    return Padding(
      padding: EdgeInsets.all(18.w),
      child: Image.asset(
        'assets/image/logo.png',
        fit: BoxFit.contain,
        errorBuilder: (context, error, stack) => _buildLogoIcon(),
      ),
    );
  }

  Widget _buildLogoIcon() {
    return Icon(
      Icons.movie_creation_rounded,
      size: 78.sp,
      color: Colors.white,
    );
  }

  Widget _buildProgressLine() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 36.w,
          height: 36.w,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.white.withValues(alpha: 0.85),
            ),
          ),
        ),
        if (_statusText.isNotEmpty) ...[
          SizedBox(height: 12.h),
          Text(
            _statusText,
            style: TextStyle(
              fontSize: 18.sp,
              color: Colors.white.withValues(alpha: 0.65),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSkipButton() {
    return GestureDetector(
      onTap: _goNext,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _skipLabel(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 22.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 6.w),
            Icon(Icons.arrow_forward_rounded, size: 20.sp, color: Colors.white),
          ],
        ),
      ),
    );
  }

  String _skipLabel() {
    final lang = Get.isRegistered<LanguageController>()
        ? Get.find<LanguageController>().locale.value.languageCode
        : 'zh';
    if (lang == 'ja') return 'スキップ';
    if (lang == 'en') return 'Skip';
    return '跳过';
  }

  /// dev / test / prod 标签，方便测试机识别环境。prod 隐藏。
  String _envLabel() {
    switch (Config.currentEnvironment) {
      case EnvironmentType.dev:
        return 'DEV';
      case EnvironmentType.test:
        return 'TEST';
      case EnvironmentType.preprod:
        return 'PREPROD';
      case EnvironmentType.prod:
        return '';
    }
  }
}
