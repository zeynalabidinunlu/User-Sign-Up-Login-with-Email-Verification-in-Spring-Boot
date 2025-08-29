import 'package:flutter/material.dart';
import '../service/auth_service.dart';
import 'package:logger/logger.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  bool _isAuthenticated = false;
  bool _isRegistered = false;
  bool _isVerified = false;
  
  final _logger = Logger();

  AuthProvider(this._authService) {
    _checkAuthStatus();
  }

  bool get isAuthenticated => _isAuthenticated;
  bool get isRegistered => _isRegistered;
  bool get isVerified => _isVerified;

  Future<void> _checkAuthStatus() async {
    final token = await _authService.getToken();
    if (token != null) {
      _isAuthenticated = true;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    final success = await _authService.login(email, password);
    _logger.i('Login result: $success');
    if (success) {
      _isAuthenticated = true;
      notifyListeners();
    }
    return success;
  }

  Future<bool> signup(String email, String password, String username) async {
    final success = await _authService.signup(email, password, username);
    _logger.i('Signup result: $success');
    if (success) {
      _isRegistered = true;
      notifyListeners();
    }
    return success;
  }

  Future<bool> verifyUser(String email, String verificationCode) async {
    final success = await _authService.verifyUser(email, verificationCode);
    _logger.i('Verification result: $success');
    if (success) {
      _isVerified = true;
      notifyListeners();
    }
    return success;
  }

  Future<bool> resendVerificationCode(String email) async {
    return await _authService.resendVerificationCode(email);
  }

  Future<void> logout() async {
    await _authService.logOut();
    _isAuthenticated = false;
    _isRegistered = false;
    _isVerified = false;
    notifyListeners();
  }

  void resetRegistrationState() {
    _isRegistered = false;
    _isVerified = false;
    notifyListeners();
  }
}