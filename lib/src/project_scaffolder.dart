import 'dart:io';
import 'package:path/path.dart' as path;

/// Scaffolds a new Flutter Clean Architecture project
class ProjectScaffolder {
  /// The name of the project to create
  final String projectName;

  /// The directory where the project will be created
  final Directory projectDir;

  /// Creates a new ProjectScaffolder instance
  ProjectScaffolder(this.projectName) : projectDir = Directory(projectName);

  /// Scaffolds the complete project structure
  void scaffold() {
    _createProjectStructure();
    _createPubspecFile();
    _createMainFile();
    _createInjectionContainer();
    _createCoreFiles();
    _createAuthFeature();
  }

  /// Creates the directory structure for the project
  void _createProjectStructure() {
    final directories = [
      'lib/core/constants',
      'lib/core/errors',
      'lib/core/usecases',
      'lib/core/utils',
      'lib/features/auth/data/datasources',
      'lib/features/auth/data/models',
      'lib/features/auth/data/repositories',
      'lib/features/auth/domain/entities',
      'lib/features/auth/domain/repositories',
      'lib/features/auth/domain/usecases',
      'lib/features/auth/presentation/bloc',
      'lib/features/auth/presentation/pages',
      'lib/features/auth/presentation/widgets',
      'test',
    ];

    for (final dir in directories) {
      Directory(path.join(projectName, dir)).createSync(recursive: true);
    }
  }

  /// Creates the pubspec.yaml file
  void _createPubspecFile() {
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
  get_it: ^7.6.4
  equatable: ^2.0.5
  dartz: ^0.10.1
  flutter_bloc: ^8.1.3

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
  build_runner: ^2.4.6
  mockito: ^5.4.2

flutter:
  uses-material-design: true
''';

    _writeFile('pubspec.yaml', content);
  }

  /// Creates the main.dart file
  void _createMainFile() {
    final content = '''
import 'package:flutter/material.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
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
      ),
      home: const Scaffold(
        body: Center(
          child: Text('Welcome to $projectName!'),
        ),
      ),
    );
  }
}
''';

    _writeFile('lib/main.dart', content);
  }

  /// Creates the dependency injection container
  void _createInjectionContainer() {
    final content = '''
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

/// Initializes the dependency injection container
Future<void> init() async {
  // Features - Auth
  // sl.registerFactory(() => AuthBloc(loginUseCase: sl()));
  
  // Use cases
  // sl.registerLazySingleton(() => LoginUseCase(sl()));
  
  // Repository
  // sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(remoteDataSource: sl()));
  
  // Data sources
  // sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl());
  
  // Core
  // sl.registerLazySingleton(() => NetworkInfo());
}

''';

    _writeFile('lib/injection_container.dart', content);
  }

  /// Creates core architecture files
  void _createCoreFiles() {
    // Core Errors
    _writeFile('lib/core/errors/failures.dart', '''
import 'package:equatable/equatable.dart';

/// Abstract base class for all failures
abstract class Failure extends Equatable {
  /// The error message
  final String message;

  /// Creates a new Failure instance
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// Represents server-related failures
class ServerFailure extends Failure {
  /// Creates a new ServerFailure instance
  const ServerFailure(String message) : super(message);
}

/// Represents cache-related failures
class CacheFailure extends Failure {
  /// Creates a new CacheFailure instance
  const CacheFailure(String message) : super(message);
}
''');

    // Core Usecases
    _writeFile('lib/core/usecases/usecase.dart', '''
import 'package:dartz/dartz.dart';
import '../errors/failures.dart';

/// Abstract base class for all use cases
abstract class UseCase<Type, Params> {
  /// Executes the use case
  Future<Either<Failure, Type>> call(Params params);
}

/// Represents no parameters for use cases that don't require any
class NoParams {}
''');

    // Core Constants
    _writeFile('lib/core/constants/app_constants.dart', '''
/// Application-level constants
class AppConstants {
  /// The application name
  static const String appName = '$projectName';
}
''');
  }

  /// Creates authentication feature files
  void _createAuthFeature() {
    // Auth Entity
    _writeFile('lib/features/auth/domain/entities/user.dart', '''
import 'package:equatable/equatable.dart';

/// Represents a user entity
class User extends Equatable {
  /// The user's unique identifier
  final String id;

  /// The user's email address
  final String email;

  /// The user's display name
  final String name;

  /// Creates a new User instance
  const User({
    required this.id,
    required this.email,
    required this.name,
  });

  @override
  List<Object> get props => [id, email, name];
}
''');

    // Auth Repository Interface
    _writeFile('lib/features/auth/domain/repositories/auth_repository.dart', '''
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

/// Abstract interface for authentication repository
abstract class AuthRepository {
  /// Logs in a user with email and password
  Future<Either<Failure, User>> login(String email, String password);
  
  /// Logs out the current user
  Future<Either<Failure, void>> logout();
  
  /// Gets the currently authenticated user
  Future<Either<Failure, User>> getCurrentUser();
}
''');

    // Auth Usecase
    _writeFile('lib/features/auth/domain/usecases/login_usecase.dart', '''
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Use case for user login
class LoginUseCase implements UseCase<User, LoginParams> {
  /// The authentication repository
  final AuthRepository repository;

  /// Creates a new LoginUseCase instance
  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(LoginParams params) async {
    return await repository.login(params.email, params.password);
  }
}

/// Parameters for the login use case
class LoginParams {
  /// The user's email
  final String email;

  /// The user's password
  final String password;

  /// Creates a new LoginParams instance
  LoginParams({required this.email, required this.password});
}
''');
  }

  /// Writes content to a file at the specified relative path
  void _writeFile(String relativePath, String content) {
    final file = File(path.join(projectName, relativePath));
    file.createSync(recursive: true);
    file.writeAsStringSync(content);
  }
}
