import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../constants/api_endpoints.dart';
import '../../../constants/keys.dart';
import '../../../core/api_result.dart';
import '../../../core/core.dart';
import '../models/auth_response.dart';
import '../models/login_input.dart';

class AuthRepository {
  final NetworkService _networkService;
  final StorageService _storageService;

  User user = User.empty;

  AuthRepository(this._networkService, this._storageService);

  Future<AuthResponse> login(LoginInput loginInput) async {
    try {
      var response = await _networkService.post(
        Endpoints.login,
        data: loginInput.toJson(),
      );
      AuthResponse authResponse = AuthResponse.fromJson(response);
      if (authResponse.result == ApiResult.success) {
        _saveToken(authResponse.token);
        saveUser(authResponse.user);
      }
      return authResponse;
    } on BaseFailure catch (_) {
      rethrow;
    } on TypeError catch (e) {
      log('TYPE error stackTrace :: ${e.stackTrace}');
      rethrow;
    }
  }

  Future<AuthResponse> register(FormData registerInput) async {
    try {
      var response = await _networkService.post(
        Endpoints.register,
        data: registerInput,
      );
      AuthResponse authResponse = AuthResponse.fromJson(response);
      if (authResponse.result == ApiResult.success) {
        _saveToken(authResponse.token);
        saveUser(authResponse.user);
      }
      return authResponse;
    } on BaseFailure catch (_) {
      rethrow;
    } on TypeError catch (e) {
      log('TYPE error stackTrace :: ${e.stackTrace}');
      rethrow;
    }
  }

  // token
  Future<void> _saveToken(String token) async {
    await _storageService.setString(StorageKeys.token, token);
  }

  String _getToken() {
    return _storageService.getString(StorageKeys.token);
  }

  Future<void> _removeToken() async {
    await _storageService.remove(StorageKeys.token);
  }

  // user
  Future<void> saveUser(User user) async {
    this.user = user;
    final userMap = user.toJson();
    await _storageService.setString(StorageKeys.user, json.encode(userMap));
  }

  Future<void> _removeUser() async {
    await _storageService.remove(StorageKeys.user);
  }

  Future<void> getUser() async {
    final userString = _storageService.getString(StorageKeys.user);
    if (userString.isEmpty) {
      return;
    }
    final Map<String, dynamic> userMap = jsonDecode(userString);
    User user = User.fromJson(userMap);
    this.user = user;
  }

  Map<String, dynamic>? getHeaders() {
    return _getToken() == ''
        ? null
        : {
            'Accept': 'application/json',
            'Authorization': 'Bearer ${_getToken()}',
          };
  }

  bool isAuthenticated() {
    return _getToken().isNotEmpty;
  }

  Future<void> logout() async {
    await _removeUser();
    await _removeToken();
    user = User.empty;
  }
}
