import 'base_config.dart';

class ProdConfig implements BaseConfig {
  @override
  String get baseUrl => "https://phptest.cyberasol.com";
  @override
  String get imageBaseUrl => "https://loftyrooms.cyberasol.com/api";

  @override
  bool get reportErrors => false;

  @override
  bool get trackEvents => false;

  @override
  bool get useHttps => false;
}
