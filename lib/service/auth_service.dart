import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

class AuthService {
  final Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final _logger = Logger();

  AuthService(this._dio);

  Future<bool> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {'email': email, 'password': password},
      );
      
      if (response.statusCode == 200) {
        final data = response.data;
        final token = data['token']; 
        
        if (token != null) {
          await _storage.write(key: 'jwt', value: token);
          _logger.i('Login successful, token stored');
          return true;
        }
      }
    } catch (e) {
      _logger.e('Login Error: $e');
    }
    return false;
  }

  Future<bool> signup(String email, String password, String username) async {
    try {
      final response = await _dio.post(
        '/signup',
        data: {
          'email': email,
          'password': password,
          'username': username,
        },
      );
      
      if (response.statusCode == 200) {
        _logger.i('Signup successful, verification needed');
        return true;
      }
    } catch (e) {
      _logger.e('Signup Error: $e');
    }
    return false;
  }

  Future<bool> verifyUser(String email, String verificationCode) async {
    try {
      final response = await _dio.post(
        '/verify',
        data: {
          'email': email,
          'verificationCode': verificationCode,
        },
      );
      
      if (response.statusCode == 200) {
        _logger.i('Verification successful');
        return true;
      }
    } catch (e) {
      _logger.e('Verification Error: $e');
    }
    return false;
  }

  Future<bool> resendVerificationCode(String email) async {
    try {
      final response = await _dio.post('/resend', queryParameters: {'email': email});
      
      if (response.statusCode == 200) {
        _logger.i('Verification code resent');
        return true;
      }
    } catch (e) {
      _logger.e('Resend Error: $e');
    }
    return false;
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'jwt');
  }

  Future<void> logOut() async {
    await _storage.delete(key: 'jwt');
  }

  Map<String, dynamic> parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid Token');
    }
    final payload = utf8.decode(
      base64Url.decode(base64Url.normalize(parts[1])),
    );
    return json.decode(payload);
  }
}
