import 'dart:io';
import 'package:path/path.dart' as path;
import 'pattern_base.dart';

/// Implements MVP pattern scaffolding with state management
class MvpPattern extends PatternBase {
  /// Creates a new MvpPattern instance
  MvpPattern(super.projectName, super.fileWriter, super.stateManagement);

  @override
  String getArchitecturePatternName() => 'MVP Pattern';

  @override
  String getHomeWidgetName() => 'LoginPage';

  @override
  String getHomePageImport() => 'features/login/view/login_page.dart';

  @override
  void createStructure() {
    final directories = [
      // Core directories
      'lib/core/utils',
      'lib/core/constants',
      'lib/core/services',
      'lib/core/state_management',

      // Login feature directories
      'lib/features/login/model',
      'lib/features/login/view',
      'lib/features/login/view/widgets',
      'lib/features/login/view_interface',
      'lib/features/login/presenter',
      'lib/features/login/${templateEngine.getStateManagementFolder()}',

      'test',
    ];

    for (final dir in directories) {
      Directory(path.join(projectName, dir)).createSync(recursive: true);
    }
  }

  @override
  void createCoreFiles() {
    createCommonCoreFiles();
    _createCoreServices();
    _createLoginFeature();
  }

  @override
  void createStateManagementFiles() {
    // Delegate to state management implementation
    stateManagementImpl.createCoreFiles(projectName);
  }

  @override
  void printStructureInfo() {
    // ignore: avoid_print
    print('  - core/           (Shared utilities and services)');
    // ignore: avoid_print
    print('  - features/       (Feature-based organization)');
    // ignore: avoid_print
    print('  - main.dart       (Entry point)');
  }

  void _createCoreServices() {
    fileWriter.writeFile('lib/core/services/api_client.dart', '''
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
  }

  void _createLoginFeature() {
    _createLoginModel();
    _createLoginViewInterface();
    _createLoginPresenter();
    _createLoginView();
  }

  void _createLoginModel() {
    fileWriter.writeFile('lib/features/login/model/user.dart', '''
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

    fileWriter.writeFile('lib/features/login/model/login_repository.dart', '''
import '../model/user.dart';

/// Login repository interface for MVP pattern
abstract class LoginRepository {
  Future<User> login(String email, String password);
  Future<User> register(String email, String password, String name);
  Future<void> logout();
}

/// Implementation of LoginRepository
class LoginRepositoryImpl implements LoginRepository {
  @override
  Future<User> login(String email, String password) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    return User(
      id: '1',
      email: email,
      name: 'Test User',
    );
  }

  @override
  Future<User> register(String email, String password, String name) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    return User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      name: name,
    );
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
''');
  }

  void _createLoginViewInterface() {
    fileWriter.writeFile(
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
  }

  void _createLoginPresenter() {
    fileWriter
        .writeFile('lib/features/login/presenter/login_presenter.dart', '''
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
  }

  void _createLoginView() {
    fileWriter.writeFile('lib/features/login/view/login_page.dart', '''
import 'package:flutter/material.dart';
import '../presenter/login_presenter.dart';
import '../view_interface/login_view_interface.dart';
import '../model/login_repository.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> implements LoginViewInterface {
  final LoginPresenter _presenter = LoginPresenter(LoginRepositoryImpl());
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
            Text(
              'MVP Architecture with ${stateManagement.displayName}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
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
''');
  }
}
