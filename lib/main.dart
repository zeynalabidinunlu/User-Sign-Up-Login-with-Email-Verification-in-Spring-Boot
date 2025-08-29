import 'package:flutter/material.dart';
import 'package:jwt_auth_flutter/auth/view/signup/signup_view.dart';
import 'package:jwt_auth_flutter/provider/auth_provider.dart';
import 'package:jwt_auth_flutter/service/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'auth/view/login/login_view_model.dart';
import 'auth/view/signup/signup_view_model.dart';
import 'auth/view/verify/verify_view_model.dart';
import 'home_view.dart';

void main() {
  final dio = Dio();
  dio.options.baseUrl =
      'http://10.0.2.2:8080/auth'; 
  dio.options.headers['Content-Type'] = 'application/json';

  final authService = AuthService(dio);

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => authService),
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(authService),
        ),
        ChangeNotifierProvider<LoginViewModel>(create: (_) => LoginViewModel()),
        ChangeNotifierProvider<SignupViewModel>(
          create: (_) => SignupViewModel(),
        ),
        ChangeNotifierProvider<VerifyViewModel>(
          create: (_) => VerifyViewModel(),
        ),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'JWT Auth Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          if (authProvider.isAuthenticated) {
            return const HomeView();
          } else {
            return const SignupView();
          }
        },
      ),
    );
  }
}
