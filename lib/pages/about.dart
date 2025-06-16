import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:otaku_movie/utils/index.dart'; // launchURL 工具方法

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

  void _openPrivacyPolicy() {
    const url = 'https://www.google.com';
    launchURL(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('关于')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // 垂直居中
            crossAxisAlignment: CrossAxisAlignment.center, // 水平居中
            mainAxisSize: MainAxisSize.min,
            children: [
              const FlutterLogo(size: 100),
              const SizedBox(height: 16),
              const Text(
                'Otaku Movie',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('版本号: $version'),
              const SizedBox(height: 16),
              const Text(
                '致力于为电影爱好者提供便捷的购票体验。',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              TextButton(
                onPressed: _openPrivacyPolicy,
                child: const Text('查看隐私协议'),
              ),
              const SizedBox(height: 8),
              const Text(
                '© 2025 Otaku Movie 版权所有',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
