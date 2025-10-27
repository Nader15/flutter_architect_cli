import '../commands/create_command.dart';

/// State management specific templates
class StateManagementTemplates {
  /// BLoC Auth State template (for Cubit)
  static const String blocAuthStateTemplate = '''
part of 'auth_cubit.dart';

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
''';

  /// BLoC Auth Cubit template
  static const String blocAuthCubitTemplate = '''
import 'package:flutter_bloc/flutter_bloc.dart';
import '{{repositoryImport}}';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final {{repositoryType}} repository;

  AuthCubit({required this.repository}) : super(const AuthState());

  Future<void> login(String email, String password) async {
    emit(state.copyWith(isLoading: true, error: null));
    
    try {
      final user = await repository.login(email, password);
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

  Future<void> register(String email, String password, String name) async {
    emit(state.copyWith(isLoading: true, error: null));
    
    try {
      final user = await repository.register(email, password, name);
      emit(state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        userEmail: user.email,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Registration failed: \$e',
      ));
    }
  }

  Future<void> logout() async {
    emit(state.copyWith(isLoading: true));
    
    try {
      await repository.logout();
      emit(const AuthState());
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Logout failed: \$e',
      ));
    }
  }

  Future<void> checkAuthStatus() async {
    emit(state.copyWith(isLoading: true));
    
    try {
      final isLoggedIn = await repository.isLoggedIn();
      if (isLoggedIn) {
        final user = await repository.getCurrentUser();
        emit(state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          userEmail: user.email,
        ));
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Auth check failed: \$e',
      ));
    }
  }

  void clearError() {
    emit(state.copyWith(error: null));
  }
}
''';

  /// Provider Auth Provider template
  static const String providerAuthProviderTemplate = '''
import 'package:flutter/foundation.dart';
import '{{repositoryImport}}';

class AuthProvider with ChangeNotifier {
  final {{repositoryType}} repository;

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
''';

  /// Riverpod Auth State template
  static const String riverpodAuthStateTemplate = '''
/// Auth state for Riverpod
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
''';

  /// Riverpod Auth Notifier template
  static const String riverpodAuthNotifierTemplate = '''
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '{{repositoryImport}}';
import '../../data/repositories_impl/auth_repository_impl.dart';
import 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final {{repositoryType}} repository;

  AuthNotifier({required this.repository}) : super(const AuthState());

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

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(repository: {{repositoryImpl}}());
});
''';

  /// GetX Auth Controller template
  static const String getxAuthControllerTemplate = '''
import 'package:get/get.dart';
import '{{repositoryImport}}';

class AuthController extends GetxController {
  final {{repositoryType}} repository;

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
''';

  /// StateNotifier Auth State template
  static const String stateNotifierAuthStateTemplate = '''
/// Auth state for State Notifier
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
''';

  /// StateNotifier Auth Notifier template
  static const String stateNotifierAuthNotifierTemplate = '''
import 'package:state_notifier/state_notifier.dart';
import '{{repositoryImport}}';
import 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final {{repositoryType}} repository;

  AuthNotifier({required this.repository}) : super(const AuthState());

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
''';

  /// Get app wrapper based on state management
  static String getAppWrapper(
      StateManagement stateManagement, String projectName, String homeWidget) {
    switch (stateManagement) {
      case StateManagement.bloc:
        return '''MultiBlocProvider(
      providers: [
        // Add your Cubit providers here
        // BlocProvider<AuthCubit>(create: (context) => AuthCubit(repository: AuthRepositoryImpl())),
      ],
      child: MaterialApp(
        title: '$projectName',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const $homeWidget(),
        debugShowCheckedModeBanner: false,
      ),
    )''';
      case StateManagement.provider:
        return '''MultiProvider(
      providers: [
        // Add your Provider providers here
      ],
      child: MaterialApp(
        title: '$projectName',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const $homeWidget(),
        debugShowCheckedModeBanner: false,
      ),
    )''';
      case StateManagement.riverpod:
        return '''ProviderScope(
      child: MaterialApp(
        title: '$projectName',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const $homeWidget(),
        debugShowCheckedModeBanner: false,
      ),
    )''';
      case StateManagement.getx:
        return '''GetMaterialApp(
      title: '$projectName',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const $homeWidget(),
      debugShowCheckedModeBanner: false,
    )''';
    }
  }
}
