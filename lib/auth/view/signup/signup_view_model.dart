import 'package:flutter/material.dart';
import 'package:jwt_auth_flutter/provider/auth_provider.dart';
import '../verify/verify_view.dart';
import 'package:provider/provider.dart';

class SignupViewModel extends ChangeNotifier {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> signup(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      _showSnackBar(context, "Please fill all fields");
      return;
    }

    if (password.length < 6) {
      _showSnackBar(context, "Password must be at least 6 characters");
      return;
    }

    setLoading(true);
    final success = await authProvider.signup(email, password, username);
    setLoading(false);

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => VerifyView(email: email),
        ),
      );
    } else {
      _showSnackBar(context, "Signup failed! Please try again");
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}