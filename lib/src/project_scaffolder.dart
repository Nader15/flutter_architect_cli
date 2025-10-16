import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:flutter_architect_cli/src/commands/create_command.dart';

/// Scaffolds Flutter projects with different architecture patterns
class ProjectScaffolder {
  /// The name of the project to create
  final String projectName;

  /// The directory where the project will be created
  final Directory projectDir;

  /// The architecture pattern to use
  final ArchitecturePattern pattern;

  /// Creates a new ProjectScaffolder instance
  ProjectScaffolder(this.projectName,
      {this.pattern = ArchitecturePattern.cleanArchitecture})
      : projectDir = Directory(projectName);

  /// Scaffolds the complete project structure based on selected pattern
  void scaffold() {
    // Delete existing lib folder if it exists
    _deleteExistingLibFolder();

    switch (pattern) {
      case ArchitecturePattern.cleanArchitecture:
        _scaffoldCleanArchitecturePattern();
        break;
      case ArchitecturePattern.mvvm:
        _scaffoldMVVMPattern();
        break;
      case ArchitecturePattern.mvc:
        _scaffoldMVCPattern();
        break;
      case ArchitecturePattern.mvp:
        _scaffoldMVPPattern();
        break;
    }
  }

  /// Scaffolds Clean Architecture pattern with exact structure
  void _scaffoldCleanArchitecturePattern() {
    _createCleanArchitectureStructure();
    _createCleanArchitecturePubspecFile();
    _createCleanArchitectureMainFiles();
    _createCleanArchitectureCoreFiles();

    // ignore: avoid_print
    print('✅ Clean Architecture project created successfully!');
    // ignore: avoid_print
    print('');
    // ignore: avoid_print
    print('📁 Clean Architecture Structure:');
    // ignore: avoid_print
    print('');
    // ignore: avoid_print
    print('  - core/     (Shared application code)');
    // ignore: avoid_print
    print('  - features/ (Feature-based organization)');
    // ignore: avoid_print
    print('  - app.dart  (App configuration)');
    // ignore: avoid_print
    print('  - main.dart (Entry point)');
    // ignore: avoid_print
    print('');
  }

  /// Creates Clean Architecture directory structure
  void _createCleanArchitectureStructure() {
    final directories = [
      // Core directories
      'lib/core/error',
      'lib/core/network',
      'lib/core/utils',
      'lib/core/constants',
      'lib/core/theme',
      'lib/core/di',

      // Auth feature directories
      'lib/features/auth/presentation/pages',
      'lib/features/auth/presentation/widgets',
      'lib/features/auth/presentation/state_management',
      'lib/features/auth/domain/entities',
      'lib/features/auth/domain/repositories',
      'lib/features/auth/domain/usecases',
      'lib/features/auth/data/models',
      'lib/features/auth/data/datasources',
      'lib/features/auth/data/repositories_impl',

      // Shared directories
      'lib/shared/widgets',
      'lib/shared/extensions',
      'lib/shared/helpers',

      'test',
    ];

    for (final dir in directories) {
      Directory(path.join(projectName, dir)).createSync(recursive: true);
    }
  }

  /// Creates pubspec.yaml for Clean Architecture pattern
  void _createCleanArchitecturePubspecFile() {
    final content = '''
name: $projectName
description: A Flutter Clean Architecture project

publish_to: 'none'

version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0

flutter:
  uses-material-design: true
''';

    _writeFile('pubspec.yaml', content);
  }

  /// Creates main files for Clean Architecture pattern
  void _createCleanArchitectureMainFiles() {
    // main.dart
    _writeFile('lib/main.dart', '''
import 'package:flutter/material.dart';
import 'app.dart';

void main() {
  runApp(const MyApp());
}
''');

    // app.dart
    _writeFile('lib/app.dart', '''
import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '$projectName',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const Scaffold(
        body: Center(
          child: Text('Welcome to $projectName - Clean Architecture'),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
''');
  }

  /// Creates core files for Clean Architecture pattern
  void _createCleanArchitectureCoreFiles() {
    // Core Constants
    _writeFile('lib/core/constants/app_constants.dart', '''
/// Application-level constants
class AppConstants {
  /// Application name
  static const String appName = '$projectName';
  
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
''');

    _writeFile('lib/core/constants/string_constants.dart', '''
/// String constants for the application
class StringConstants {
  static const String appTitle = '$projectName';
  static const String login = 'Login';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String submit = 'Submit';
  static const String cancel = 'Cancel';
  static const String error = 'Error';
  static const String success = 'Success';
  static const String noInternet = 'No internet connection';
  static const String serverError = 'Server error occurred';
}
''');

    // Core Error
    _writeFile('lib/core/error/failures.dart', '''
/// Base failure class
abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => message;
}

/// Server-related failures
class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message);
}

/// Cache-related failures
class CacheFailure extends Failure {
  const CacheFailure(String message) : super(message);
}

/// Network-related failures
class NetworkFailure extends Failure {
  const NetworkFailure(String message) : super(message);
}

/// Validation failures
class ValidationFailure extends Failure {
  const ValidationFailure(String message) : super(message);
}
''');

    _writeFile('lib/core/error/exceptions.dart', '''
/// Custom exceptions
class ServerException implements Exception {
  final String message;
  const ServerException(this.message);
}

class CacheException implements Exception {
  final String message;
  const CacheException(this.message);
}

class NetworkException implements Exception {
  final String message;
  const NetworkException(this.message);
}
''');

    // Core Network
    _writeFile('lib/core/network/network_info.dart', '''
/// Network connectivity checker
/// Implement your network connectivity logic here
class NetworkInfo {
  /// Check if device is connected to internet
  Future<bool> get isConnected async {
    // Implement your network connectivity check
    // Example using connectivity_plus:
    // final connectivityResult = await Connectivity().checkConnectivity();
    // return connectivityResult != ConnectivityResult.none;
    return true; // Placeholder
  }
}
''');

    _writeFile('lib/core/network/api_client.dart', '''
/// API client for HTTP requests
/// Implement your HTTP client logic here
class ApiClient {
  final String baseUrl;

  ApiClient({required this.baseUrl});

  /// Perform GET request
  Future<dynamic> get(String endpoint) async {
    // Implement your GET request logic
    // Example using http package:
    // final response = await http.get(Uri.parse('baseUrl/endpoint'));
    // return _handleResponse(response);
    return {}; // Placeholder
  }

  /// Perform POST request
  Future<dynamic> post(String endpoint, dynamic data) async {
    // Implement your POST request logic
    // Example using http package:
    // final response = await http.post(
    //   Uri.parse('baseUrl/endpoint'),
    //   headers: {'Content-Type': 'application/json'},
    //   body: json.encode(data),
    // );
    // return _handleResponse(response);
    return {}; // Placeholder
  }

  /// Handle HTTP response
  dynamic _handleResponse(dynamic response) {
    // Implement your response handling logic
    return response;
  }
}
''');

    // Core Utils
    _writeFile('lib/core/utils/validators.dart', '''
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
''');

    _writeFile('lib/core/utils/date_utils.dart', '''
/// Date utility functions
class DateUtils {
  static String formatDate(DateTime date) {
    return '\${date.day}/\${date.month}/\${date.year}';
  }

  static String formatDateTime(DateTime date) {
    return '\${formatDate(date)} \${date.hour}:\${date.minute}';
  }

  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }
}
''');

    // Core Theme
    _writeFile('lib/core/theme/app_theme.dart', '''
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
''');

    _writeFile('lib/core/theme/color_scheme.dart', '''
import 'package:flutter/material.dart';

/// Custom color scheme
class AppColors {
  static const Color primary = Color(0xFF2196F3);
  static const Color secondary = Color(0xFF03A9F4);
  static const Color accent = Color(0xFF00BCD4);
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFB00020);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color onBackground = Color(0xFF000000);
  static const Color onSurface = Color(0xFF000000);
  static const Color onError = Color(0xFFFFFFFF);
}
''');

    // Core DI
    _writeFile('lib/core/di/injection_container.dart', '''
/// Dependency injection setup
/// Add your dependency injection configuration here
class InjectionContainer {
  /// Initialize dependencies
  static Future<void> init() async {
    // Add your dependency registration here
    // Example:
    // GetIt.instance.registerFactory(() => YourRepository());
    // GetIt.instance.registerLazySingleton(() => YourService());
  }
}
''');
  }


  /// Scaffolds MVVM Architecture pattern with exact structure
  void _scaffoldMVVMPattern() {
    _createMVVMStructure();
    _createMVVMPubspecFile();
    _createMVVMMainFiles();
    _createMVVMCoreFiles();
    // _createMVVMAuthFeature();

    // ignore: avoid_print
    print('✅ MVVM Pattern project created successfully!');
    // ignore: avoid_print
    print('');
    // ignore: avoid_print
    print('📁 MVVM Structure:');
    // ignore: avoid_print
    print('');
    // ignore: avoid_print
    print('  - core/     (Shared utilities and constants)');
    // ignore: avoid_print
    print('  - data/     (Data layer with repositories and models)');
    // ignore: avoid_print
    print('  - domain/   (Business logic and entities)');
    // ignore: avoid_print
    print('  - features/ (Feature-based organization)');
    // ignore: avoid_print
    print('  - shared/   (Shared widgets and helpers)');
    // ignore: avoid_print
    print('');
  }

  /// Creates MVVM directory structure
  void _createMVVMStructure() {
    final directories = [
      // Core directories
      'lib/core/constants',
      'lib/core/utils',
      'lib/core/theme',
      'lib/core/errors',

      // Data layer
      'lib/data/datasources/remote',
      'lib/data/datasources/local',
      'lib/data/models',
      'lib/data/repositories',

      // Domain layer
      'lib/domain/entities',
      'lib/domain/repositories',
      'lib/domain/usecases',

      // Auth feature
      'lib/features/auth/presentation/views',
      'lib/features/auth/presentation/viewmodels',
      'lib/features/auth/data/models',
      'lib/features/auth/data/datasources',
      'lib/features/auth/data/repositories',
      'lib/features/auth/domain',

      // Shared directories
      'lib/shared/widgets',
      'lib/shared/extensions',
      'lib/shared/helpers',

      'test',
    ];

    for (final dir in directories) {
      Directory(path.join(projectName, dir)).createSync(recursive: true);
    }
  }

  /// Creates pubspec.yaml for MVVM pattern
  void _createMVVMPubspecFile() {
    final content = '''
name: $projectName
description: A Flutter MVVM Architecture project

publish_to: 'none'

version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0

flutter:
  uses-material-design: true
''';

    _writeFile('pubspec.yaml', content);
  }

  /// Creates main files for MVVM pattern
  void _createMVVMMainFiles() {
    // main.dart
    _writeFile('lib/main.dart', '''
import 'package:flutter/material.dart';
import 'injection.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '$projectName',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.architecture, size: 64, color: Colors.blue),
              SizedBox(height: 20),
              Text(
                'MVVM Architecture',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text('Welcome to $projectName!'),
            ],
          ),
        ),
      ),
    );
  }
}
''');

    // injection.dart
    _writeFile('lib/injection.dart', '''
/// Dependency injection setup for MVVM pattern
/// Add your service registration here
class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  final Map<Type, Object> _services = {};

  void register<T>(T service) {
    _services[T] = service!;
  }

  T get<T>() {
    return _services[T] as T;
  }

  bool contains<T>() {
    return _services.containsKey(T);
  }
}

final serviceLocator = ServiceLocator();

/// Initialize dependencies
void setupDependencies() {
  // Register your services here
  // Example:
  // serviceLocator.register<AuthRepository>(AuthRepositoryImpl());
  // serviceLocator.register<AuthViewModel>(AuthViewModel());
}
''');
  }

  /// Creates core files for MVVM pattern
  void _createMVVMCoreFiles() {
    // Core Constants
    _writeFile('lib/core/constants/app_constants.dart', '''
/// Application constants for MVVM pattern
class AppConstants {
  static const String appName = '$projectName';
  static const String baseUrl = 'https://api.example.com';
  static const String tokenKey = 'auth_token';
}
''');

    // Core Utils
    _writeFile('lib/core/utils/validators.dart', '''
/// Input validators for MVVM
class Validators {
  static bool isValidEmail(String email) {
    return RegExp(r'^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}\$').hasMatch(email);
  }

  static bool isValidPassword(String password) {
    return password.length >= 6;
  }
}
''');

    // Core Theme
    _writeFile('lib/core/theme/app_theme.dart', '''
import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.blue,
    useMaterial3: true,
  );
}
''');

    // Core Errors
    _writeFile('lib/core/errors/app_exceptions.dart', '''
/// Application exceptions for MVVM pattern
class AppException implements Exception {
  final String message;
  AppException(this.message);

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  NetworkException(String message) : super(message);
}

class ServerException extends AppException {
  ServerException(String message) : super(message);
}

class CacheException extends AppException {
  CacheException(String message) : super(message);
}
''');
  }


  /// Scaffolds MVC Architecture pattern with exact structure
  void _scaffoldMVCPattern() {
    _createMVCStructure();
    _createMVCPubspecFile();
    _createMVCMainFiles();
    _createMVCCoreFiles();
    // _createMVCAuthFeature();

    // ignore: avoid_print
    print('✅ MVC Pattern project created successfully!');
    // ignore: avoid_print
    print('');
    // ignore: avoid_print
    print('📁 MVC Structure:');
    // ignore: avoid_print
    print('');
    // ignore: avoid_print
    print('  - models/     (Data models)');
    // ignore: avoid_print
    print('  - views/      (UI screens and widgets)');
    // ignore: avoid_print
    print('  - controllers/(Business logic controllers)');
    // ignore: avoid_print
    print('  - services/   (API and database services)');
    // ignore: avoid_print
    print('  - utils/      (Helper functions)');
    // ignore: avoid_print
    print('');
  }

  /// Creates MVC directory structure
  void _createMVCStructure() {
    final directories = [
      // MVC core directories
      'lib/models',
      'lib/views',
      'lib/views/widgets',
      'lib/controllers',
      'lib/services',
      'lib/utils',

      'test',
    ];

    for (final dir in directories) {
      Directory(path.join(projectName, dir)).createSync(recursive: true);
    }
  }

  /// Creates pubspec.yaml for MVC pattern
  void _createMVCPubspecFile() {
    final content = '''
name: $projectName
description: A Flutter MVC Architecture project

publish_to: 'none'

version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0

flutter:
  uses-material-design: true
''';

    _writeFile('pubspec.yaml', content);
  }

  /// Creates main files for MVC pattern
  void _createMVCMainFiles() {
    // main.dart
    _writeFile('lib/main.dart', '''
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/app_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppController(),
      child: MaterialApp(
        title: '$projectName',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const HomeView(),
      ),
    );
  }
}
''');
  }

  /// Creates core files for MVC pattern
  void _createMVCCoreFiles() {
    // Utils - Validators
    _writeFile('lib/utils/validators.dart', '''
/// Input validators for MVC pattern
class Validators {
  static bool isValidEmail(String email) {
    return RegExp(r'^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}\$').hasMatch(email);
  }

  static bool isValidPassword(String password) {
    return password.length >= 6;
  }

  static bool isValidPhone(String phone) {
    return RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\\s\\./0-9]*\$').hasMatch(phone);
  }
}
''');

    // Utils - Helpers
    _writeFile('lib/utils/helpers.dart', '''
import 'package:flutter/material.dart';

/// Helper functions for MVC pattern
class Helpers {
  /// Formats date to readable string
  static String formatDate(DateTime date) {
      return '\${date.day}/\${date.month}/\${date.year}';
  }

  /// Capitalizes the first letter of a string
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  /// Shows a snackbar message 
  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  /// Validates email format
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[w-.]+@([w-]+.)+[w-]{2,4}\$');
    return emailRegex.hasMatch(email);
  }
}
''');
  }


  /// Scaffolds MVP Architecture pattern with exact structure
  void _scaffoldMVPPattern() {
    _createMVPStructure();
    _createMVPPubspecFile();
    _createMVPMainFiles();
    _createMVPCoreFiles();

    // ignore: avoid_print
    print('✅ MVP Pattern project created successfully!');
    // ignore: avoid_print
    print('');
    // ignore: avoid_print
    print('📁 MVP Structure:');
    // ignore: avoid_print
    print('');
    // ignore: avoid_print
    print('  - core/           (Shared utilities and services)');
    // ignore: avoid_print
    print('  - features/       (Feature-based organization)');
    // ignore: avoid_print
    print('  - main.dart       (Entry point)');
    // ignore: avoid_print
    print('');
  }

  /// Creates MVP directory structure
  void _createMVPStructure() {
    final directories = [
      // Core directories
      'lib/core/utils',
      'lib/core/constants',
      'lib/core/services',

      // Login feature directories
      'lib/features/login/model',
      'lib/features/login/view',
      'lib/features/login/view/widgets',
      'lib/features/login/view_interface',
      'lib/features/login/presenter',

      'test',
    ];

    for (final dir in directories) {
      Directory(path.join(projectName, dir)).createSync(recursive: true);
    }
  }

  /// Creates pubspec.yaml for MVP pattern
  void _createMVPPubspecFile() {
    final content = '''
name: $projectName
description: A Flutter MVP Architecture project

publish_to: 'none'

version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0

flutter:
  uses-material-design: true
''';

    _writeFile('pubspec.yaml', content);
  }

  /// Creates main files for MVP pattern
  void _createMVPMainFiles() {
    // main.dart
    _writeFile('lib/main.dart', '''
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '$projectName',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.architecture, size: 64, color: Colors.blue),
              SizedBox(height: 20),
              Text(
                'MVP Architecture',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text('Welcome to $projectName!'),
            ],
          ),
        ),
      ),
    );
  }
}
''');
  }

  /// Creates core files for MVP pattern
  void _createMVPCoreFiles() {
    // Core Constants
    _writeFile('lib/core/constants/app_constants.dart', '''
/// Application constants for MVP pattern
class AppConstants {
  static const String appName = '$projectName';
  static const String baseUrl = 'https://api.example.com';
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
}
''');

    // Core Utils
    _writeFile('lib/core/utils/validators.dart', '''
/// Input validators for MVP pattern
class Validators {
  static bool isValidEmail(String email) {
    return RegExp(r'^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}\$').hasMatch(email);
  }

  static bool isValidPassword(String password) {
    return password.length >= 6;
  }

  static bool isValidPhone(String phone) {
    return RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\\s\\./0-9]*\$').hasMatch(phone);
  }
}
''');

    _writeFile('lib/core/utils/helpers.dart', '''
import 'package:flutter/material.dart';

/// Helper functions for MVP pattern
class Helpers {
  /// Formats date to readable string
  static String formatDate(DateTime date) {
    return '\${date.day}/\${date.month}/\${date.year}';
  }

  /// Capitalizes the first letter of a string
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  /// Shows a snackbar message
  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
''');

    // Core Services
    _writeFile('lib/core/services/api_client.dart', '''
/// API client for HTTP requests
/// Implement your HTTP client logic here
class ApiClient {
  final String baseUrl;

  ApiClient({required this.baseUrl});

  /// Perform GET request
  Future<dynamic> get(String endpoint) async {
    // Implement your GET request logic
    // Example using http package:
    // final response = await http.get(Uri.parse('baseUrl/endpoint'));
    // return _handleResponse(response);
    return {}; // Placeholder
  }

  /// Perform POST request
  Future<dynamic> post(String endpoint, dynamic data) async {
    // Implement your POST request logic
    // Example using http package:
    // final response = await http.post(
    //   Uri.parse('baseUrl/endpoint'),
    //   headers: {'Content-Type': 'application/json'},
    //   body: json.encode(data),
    // );
    // return _handleResponse(response);
    return {}; // Placeholder
  }

  /// Handle HTTP response
  dynamic _handleResponse(dynamic response) {
    // Implement your response handling logic
    return response;
  }
}
''');

    // Login Feature - Model
    _writeFile('lib/features/login/model/user.dart', '''
/// User model for MVP pattern
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

  /// Creates User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      profileImage: json['profileImage'],
    );
  }

  /// Converts User to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'profileImage': profileImage,
    };
  }

  @override
  String toString() {
    return 'User(id: \$id, email: \$email, name: \$name)';
  }
}
''');

    _writeFile('lib/features/login/model/login_repository.dart', '''
import '../model/user.dart';

/// Login repository interface for MVP pattern
abstract class LoginRepository {
  Future<User> login(String email, String password);
  Future<User> register(String email, String password, String name);
  Future<void> logout();
}
''');

    // Login Feature - View Interface
    _writeFile(
        'lib/features/login/view_interface/login_view_interface.dart', '''
/// Interface that View implements for Presenter interaction
abstract class LoginViewInterface {
  void showLoading();
  void hideLoading();
  void onLoginSuccess();
  void onLoginError(String error);
  void navigateToHome();
}
''');

    // Login Feature - Presenter
    _writeFile('lib/features/login/presenter/login_presenter.dart', '''
import '../model/login_repository.dart';
import '../view_interface/login_view_interface.dart';

/// Presenter for login feature in MVP pattern
class LoginPresenter {
  final LoginRepository _repository;
  late LoginViewInterface _view;

  LoginPresenter(this._repository);

  /// Attach view to presenter
  void attachView(LoginViewInterface view) {
    _view = view;
  }

  /// Detach view from presenter
  void detachView() {
    // Clean up if needed
  }

  /// Perform login operation
  Future<void> login(String email, String password) async {
    _view.showLoading();
    
    try {
      final user = await _repository.login(email, password);
      _view.hideLoading();
      _view.onLoginSuccess();
      _view.navigateToHome();
    } catch (e) {
      _view.hideLoading();
      _view.onLoginError('Login failed: \$e');
    }
  }

  /// Validate email and password
  bool validateCredentials(String email, String password) {
    final emailRegex = RegExp(r'^[\\w-\\.]+@([\\w-]+\\.)+[\\w-]{2,4}\$');
    return emailRegex.hasMatch(email) && password.length >= 6;
  }
}
''');

    // Login Feature - View
    _writeFile('lib/features/login/view/login_page.dart', '''
import 'package:flutter/material.dart';
import '../presenter/login_presenter.dart';
import '../view_interface/login_view_interface.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> implements LoginViewInterface {
  final LoginPresenter _presenter = LoginPresenter(_MockLoginRepository());
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _presenter.attachView(this);
  }

  @override
  void dispose() {
    _presenter.detachView();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login - MVP Pattern'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'MVP Architecture',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
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
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
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
    
    if (_presenter.validateCredentials(email, password)) {
      _presenter.login(email, password);
    } else {
      onLoginError('Please enter valid email and password');
    }
  }

  // LoginViewInterface implementation
  @override
  void showLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  @override
  void hideLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void onLoginSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Login successful!')),
    );
  }

  @override
  void onLoginError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error)),
    );
  }

  @override
  void navigateToHome() {
    // Implement navigation to home screen
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
  }
}

/// Mock repository for demonstration
class _MockLoginRepository implements LoginRepository {
  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<dynamic> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    return {
      'id': '1',
      'email': email,
      'name': 'Test User',
    };
  }

  @override
  Future<dynamic> register(String email, String password, String name) async {
    await Future.delayed(const Duration(seconds: 2));
    return {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'email': email,
      'name': name,
    };
  }
}
''');
  }

  /// Writes content to a file at the specified relative path
  void _writeFile(String relativePath, String content) {
    final file = File(path.join(projectName, relativePath));
    file.createSync(recursive: true);
    file.writeAsStringSync(content);
  }

  /// Deletes the existing lib folder if it exists
  void _deleteExistingLibFolder() {
    final libDir = Directory(path.join(projectName, 'lib'));

    if (libDir.existsSync()) {
      // ignore: avoid_print
      print('🗑️  Removing existing lib folder...');
      libDir.deleteSync(recursive: true);
      // ignore: avoid_print
      print('');
      // ignore: avoid_print
      print('✅ Existing lib folder removed');
      // ignore: avoid_print
      print('');
    }
  }
}
