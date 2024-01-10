class ConfigsModel {
  ConfigsModel({
    this.googleClientId,
    this.googleServerClientId,
    this.googleIosClientId,
    this.reversedGoogleIosClientId,
    this.posthogApiKey,
    this.posthogHost,
    this.magicLogin,
    this.emailPasswordLogin,
    this.hasUnsplashConfigured,
    this.hasOpenaiConfigured,
    this.fileSizeLimit,
    this.isSmtpConfigured,
  });

  factory ConfigsModel.fromJson(Map<String, dynamic> json) {
    return ConfigsModel(
      googleClientId: json['google_client_id'],
      googleServerClientId: json['google_server_client_id'],
      googleIosClientId: json['google_ios_client_id'],
      reversedGoogleIosClientId: json['reversed_google_ios_client_id'],
      posthogApiKey: json['posthog_api_key'],
      posthogHost: json['posthog_host'],
      magicLogin: json['magic_login'],
      emailPasswordLogin: json['email_password_login'],
      hasUnsplashConfigured: json['has_unsplash_configured'],
      hasOpenaiConfigured: json['has_openai_configured'],
      fileSizeLimit: json['file_size_limit']?.toDouble(),
      isSmtpConfigured: json['is_smtp_configured'],
    );
  }

  ConfigsModel empty() {
    return ConfigsModel(
      googleClientId: '',
      googleServerClientId: '',
      googleIosClientId: '',
      reversedGoogleIosClientId: '',
      posthogApiKey: '',
      posthogHost: '',
      magicLogin: false,
      emailPasswordLogin: false,
      hasUnsplashConfigured: false,
      hasOpenaiConfigured: false,
      fileSizeLimit: 0.0,
      isSmtpConfigured: false,
    );
  }

  String? googleClientId;
  String? googleServerClientId;
  String? googleIosClientId;
  String? reversedGoogleIosClientId;
  String? posthogApiKey;
  String? posthogHost;
  bool? magicLogin;
  bool? emailPasswordLogin;
  bool? hasUnsplashConfigured;
  bool? hasOpenaiConfigured;
  double? fileSizeLimit;
  bool? isSmtpConfigured;
}
