// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:jwt_auth_flutter/provider/auth_provider.dart';
import '../login/login_view.dart';
import 'package:provider/provider.dart';

class VerifyViewModel extends ChangeNotifier {
  final TextEditingController verificationCodeController = TextEditingController();
  bool _isLoading = false;
  bool _isResending = false;

  bool get isLoading => _isLoading;
  bool get isResending => _isResending;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setResending(bool value) {
    _isResending = value;
    notifyListeners();
  }

  Future<void> verifyUser(BuildContext context, String email) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final verificationCode = verificationCodeController.text.trim();

    if (verificationCode.isEmpty) {
      _showSnackBar(context, "Please enter verification code");
      return;
    }

    setLoading(true);
    final success = await authProvider.verifyUser(email, verificationCode);
    setLoading(false);

    if (success) {
      _showSnackBar(context, "Account verified successfully!");
      authProvider.resetRegistrationState();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginView()),
        (route) => false,
      );
    } else {
      _showSnackBar(context, "Invalid verification code");
    }
  }

  Future<void> resendCode(BuildContext context, String email) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    setResending(true);
    final success = await authProvider.resendVerificationCode(email);
    setResending(false);

    if (success) {
      _showSnackBar(context, "Verification code sent to your email");
    } else {
      _showSnackBar(context, "Failed to resend code. Please try again");
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    verificationCodeController.dispose();
    super.dispose();
  }
}