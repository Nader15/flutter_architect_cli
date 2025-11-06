import 'dart:io';
import 'package:path/path.dart' as path;
import 'pattern_base.dart';

/// Implements Clean Architecture pattern scaffolding with state management
class CleanArchitecturePattern extends PatternBase {
  /// Creates a new CleanArchitecturePattern instance
  CleanArchitecturePattern(
      super.projectName, super.fileWriter, super.stateManagement,
      {super.organization = 'com.example'});

  @override
  String getArchitecturePatternName() => 'Clean Architecture';

  @override
  String getHomeWidgetName() => 'LoginPage';

  @override
  String getHomePageImport() =>
      'features/auth/presentation/pages/login_page.dart';

  @override
  void createStructure() {
    final directories = [
      // Core directories
      'lib/core/error',
      'lib/core/network',
      'lib/core/utils',
      'lib/core/constants',
      'lib/core/theme',
      'lib/core/di',
      'lib/core/state_management',

      // Auth feature directories
      'lib/features/auth/presentation/pages',
      'lib/features/auth/presentation/widgets',
      'lib/features/auth/presentation/${templateEngine.getStateManagementFolder()}',
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

  @override
  void createCoreFiles() {
    createCommonCoreFiles();
    _createCoreError();
    _createCoreNetwork();
    _createCoreDI();
  }

  @override
  void createStateManagementFiles() {
    // Delegate to state management implementation
    stateManagementImpl.createCoreFiles(projectName);
    createCommonAuthFiles();
    createStateManagementAuthFiles();
    createLoginPage();
  }

  @override
  void printStructureInfo() {
    // ignore: avoid_print
    print('  - core/     (Shared application code)');
    // ignore: avoid_print
    print('  - features/ (Feature-based organization)');
    // ignore: avoid_print
    print('  - app.dart  (App configuration)');
    // ignore: avoid_print
    print('  - main.dart (Entry point)');
  }

  void _createCoreError() {
    fileWriter.writeFile('lib/core/error/failures.dart', '''
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

    fileWriter.writeFile('lib/core/error/exceptions.dart', '''
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
  }

  void _createCoreNetwork() {
    fileWriter.writeFile('lib/core/network/network_info.dart', '''
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

    fileWriter.writeFile('lib/core/network/api_client.dart', '''
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

  void _createCoreDI() {
    fileWriter.writeFile('lib/core/di/injection_container.dart', '''
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
}
