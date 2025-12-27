enum AppEnvironment {
  dev,
  staging,
  production;

  static AppEnvironment fromString(String value) {
    switch (value.toLowerCase()) {
      case 'dev':
      case 'development':
        return AppEnvironment.dev;
      case 'staging':
        return AppEnvironment.staging;
      case 'prod':
      case 'production':
        return AppEnvironment.production;
      default:
        return AppEnvironment.dev;
    }
  }

  bool get isDev => this == AppEnvironment.dev;
  bool get isStaging => this == AppEnvironment.staging;
  bool get isProduction => this == AppEnvironment.production;
}

