import 'dart:io';
import 'package:path/path.dart' as path;
import '../../flutter_architect_cli.dart';
import 'pattern_base.dart';

/// Implements MVC pattern scaffolding with state management
class MvcPattern extends PatternBase {
  /// Creates a new MvcPattern instance
  MvcPattern(super.projectName, super.fileWriter, super.stateManagement,
      {super.organization = 'com.example'});

  @override
  String getArchitecturePatternName() => 'MVC Pattern';

  @override
  String getHomeWidgetName() => 'HomeView';

  @override
  String getHomePageImport() => 'views/home_view.dart';

  @override
  void createStructure() {
    final directories = [
      // MVC core directories
      'lib/models',
      'lib/views',
      'lib/views/widgets',
      'lib/controllers',
      'lib/services',
      'lib/utils',
      'lib/core',

      // Auth feature directories
      'lib/features/auth/models',
      'lib/features/auth/views',
      'lib/features/auth/controllers',
      'lib/features/auth/services',

      'test',
    ];

    for (final dir in directories) {
      Directory(path.join(projectName, dir)).createSync(recursive: true);
    }
  }

  @override
  void createCoreFiles() {
    createCommonCoreFiles();
    _createUtilsFiles();
    _createModels();
    _createServices();
    _createAuthFeature();
  }

  @override
  void createStateManagementFiles() {
    // Delegate to state management implementation
    stateManagementImpl.createCoreFiles(projectName);
    _createHomeView();
  }

  @override
  void printStructureInfo() {
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
  }

  void _createUtilsFiles() {
    fileWriter.writeFile('lib/utils/helpers.dart', '''
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

  void _createModels() {
    fileWriter.writeFile('lib/models/user.dart', '''
/// User model for MVC pattern
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

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
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

  @override
  String toString() {
    return 'User(id: \$id, email: \$email, name: \$name)';
  }
}
''');
  }

  void _createServices() {
    fileWriter.writeFile('lib/services/api_service.dart', '''
/// API service for HTTP requests
class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

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

    fileWriter.writeFile('lib/services/auth_service.dart', '''
import '../models/user.dart';
import 'api_service.dart';

/// Authentication service
class AuthService {
  final ApiService apiService;

  AuthService({required this.apiService});

  Future<User> login(String email, String password) async {
    // Implement login logic
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call
    return User(
      id: '1',
      email: email,
      name: 'Test User',
    );
  }

  Future<User> register(String email, String password, String name) async {
    // Implement registration logic
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call
    return User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      name: name,
    );
  }

  Future<void> logout() async {
    // Implement logout logic
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
''');
  }

  void _createAuthFeature() {
    _createAuthController();
    _createAuthView();
  }

  void _createAuthController() {
    // Create a simple auth controller based on state management
    switch (stateManagement) {
      case StateManagement.bloc:
        _createBlocAuthController();
        break;
      case StateManagement.provider:
        _createProviderAuthController();
        break;
      case StateManagement.riverpod:
        _createRiverpodAuthController();
        break;
      case StateManagement.getx:
        _createGetxAuthController();
        break;
    }
  }

  void _createBlocAuthController() {
    fileWriter
        .writeFile('lib/features/auth/controllers/auth_controller.dart', '''
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../services/auth_service.dart';

class AuthState {
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;
  final String? userEmail;

  const AuthState({
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
    this.userEmail,
  });

  AuthState copyWith({
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
    String? userEmail,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userEmail: userEmail ?? this.userEmail,
    );
  }
}

class AuthController extends Cubit<AuthState> {
  final AuthService authService;

  AuthController({required this.authService}) : super(const AuthState());

  Future<void> login(String email, String password) async {
    emit(state.copyWith(isLoading: true, error: null));
    
    try {
      final user = await authService.login(email, password);
      emit(state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        userEmail: user.email,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Login failed: \$e',
      ));
    }
  }

  void logout() {
    emit(const AuthState());
  }
}
''');
  }

  void _createProviderAuthController() {
    fileWriter
        .writeFile('lib/features/auth/controllers/auth_controller.dart', '''
import 'package:flutter/foundation.dart';
import '../../../services/auth_service.dart';

class AuthController with ChangeNotifier {
  final AuthService authService;

  AuthController({required this.authService});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  String? _userEmail;
  String? get userEmail => _userEmail;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final user = await authService.login(email, password);
      _userEmail = user.email;
      _isAuthenticated = true;
    } catch (e) {
      _error = 'Login failed: \$e';
      _isAuthenticated = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void logout() {
    _isAuthenticated = false;
    _userEmail = null;
    _error = null;
    notifyListeners();
  }
}
''');
  }

  void _createRiverpodAuthController() {
    fileWriter
        .writeFile('lib/features/auth/controllers/auth_controller.dart', '''
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/auth_service.dart';
import '../../../services/api_service.dart';

class AuthState {
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;
  final String? userEmail;

  const AuthState({
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
    this.userEmail,
  });

  AuthState copyWith({
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
    String? userEmail,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userEmail: userEmail ?? this.userEmail,
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  final AuthService authService;

  AuthController({required this.authService}) : super(const AuthState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final user = await authService.login(email, password);
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        userEmail: user.email,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Login failed: \$e',
      );
    }
  }

  void logout() {
    state = const AuthState();
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(authService: AuthService(apiService: ApiService(baseUrl: 'https://api.example.com')));
});
''');
  }

  void _createGetxAuthController() {
    fileWriter
        .writeFile('lib/features/auth/controllers/auth_controller.dart', '''
import 'package:get/get.dart';
import '../../../services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService authService;

  AuthController({required this.authService});

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final RxnString _error = RxnString();
  String? get error => _error.value;

  final RxBool _isAuthenticated = false.obs;
  bool get isAuthenticated => _isAuthenticated.value;

  final RxnString _userEmail = RxnString();
  String? get userEmail => _userEmail.value;

  Future<void> login(String email, String password) async {
    _isLoading.value = true;
    _error.value = null;

    try {
      final user = await authService.login(email, password);
      _userEmail.value = user.email;
      _isAuthenticated.value = true;
    } catch (e) {
      _error.value = 'Login failed: \$e';
      _isAuthenticated.value = false;
    } finally {
      _isLoading.value = false;
    }
  }

  void logout() {
    _isAuthenticated.value = false;
    _userEmail.value = null;
    _error.value = null;
  }
}
''');
  }

  void _createAuthView() {
    fileWriter.writeFile('lib/features/auth/views/login_view.dart', '''
import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login - MVC Pattern'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'MVC Architecture with ${stateManagement.displayName}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
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
''');
  }

  void _createHomeView() {
    fileWriter.writeFile('lib/views/home_view.dart', '''
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('{{projectName}}'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'MVC Architecture with {{stateManagement}}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'Welcome to your MVC app!',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
''');
  }
}
