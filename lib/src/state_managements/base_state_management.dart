import '../../flutter_architect_cli.dart';

/// Base abstract class for state management implementations
abstract class BaseStateManagement {
  /// The selected state management
  final StateManagement stateManagement;

  /// Constructor
  BaseStateManagement(this.stateManagement);

  /// Gets dependencies for the selected state management
  Map<String, String> get dependencies;

  /// Gets dev dependencies for the selected state management
  Map<String, String> get devDependencies;

  /// Creates state management specific core files
  void createCoreFiles(String projectPath);

  /// Gets the folder name for state management files
  String getFolderName();

  /// Gets the state management import statement
  String getImportStatement();

  /// Creates app wrapper with state management
  String createAppWrapper(String projectName, String homeWidget);

  /// Creates main file content
  String createMainFile();
}
