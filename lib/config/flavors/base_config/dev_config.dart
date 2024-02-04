import 'base_config.dart';

class DevConfig implements BaseConfig {
  @override
  String get baseUrl => "https://coaching.cyberasol.com/api";

  @override
  String get imageBaseUrl => "https://coaching.cyberasol.com/";

  @override
  bool get reportErrors => false;

  @override
  bool get trackEvents => false;

  @override
  bool get useHttps => false;
}
