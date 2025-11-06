import 'dart:io';
import 'package:path/path.dart' as path;
import '../../flutter_architect_cli.dart';
import 'pattern_base.dart';

/// Implements MVVM pattern scaffolding with state management
class MvvmPattern extends PatternBase {
  /// Creates a new MvvmPattern instance
  MvvmPattern(super.projectName, super.fileWriter, super.stateManagement,
      {super.organization = 'com.example'});

  @override
  String getArchitecturePatternName() => 'MVVM Pattern';

  @override
  String getHomeWidgetName() => 'HomeView';

  @override
  String getHomePageImport() => 'presentation/views/home_view.dart';

  @override
  void createStructure() {
    final directories = [
      // Core directories
      'lib/core/constants',
      'lib/core/utils',
      'lib/core/theme',
      'lib/core/errors',
      'lib/core/services',

      // Data layer
      'lib/data/datasources/remote',
      'lib/data/datasources/local',
      'lib/data/models',
      'lib/data/repositories',

      // Domain layer
      'lib/domain/entities',
      'lib/domain/repositories',
      'lib/domain/usecases',

      // Presentation layer
      'lib/presentation/views',
      'lib/presentation/viewmodels',
      'lib/presentation/widgets',
      'lib/presentation/state',

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
    _createCoreServices();
    _createDomainLayer();
    _createDataLayer();
    _createPresentationLayer();
  }

  @override
  void createStateManagementFiles() {
    _createViewModels();
    _createViews();
  }

  @override
  void printStructureInfo() {
    // ignore: avoid_print
    print('  - core/         (Shared utilities and constants)');
    // ignore: avoid_print
    print('  - data/         (Data layer with repositories and models)');
    // ignore: avoid_print
    print('  - domain/       (Business logic and entities)');
    // ignore: avoid_print
    print('  - presentation/ (Views, ViewModels and UI components)');
    // ignore: avoid_print
    print('  - shared/       (Shared widgets and helpers)');
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

  void _createCoreServices() {
    fileWriter.writeFile('lib/core/services/navigation_service.dart', '''
/// Navigation service for MVVM pattern
class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  
  NavigationService._internal();
  
  factory NavigationService() => _instance;

  // Add navigation methods here
  void navigateTo(String route) {
    // Implementation depends on your navigation solution
  }
  
  void goBack() {
    // Implementation depends on your navigation solution
  }
}
''');

    fileWriter.writeFile('lib/core/services/api_service.dart', '''
/// API service for MVVM pattern
class ApiService {
  static final ApiService _instance = ApiService._internal();
  
  ApiService._internal();
  
  factory ApiService() => _instance;

  Future<Map<String, dynamic>> get(String url) async {
    // Implement API call logic
    return {};
  }
  
  Future<Map<String, dynamic>> post(String url, Map<String, dynamic> data) async {
    // Implement API call logic
    return {};
  }
}
''');
  }

  void _createDomainLayer() {
    // User Entity
    fileWriter.writeFile('lib/domain/entities/user_entity.dart', '''
/// User entity for MVVM pattern
class UserEntity {
  final String id;
  final String email;
  final String name;
  final String? profileImage;

  UserEntity({
    required this.id,
    required this.email,
    required this.name,
    this.profileImage,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
''');

    // User Repository Interface
    fileWriter.writeFile('lib/domain/repositories/user_repository.dart', '''
import '../entities/user_entity.dart';

/// User repository contract for MVVM pattern
abstract class UserRepository {
  Future<UserEntity> getUserById(String id);
  Future<List<UserEntity>> getUsers();
  Future<UserEntity> updateUser(UserEntity user);
  Future<bool> deleteUser(String id);
}
''');

    // Auth Repository Interface
    fileWriter.writeFile('lib/domain/repositories/auth_repository.dart', '''
import '../entities/user_entity.dart';

/// Authentication repository contract for MVVM pattern
abstract class AuthRepository {
  Future<UserEntity> login(String email, String password);
  Future<UserEntity> register(String email, String password, String name);
  Future<void> logout();
  Future<UserEntity> getCurrentUser();
  Future<bool> isLoggedIn();
}
''');

    // Use Cases
    fileWriter.writeFile('lib/domain/usecases/get_users_usecase.dart', '''
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

/// Use case for getting users
class GetUsersUseCase {
  final UserRepository repository;

  GetUsersUseCase({required this.repository});

  Future<List<UserEntity>> call() async {
    return await repository.getUsers();
  }
}
''');

    fileWriter.writeFile('lib/domain/usecases/get_user_by_id_usecase.dart', '''
import '../entities/user_entity.dart';
import '../repositories/user_repository.dart';

/// Use case for getting user by ID
class GetUserByIdUseCase {
  final UserRepository repository;

  GetUserByIdUseCase({required this.repository});

  Future<UserEntity> call(String id) async {
    return await repository.getUserById(id);
  }
}
''');

    fileWriter.writeFile('lib/domain/usecases/login_usecase.dart', '''
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Use case for user login
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase({required this.repository});

  Future<UserEntity> call(String email, String password) async {
    return await repository.login(email, password);
  }
}
''');
  }

  void _createDataLayer() {
    // User Model
    fileWriter.writeFile('lib/data/models/user_model.dart', '''
import '../../domain/entities/user_entity.dart';

/// User data model for MVVM pattern
class UserModel extends UserEntity {
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

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      name: name,
      profileImage: profileImage,
    );
  }
}
''');

    // User Repository Implementation
    fileWriter.writeFile('lib/data/repositories/user_repository_impl.dart', '''
import '../../domain/repositories/user_repository.dart';
import '../../domain/entities/user_entity.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  @override
  Future<UserEntity> getUserById(String id) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    return UserModel(
      id: id,
      email: 'user\$id@example.com',
      name: 'User \$id',
    );
  }

  @override
  Future<List<UserEntity>> getUsers() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    return [
      UserModel(id: '1', email: 'user1@example.com', name: 'User One'),
      UserModel(id: '2', email: 'user2@example.com', name: 'User Two'),
      UserModel(id: '3', email: 'user3@example.com', name: 'User Three'),
    ];
  }

  @override
  Future<UserEntity> updateUser(UserEntity user) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    return UserModel(
      id: user.id,
      email: user.email,
      name: user.name,
      profileImage: user.profileImage,
    );
  }

  @override
  Future<bool> deleteUser(String id) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}
''');

    // Auth Repository Implementation
    fileWriter.writeFile('lib/data/repositories/auth_repository_impl.dart', '''
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user_entity.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<UserEntity> login(String email, String password) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    return UserModel(
      id: '1',
      email: email,
      name: 'Test User',
    );
  }

  @override
  Future<UserEntity> register(String email, String password, String name) async {
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
  Future<UserEntity> getCurrentUser() async {
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

    // Data Sources
    fileWriter.writeFile(
        'lib/data/datasources/remote/user_remote_datasource.dart', '''
import '../../models/user_model.dart';

/// Remote data source for user data
class UserRemoteDataSource {
  Future<List<UserModel>> getUsers() async {
    // Implement actual API call
    await Future.delayed(const Duration(seconds: 2));
    return [
      UserModel(id: '1', email: 'user1@example.com', name: 'User One'),
      UserModel(id: '2', email: 'user2@example.com', name: 'User Two'),
    ];
  }

  Future<UserModel> getUserById(String id) async {
    // Implement actual API call
    await Future.delayed(const Duration(seconds: 1));
    return UserModel(
      id: id,
      email: 'user\$id@example.com',
      name: 'User \$id',
    );
  }
}
''');

    fileWriter
        .writeFile('lib/data/datasources/local/user_local_datasource.dart', '''
import '../../models/user_model.dart';

/// Local data source for user data
class UserLocalDataSource {
  Future<void> cacheUsers(List<UserModel> users) async {
    // Implement local caching
  }

  Future<List<UserModel>> getCachedUsers() async {
    // Implement getting cached data
    return [];
  }
}
''');
  }

  void _createPresentationLayer() {
    // Common Widgets
    fileWriter.writeFile('lib/presentation/widgets/user_list_item.dart', '''
import 'package:flutter/material.dart';
import '../../domain/entities/user_entity.dart';

class UserListItem extends StatelessWidget {
  final UserEntity user;
  final VoidCallback? onTap;

  const UserListItem({
    super.key,
    required this.user,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue,
        child: Text(
          user.name[0].toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(user.name),
      subtitle: Text(user.email),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}
''');

    fileWriter.writeFile('lib/presentation/widgets/loading_widget.dart', '''
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final String message;

  const LoadingWidget({
    super.key,
    this.message = 'Loading...',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(message),
        ],
      ),
    );
  }
}
''');

    fileWriter.writeFile('lib/presentation/widgets/error_widget.dart', '''
import 'package:flutter/material.dart';

class ErrorDisplayWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorDisplayWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
''');
  }

  void _createViewModels() {
    switch (stateManagement) {
      case StateManagement.bloc:
        _createCubitViewModels();
        break;
      case StateManagement.provider:
        _createProviderViewModels();
        break;
      case StateManagement.riverpod:
        _createRiverpodViewModels();
        break;
      case StateManagement.getx:
        _createGetxViewModels();
        break;
    }
  }

  void _createCubitViewModels() {
    // User State
    fileWriter.writeFile('lib/presentation/state/user_state.dart', '''
import '../../domain/entities/user_entity.dart';

class UserState {
  final bool isLoading;
  final String? error;
  final List<UserEntity> users;
  final UserEntity? selectedUser;

  const UserState({
    this.isLoading = false,
    this.error,
    this.users = const [],
    this.selectedUser,
  });

  UserState copyWith({
    bool? isLoading,
    String? error,
    List<UserEntity>? users,
    UserEntity? selectedUser,
  }) {
    return UserState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      users: users ?? this.users,
      selectedUser: selectedUser ?? this.selectedUser,
    );
  }
}
''');

    // User Cubit (ViewModel)
    fileWriter.writeFile('lib/presentation/viewmodels/user_cubit.dart', '''
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_users_usecase.dart';
import '../../domain/usecases/get_user_by_id_usecase.dart';
import '../state/user_state.dart';

class UserCubit extends Cubit<UserState> {
  final GetUsersUseCase getUsersUseCase;
  final GetUserByIdUseCase getUserByIdUseCase;

  UserCubit({
    required this.getUsersUseCase,
    required this.getUserByIdUseCase,
  }) : super(const UserState());

  /// Load all users
  Future<void> loadUsers() async {
    emit(state.copyWith(isLoading: true, error: null));
    
    try {
      final users = await getUsersUseCase();
      emit(state.copyWith(
        isLoading: false,
        users: users,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Failed to load users: \$e',
      ));
    }
  }

  /// Load user by ID
  Future<void> loadUserById(String userId) async {
    emit(state.copyWith(isLoading: true, error: null));
    
    try {
      final user = await getUserByIdUseCase(userId);
      emit(state.copyWith(
        isLoading: false,
        selectedUser: user,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Failed to load user: \$e',
      ));
    }
  }

  /// Select user from the current list
  void selectUser(String userId) {
    final user = state.users.firstWhere(
      (user) => user.id == userId,
      orElse: () => state.users.first,
    );
    emit(state.copyWith(selectedUser: user));
  }

  /// Clear error
  void clearError() {
    emit(state.copyWith(error: null));
  }

  /// Refresh users
  Future<void> refreshUsers() async {
    await loadUsers();
  }
}
''');

    // Auth State
    fileWriter.writeFile('lib/presentation/state/auth_state.dart', '''
import '../../domain/entities/user_entity.dart';

class AuthState {
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;
  final UserEntity? currentUser;

  const AuthState({
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
    this.currentUser,
  });

  AuthState copyWith({
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
    UserEntity? currentUser,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      currentUser: currentUser ?? this.currentUser,
    );
  }
}
''');

    // Auth Cubit for authentication
    fileWriter.writeFile('lib/presentation/viewmodels/auth_cubit.dart', '''
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repository.dart';
import '../state/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  AuthCubit({required this.authRepository}) : super(const AuthState());

  /// Login user
  Future<void> login(String email, String password) async {
    emit(state.copyWith(isLoading: true, error: null));
    
    try {
      final user = await authRepository.login(email, password);
      emit(state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        currentUser: user,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Login failed: \$e',
        isAuthenticated: false,
      ));
    }
  }

  /// Register user
  Future<void> register(String email, String password, String name) async {
    emit(state.copyWith(isLoading: true, error: null));
    
    try {
      final user = await authRepository.register(email, password, name);
      emit(state.copyWith(
        isLoading: false,
        isAuthenticated: true,
        currentUser: user,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Registration failed: \$e',
        isAuthenticated: false,
      ));
    }
  }

  /// Logout user
  Future<void> logout() async {
    emit(state.copyWith(isLoading: true));
    
    try {
      await authRepository.logout();
      emit(const AuthState());
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Logout failed: \$e',
      ));
    }
  }

  /// Check authentication status
  Future<void> checkAuthStatus() async {
    emit(state.copyWith(isLoading: true));
    
    try {
      final isLoggedIn = await authRepository.isLoggedIn();
      if (isLoggedIn) {
        final user = await authRepository.getCurrentUser();
        emit(state.copyWith(
          isLoading: false,
          isAuthenticated: true,
          currentUser: user,
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          isAuthenticated: false,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Auth check failed: \$e',
      ));
    }
  }

  /// Clear error
  void clearError() {
    emit(state.copyWith(error: null));
  }
}
''');
  }

  void _createProviderViewModels() {
    fileWriter.writeFile('lib/presentation/viewmodels/user_viewmodel.dart', '''
import 'package:flutter/foundation.dart';
import '../../domain/usecases/get_users_usecase.dart';
import '../../domain/usecases/get_user_by_id_usecase.dart';
import '../../domain/entities/user_entity.dart';

class UserViewModel with ChangeNotifier {
  final GetUsersUseCase getUsersUseCase;
  final GetUserByIdUseCase getUserByIdUseCase;

  UserViewModel({
    required this.getUsersUseCase,
    required this.getUserByIdUseCase,
  });

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  List<UserEntity> _users = [];
  List<UserEntity> get users => _users;

  UserEntity? _selectedUser;
  UserEntity? get selectedUser => _selectedUser;

  Future<void> loadUsers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _users = await getUsersUseCase();
      _error = null;
    } catch (e) {
      _error = 'Failed to load users: \$e';
      _users = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadUserById(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedUser = await getUserByIdUseCase(userId);
      _error = null;
    } catch (e) {
      _error = 'Failed to load user: \$e';
      _selectedUser = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectUser(String userId) {
    _selectedUser = _users.firstWhere(
      (user) => user.id == userId,
      orElse: () => _users.first,
    );
    notifyListeners();
  }
}
''');
  }

  void _createRiverpodViewModels() {
    // User State
    fileWriter.writeFile('lib/presentation/state/user_state.dart', '''
import '../../domain/entities/user_entity.dart';

class UserState {
  final bool isLoading;
  final String? error;
  final List<UserEntity> users;
  final UserEntity? selectedUser;

  const UserState({
    this.isLoading = false,
    this.error,
    this.users = const [],
    this.selectedUser,
  });

  UserState copyWith({
    bool? isLoading,
    String? error,
    List<UserEntity>? users,
    UserEntity? selectedUser,
  }) {
    return UserState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      users: users ?? this.users,
      selectedUser: selectedUser ?? this.selectedUser,
    );
  }
}
''');

    // User ViewModel
    fileWriter.writeFile('lib/presentation/viewmodels/user_viewmodel.dart', '''
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/usecases/get_users_usecase.dart';
import '../../domain/usecases/get_user_by_id_usecase.dart';
import '../state/user_state.dart';

class UserViewModel extends StateNotifier<UserState> {
  final GetUsersUseCase getUsersUseCase;
  final GetUserByIdUseCase getUserByIdUseCase;

  UserViewModel({
    required this.getUsersUseCase,
    required this.getUserByIdUseCase,
  }) : super(const UserState());

  Future<void> loadUsers() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final users = await getUsersUseCase();
      state = state.copyWith(
        isLoading: false,
        users: users,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load users: \$e',
      );
    }
  }

  Future<void> loadUserById(String userId) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final user = await getUserByIdUseCase(userId);
      state = state.copyWith(
        isLoading: false,
        selectedUser: user,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load user: \$e',
      );
    }
  }

  void selectUser(String userId) {
    final user = state.users.firstWhere(
      (user) => user.id == userId,
      orElse: () => state.users.first,
    );
    state = state.copyWith(selectedUser: user);
  }
}

final userViewModelProvider = StateNotifierProvider<UserViewModel, UserState>((ref) {
  final repository = UserRepositoryImpl();
  return UserViewModel(
    getUsersUseCase: GetUsersUseCase(repository: repository),
    getUserByIdUseCase: GetUserByIdUseCase(repository: repository),
  );
});
''');
  }

  void _createGetxViewModels() {
    fileWriter.writeFile('lib/presentation/viewmodels/user_controller.dart', '''
import 'package:get/get.dart';
import '../../domain/usecases/get_users_usecase.dart';
import '../../domain/usecases/get_user_by_id_usecase.dart';
import '../../domain/entities/user_entity.dart';

class UserController extends GetxController {
  final GetUsersUseCase getUsersUseCase;
  final GetUserByIdUseCase getUserByIdUseCase;

  UserController({
    required this.getUsersUseCase,
    required this.getUserByIdUseCase,
  });

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final RxnString _error = RxnString();
  String? get error => _error.value;

  final RxList<UserEntity> _users = <UserEntity>[].obs;
  List<UserEntity> get users => _users;

  final Rxn<UserEntity> _selectedUser = Rxn<UserEntity>();
  UserEntity? get selectedUser => _selectedUser.value;

  Future<void> loadUsers() async {
    _isLoading.value = true;
    _error.value = null;

    try {
      final result = await getUsersUseCase();
      _users.value = result;
      _error.value = null;
    } catch (e) {
      _error.value = 'Failed to load users: \$e';
      _users.value = [];
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> loadUserById(String userId) async {
    _isLoading.value = true;
    _error.value = null;

    try {
      final user = await getUserByIdUseCase(userId);
      _selectedUser.value = user;
      _error.value = null;
    } catch (e) {
      _error.value = 'Failed to load user: \$e';
      _selectedUser.value = null;
    } finally {
      _isLoading.value = false;
    }
  }

  void selectUser(String userId) {
    _selectedUser.value = _users.firstWhere(
      (user) => user.id == userId,
      orElse: () => _users.first,
    );
  }
}
''');
  }

  void _createViews() {
    _createHomeView();
    _createUserDetailView();
    _createUsersView();
  }

  void _createHomeView() {
    fileWriter.writeFile('lib/presentation/views/home_view.dart', '''
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MVVM Pattern - Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'MVVM Architecture with ${stateManagement.displayName}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Project Structure:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            _buildStructureInfo(),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // TODO: Navigate to users view
              },
              child: const Text('View Users'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStructureInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStructureItem('• core/ - Shared utilities and constants'),
        _buildStructureItem('• data/ - Data layer with repositories and models'),
        _buildStructureItem('• domain/ - Business logic and entities'),
        _buildStructureItem('• presentation/ - Views, ViewModels and UI'),
        _buildStructureItem('• shared/ - Shared widgets and helpers'),
      ],
    );
  }

  Widget _buildStructureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}
''');
  }

  void _createUserDetailView() {
    fileWriter.writeFile('lib/presentation/views/user_detail_view.dart', '''
import 'package:flutter/material.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';

class UserDetailView extends StatelessWidget {
  final String userId;

  const UserDetailView({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TODO: Implement user details with ViewModel
            const Text(
              'User Details View',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('User ID: \$userId'),
            const SizedBox(height: 16),
            const Text('This view will display user details using the MVVM pattern.'),
          ],
        ),
      ),
    );
  }
}
''');
  }

  void _createUsersView() {
    fileWriter.writeFile('lib/presentation/views/users_view.dart', '''
import 'package:flutter/material.dart';
import '../../domain/entities/user_entity.dart';
import '../widgets/user_list_item.dart';

class UsersView extends StatelessWidget {
  const UsersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Users List',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('This view demonstrates MVVM with Cubit as ViewModel.'),
            const SizedBox(height: 16),
            // TODO: Implement BlocConsumer or BlocBuilder for Cubit
            Expanded(
              child: ListView(
                children: [
                  // Example user items
                  UserListItem(
                    user: UserEntity(id: '1', email: 'user1@example.com', name: 'User One'),
                    onTap: () {
                      // Navigate to user details
                    },
                  ),
                  UserListItem(
                    user: UserEntity(id: '2', email: 'user2@example.com', name: 'User Two'),
                    onTap: () {
                      // Navigate to user details
                    },
                  ),
                  UserListItem(
                    user: UserEntity(id: '3', email: 'user3@example.com', name: 'User Three'),
                    onTap: () {
                      // Navigate to user details
                    },
                  ),
                ],
              ),
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
