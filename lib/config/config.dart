enum EnvironmentType { dev, test, preprod, prod }

enum Flavor {
  dev,
  test,
  prod
}

class Config {
  static EnvironmentType currentEnvironment = EnvironmentType.dev;

  // 定义各环境的 API URL
  static const String localApiUrl = 'http://192.168.3.4:8080/api';
  static const String testApiUrl = 'http://test-api.otaku-movie.com/api';
  static const String preprodApiUrl = '';
  static const String prodApiUrl = '';

  // 根据当前环境获取 baseUrl
  static String get baseUrl {
    switch (currentEnvironment) {
      case EnvironmentType.dev:
        return localApiUrl;
      case EnvironmentType.test:
        return testApiUrl;
      case EnvironmentType.preprod:
        return preprodApiUrl;
      case EnvironmentType.prod:
        return prodApiUrl;
      default:
        return localApiUrl;
    }
  }
  static String get appTitle {
    switch (currentEnvironment) {
      case EnvironmentType.dev:
        return 'Dev Otaku Movie';
      case EnvironmentType.test:
        return 'Test Otaku Movie';
      case EnvironmentType.preprod:
        return 'Preprod Otaku Movie';
      case EnvironmentType.prod:
        return 'Prod  Otaku Movie';
      default:
        return 'Dev';
    }
  }
}
