enum EnvironmentType { dev, test, preprod, prod }

// 定义环境配置类
class EnvironmentConfig {
  final String apiUrl;
  final String imageBaseUrl;
  final String appTitle;

  const EnvironmentConfig({
    required this.apiUrl,
    required this.imageBaseUrl,
    required this.appTitle,
  });

  // 根据 EnvironmentType 生成对应配置
  factory EnvironmentConfig.fromType(EnvironmentType env) {
    switch (env) {
      case EnvironmentType.dev:
        return const EnvironmentConfig(
          apiUrl: 'http://192.168.3.4:8080/api',
          imageBaseUrl: 'http://drive.bangumi.xyz:9000/test-movie',
          appTitle: 'Dev Otaku Movie',
        );
      case EnvironmentType.test:
        return const EnvironmentConfig(
          apiUrl: 'http://test-api.otaku-movie.com/api',
          imageBaseUrl: 'https://drive.bangumi.xyz:9000/test-movie',
          appTitle: 'Test Otaku Movie',
        );
      case EnvironmentType.preprod:
        return const EnvironmentConfig(
          apiUrl: '',
          imageBaseUrl: '',
          appTitle: 'Preprod Otaku Movie',
        );
      case EnvironmentType.prod:
        return const EnvironmentConfig(
          apiUrl: '',
          imageBaseUrl: 'https://cdn.otaku-movie.com/images',
          appTitle: 'Prod Otaku Movie',
        );
    }
  }
}

class Config {
  static EnvironmentType currentEnvironment = EnvironmentType.dev;

  static EnvironmentConfig get environmentConfig =>
      EnvironmentConfig.fromType(currentEnvironment);

  static String get baseUrl => environmentConfig.apiUrl;
  static String get imageBaseUrl => environmentConfig.imageBaseUrl;
  static String get appTitle => environmentConfig.appTitle;
}
