/// Common templates used across different architecture patterns
class CommonTemplates {
  /// Pubspec.yaml template
  static const String pubspecTemplate = '''
name: {{projectName}}
description: A Flutter {{architecturePattern}} project with {{stateManagement}}

publish_to: 'none'

version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
{{dependencies}}

dev_dependencies:
  flutter_test:
    sdk: flutter
{{devDependencies}}

flutter:
  uses-material-design: true
''';

  /// Main.dart template
  static const String mainTemplate = '''
import 'package:flutter/material.dart';
import 'app.dart';

void main() {
  runApp(const MyApp());
}
''';

  /// App.dart template
  static const String appTemplate = '''
import 'package:flutter/material.dart';
{{stateManagementImport}}
import '{{homePageImport}}';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return {{appWrapper}};
  }
}
''';

  /// User entity template
  static const String userEntityTemplate = '''
/// User entity
class User {
  final String id;
  final String email;
  final String name;
  final String? profileImage;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.profileImage,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
''';

  /// User model template
  static const String userModelTemplate = '''
import '../../domain/entities/user.dart';

/// User data model
class UserModel extends User {
  UserModel({
    required String id,
    required String email,
    required String name,
    String? profileImage,
  }) : super(id: id, email: email, name: name, profileImage: profileImage);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      profileImage: json['profileImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'profileImage': profileImage,
    };
  }

  User toEntity() {
    return User(
      id: id,
      email: email,
      name: name,
      profileImage: profileImage,
    );
  }
}
''';

  /// Auth repository template
  static const String authRepositoryTemplate = '''
import '../../domain/entities/user.dart';

/// Authentication repository contract
abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<User> register(String email, String password, String name);
  Future<void> logout();
  Future<User> getCurrentUser();
  Future<bool> isLoggedIn();
}
''';

  /// Auth repository implementation template
  static const String authRepositoryImplTemplate = '''
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<User> login(String email, String password) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    return UserModel(
      id: '1',
      email: email,
      name: 'Test User',
    );
  }

  @override
  Future<User> register(String email, String password, String name) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    return UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      name: name,
    );
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<User> getCurrentUser() async {
    // Implement getting current user
    return UserModel(
      id: '1',
      email: 'test@example.com',
      name: 'Test User',
    );
  }

  @override
  Future<bool> isLoggedIn() async {
    // Implement login check
    return false;
  }
}
''';

  /// App constants template
  static const String appConstantsTemplate = '''
/// Application-level constants
class AppConstants {
  /// Application name
  static const String appName = '{{projectName}}';
  
  /// API endpoints
  static const String baseUrl = 'https://api.example.com';
  
  /// Storage keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'app_theme';
  
  /// Route names
  static const String loginRoute = '/login';
  static const String homeRoute = '/home';
  static const String splashRoute = '/splash';
}
''';

  /// Validators template
  static const String validatorsTemplate = '''
/// Input validators
class Validators {
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}\$');
    return emailRegex.hasMatch(email);
  }

  static bool isValidPassword(String password) {
    return password.length >= 6;
  }

  static bool isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\\s\\./0-9]*\$');
    return phoneRegex.hasMatch(phone);
  }
}
''';

  /// App theme template
  static const String appThemeTemplate = '''
import 'package:flutter/material.dart';

/// Application theme configuration
class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.light,
    useMaterial3: true,
    fontFamily: 'Roboto',
  );

  static final ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.dark,
    useMaterial3: true,
    fontFamily: 'Roboto',
  );
}
''';

  /// Login page template
  static const String loginPageTemplate = '''
import 'package:flutter/material.dart';
{{stateManagementImport}}
import '../{{stateManagementFolder}}/{{stateManagementFileName}}';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to {{projectName}}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _performLogin,
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  void _performLogin() {
    final email = _emailController.text;
    final password = _passwordController.text;
    
    // TODO: Implement login logic based on state management
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
''';
}
