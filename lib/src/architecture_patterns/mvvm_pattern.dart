import 'dart:io';
import 'package:path/path.dart' as path;
import '../../flutter_architect_cli.dart';
import 'pattern_base.dart';

/// Implements MVVM pattern scaffolding with state management
class MvvmPattern extends PatternBase {
  /// Creates a new MvvmPattern instance
  MvvmPattern(super.projectName, super.fileWriter, super.stateManagement);

  @override
  String getArchitecturePatternName() => 'MVVM Pattern';

  @override
  String getHomeWidgetName() => 'LoginView';

  @override
  String getHomePageImport() =>
      'features/auth/presentation/views/login_view.dart';

  @override
  void createStructure() {
    final directories = [
      // Core directories
      'lib/core/constants',
      'lib/core/utils',
      'lib/core/theme',
      'lib/core/errors',
      'lib/core/state_management',

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
      'lib/features/auth/presentation/${templateEngine.getStateManagementFolder()}',
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

  @override
  void createCoreFiles() {
    createCommonCoreFiles();
    _createCoreErrors();
    _createDomainLayer();
    _createDataLayer();
  }

  @override
  void createStateManagementFiles() {
    // Delegate to state management implementation
    stateManagementImpl.createCoreFiles(projectName);
    _createAuthFeature();
  }

  @override
  void printStructureInfo() {
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
  }

  void _createCoreErrors() {
    fileWriter.writeFile('lib/core/errors/app_exceptions.dart', '''
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

  void _createDomainLayer() {
    // User Entity
    fileWriter.writeFile('lib/domain/entities/user.dart', '''
/// User entity for MVVM pattern
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
''');

    // Auth Repository
    fileWriter.writeFile('lib/domain/repositories/auth_repository.dart', '''
import '../entities/user.dart';

/// Authentication repository contract for MVVM pattern
abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<User> register(String email, String password, String name);
  Future<void> logout();
  Future<User> getCurrentUser();
  Future<bool> isLoggedIn();
}
''');
  }

  void _createDataLayer() {
    // User Model
    fileWriter.writeFile('lib/data/models/user_model.dart', '''
import '../../domain/entities/user.dart';

/// User data model for MVVM pattern
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
''');

    // Auth Repository Implementation
    fileWriter.writeFile('lib/data/repositories/auth_repository_impl.dart', '''
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
''');
  }

  void _createAuthFeature() {
    _createAuthViewModel();
    _createAuthView();
  }

  void _createAuthViewModel() {
    switch (stateManagement) {
      case StateManagement.bloc:
        _createBlocAuthViewModel();
        break;
      case StateManagement.provider:
        _createProviderAuthViewModel();
        break;
      case StateManagement.riverpod:
        _createRiverpodAuthViewModel();
        break;
      case StateManagement.getx:
        _createGetxAuthViewModel();
        break;
      case StateManagement.stateNotifier:
        _createStateNotifierAuthViewModel();
        break;
    }
  }

  void _createBlocAuthViewModel() {
    // Auth State
    fileWriter
        .writeFile('lib/features/auth/presentation/bloc/auth_state.dart', '''
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
''');

    // Auth Event
    fileWriter
        .writeFile('lib/features/auth/presentation/bloc/auth_event.dart', '''
abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent({required this.email, required this.password});
}

class LogoutEvent extends AuthEvent {}

class CheckAuthStatusEvent extends AuthEvent {}
''');

    // Auth Bloc (ViewModel)
    fileWriter
        .writeFile('lib/features/auth/presentation/bloc/auth_bloc.dart', '''
import 'package:bloc/bloc.dart';
import '../../../../domain/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc({required this.repository}) : super(const AuthState()) {
    on<LoginEvent>(_onLoginEvent);
    on<LogoutEvent>(_onLogoutEvent);
    on<CheckAuthStatusEvent>(_onCheckAuthStatusEvent);
  }

  Future<void> _onLoginEvent(
    LoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));
    
    try {
      final user = await repository.login(event.email, event.password);
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

  void _onLogoutEvent(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) {
    emit(const AuthState());
  }

  void _onCheckAuthStatusEvent(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) {
    // Implement auth status check logic
  }
}
''');
  }

  void _createProviderAuthViewModel() {
    fileWriter.writeFile(
        'lib/features/auth/presentation/provider/auth_provider.dart', '''
import 'package:flutter/foundation.dart';
import '../../../../domain/repositories/auth_repository.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository repository;

  AuthProvider({required this.repository});

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
      final user = await repository.login(email, password);
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

  void _createRiverpodAuthViewModel() {
    // Auth State
    fileWriter.writeFile(
        'lib/features/auth/presentation/notifier/auth_state.dart', '''
/// Auth state for Riverpod in MVVM pattern
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
''');

    // Auth ViewModel
    fileWriter.writeFile(
        'lib/features/auth/presentation/notifier/auth_viewmodel.dart', '''
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthViewModel extends StateNotifier<AuthState> {
  final AuthRepository repository;

  AuthViewModel({required this.repository}) : super(const AuthState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final user = await repository.login(email, password);
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

final authViewModelProvider = StateNotifierProvider<AuthViewModel, AuthState>((ref) {
  return AuthViewModel(repository: AuthRepositoryImpl());
});
''');
  }

  void _createGetxAuthViewModel() {
    fileWriter.writeFile(
        'lib/features/auth/presentation/controller/auth_controller.dart', '''
import 'package:get/get.dart';
import '../../../../domain/repositories/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository repository;

  AuthController({required this.repository});

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
      final user = await repository.login(email, password);
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

  void _createStateNotifierAuthViewModel() {
    // Auth State
    fileWriter.writeFile(
        'lib/features/auth/presentation/notifier/auth_state.dart', '''
/// Auth state for State Notifier in MVVM pattern
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
''');

    // Auth ViewModel
    fileWriter.writeFile(
        'lib/features/auth/presentation/notifier/auth_viewmodel.dart', '''
import 'package:state_notifier/state_notifier.dart';
import '../../../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthViewModel extends StateNotifier<AuthState> {
  final AuthRepository repository;

  AuthViewModel({required this.repository}) : super(const AuthState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final user = await repository.login(email, password);
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
''');
  }

  void _createAuthView() {
    fileWriter
        .writeFile('lib/features/auth/presentation/views/login_view.dart', '''
import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login - MVVM Pattern'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'MVVM Architecture with ${stateManagement.displayName}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement login logic
              },
              child: const Text('Login'),
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
