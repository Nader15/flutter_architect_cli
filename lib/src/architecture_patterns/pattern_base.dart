import '../../utils/file_writer.dart';
import '../commands/create_command.dart';
import '../templates/template_engine.dart';
import '../templates/common_templates.dart';
import '../templates/state_management_templates.dart';
import '../state_managements/base_state_management.dart';
import '../state_managements/state_management_factory.dart';

/// Base class for all architecture patterns with common functionality
abstract class PatternBase {
  /// The name of the project
  late final String projectName;

  /// File writer utility
  final FileWriter fileWriter;

  /// The state management solution to use
  final StateManagement stateManagement;

  /// State management implementation
  late final BaseStateManagement stateManagementImpl;

  /// Template engine for file generation
  late final TemplateEngine templateEngine;

  /// Creates a new PatternBase instance
  PatternBase(this.projectName, this.fileWriter, this.stateManagement) {
    stateManagementImpl =
        StateManagementFactory.create(stateManagement, fileWriter);
    templateEngine = TemplateEngine(
      fileWriter: fileWriter,
      projectName: projectName,
      stateManagement: stateManagement,
    );
  }

  /// Scaffolds the complete project structure
  void scaffold() {
    createStructure();
    createPubspecFile();
    createMainFiles();
    createCoreFiles();
    createStateManagementFiles();
    _printSuccessMessage();
  }

  /// Creates the directory structure - must be implemented by subclasses
  void createStructure();

  /// Creates the pubspec.yaml file with appropriate dependencies
  void createPubspecFile() {
    final dependencies = _getDependencies();
    final devDependencies = _getDevDependencies();

    final dependenciesString =
        dependencies.entries.map((e) => '  ${e.key}: ${e.value}').join('\n');

    final devDependenciesString =
        devDependencies.entries.map((e) => '  ${e.key}: ${e.value}').join('\n');

    templateEngine.writeTemplateFile(
      'pubspec.yaml',
      CommonTemplates.pubspecTemplate,
      {
        'architecturePattern': getArchitecturePatternName(),
        'dependencies': dependenciesString,
        'devDependencies': devDependenciesString,
      },
    );
  }

  /// Creates main application files
  void createMainFiles() {
    // Create main.dart
    templateEngine.writeTemplateFile(
      'lib/main.dart',
      CommonTemplates.mainTemplate,
      {},
    );

    // Create app.dart
    _createAppFile();
  }

  /// Creates core framework files - must be implemented by subclasses
  void createCoreFiles();

  /// Creates state management specific files - must be implemented by subclasses
  void createStateManagementFiles();

  /// Gets the architecture pattern name - must be implemented by subclasses
  String getArchitecturePatternName();

  /// Gets dependencies for the selected state management
  Map<String, String> get stateManagementDependencies =>
      stateManagementImpl.dependencies;

  /// Gets dev dependencies for the selected state management
  Map<String, String> get stateManagementDevDependencies =>
      stateManagementImpl.devDependencies;

  /// Gets all dependencies including state management
  Map<String, String> _getDependencies() {
    return {
      ...stateManagementDependencies,
    };
  }

  /// Gets all dev dependencies including state management
  Map<String, String> _getDevDependencies() {
    return {
      'flutter_lints': '^3.0.0',
      ...stateManagementDevDependencies,
    };
  }

  /// Creates the app.dart file
  void _createAppFile() {
    final appWrapper = StateManagementTemplates.getAppWrapper(
      stateManagement,
      projectName,
      getHomeWidgetName(),
    );

    templateEngine.writeTemplateFile(
      'lib/app.dart',
      CommonTemplates.appTemplate,
      {
        'appWrapper': appWrapper,
        'homePageImport': getHomePageImport(),
      },
    );
  }

  /// Gets the home widget name - must be implemented by subclasses
  String getHomeWidgetName();

  /// Gets the home page import path - must be implemented by subclasses
  String getHomePageImport();

  /// Creates common core files
  void createCommonCoreFiles() {
    _createAppConstants();
    _createValidators();
    _createAppTheme();
  }

  /// Creates app constants file
  void _createAppConstants() {
    templateEngine.writeTemplateFile(
      'lib/core/constants/app_constants.dart',
      CommonTemplates.appConstantsTemplate,
      {},
    );
  }

  /// Creates validators file
  void _createValidators() {
    templateEngine.writeTemplateFile(
      'lib/core/utils/validators.dart',
      CommonTemplates.validatorsTemplate,
      {},
    );
  }

  /// Creates app theme file
  void _createAppTheme() {
    templateEngine.writeTemplateFile(
      'lib/core/theme/app_theme.dart',
      CommonTemplates.appThemeTemplate,
      {},
    );
  }

  /// Creates common auth files
  void createCommonAuthFiles() {
    _createUserEntity();
    _createUserModel();
    _createAuthRepository();
    _createAuthRepositoryImpl();
  }

  /// Creates user entity file
  void _createUserEntity() {
    templateEngine.writeTemplateFile(
      'lib/features/auth/domain/entities/user.dart',
      CommonTemplates.userEntityTemplate,
      {},
    );
  }

  /// Creates user model file
  void _createUserModel() {
    templateEngine.writeTemplateFile(
      'lib/features/auth/data/models/user_model.dart',
      CommonTemplates.userModelTemplate,
      {},
    );
  }

  /// Creates auth repository file
  void _createAuthRepository() {
    templateEngine.writeTemplateFile(
      'lib/features/auth/domain/repositories/auth_repository.dart',
      CommonTemplates.authRepositoryTemplate,
      {},
    );
  }

  /// Creates auth repository implementation file
  void _createAuthRepositoryImpl() {
    templateEngine.writeTemplateFile(
      'lib/features/auth/data/repositories_impl/auth_repository_impl.dart',
      CommonTemplates.authRepositoryImplTemplate,
      {},
    );
  }

  /// Creates state management specific auth files
  void createStateManagementAuthFiles() {
    switch (stateManagement) {
      case StateManagement.bloc:
        _createBlocAuthFiles();
        break;
      case StateManagement.provider:
        _createProviderAuthFiles();
        break;
      case StateManagement.riverpod:
        _createRiverpodAuthFiles();
        break;
      case StateManagement.getx:
        _createGetxAuthFiles();
        break;
    }
  }

  /// Creates BLoC auth files (Cubit-based)
  void _createBlocAuthFiles() {
    final statePath = 'lib/features/auth/presentation/cubit/auth_state.dart';
    final cubitPath = 'lib/features/auth/presentation/cubit/auth_cubit.dart';

    templateEngine.writeTemplateFile(
      statePath,
      StateManagementTemplates.blocAuthStateTemplate,
      {},
    );

    templateEngine.writeTemplateFile(
      cubitPath,
      StateManagementTemplates.blocAuthCubitTemplate,
      {
        'repositoryImport': '../../domain/repositories/auth_repository.dart',
        'repositoryType': 'AuthRepository',
      },
    );
  }

  /// Creates Provider auth files
  void _createProviderAuthFiles() {
    templateEngine.writeTemplateFile(
      'lib/features/auth/presentation/provider/auth_provider.dart',
      StateManagementTemplates.providerAuthProviderTemplate,
      {
        'repositoryImport': '../../domain/repositories/auth_repository.dart',
        'repositoryType': 'AuthRepository',
      },
    );
  }

  /// Creates Riverpod auth files
  void _createRiverpodAuthFiles() {
    templateEngine.writeTemplateFile(
      'lib/features/auth/presentation/notifier/auth_state.dart',
      StateManagementTemplates.riverpodAuthStateTemplate,
      {},
    );

    templateEngine.writeTemplateFile(
      'lib/features/auth/presentation/notifier/auth_notifier.dart',
      StateManagementTemplates.riverpodAuthNotifierTemplate,
      {
        'repositoryImport': '../../domain/repositories/auth_repository.dart',
        'repositoryType': 'AuthRepository',
        'repositoryImpl': 'AuthRepositoryImpl',
      },
    );
  }

  /// Creates GetX auth files
  void _createGetxAuthFiles() {
    templateEngine.writeTemplateFile(
      'lib/features/auth/presentation/controller/auth_controller.dart',
      StateManagementTemplates.getxAuthControllerTemplate,
      {
        'repositoryImport': '../../domain/repositories/auth_repository.dart',
        'repositoryType': 'AuthRepository',
      },
    );
  }

  /// Creates login page
  void createLoginPage() {
    templateEngine.writeTemplateFile(
      'lib/features/auth/presentation/pages/login_page.dart',
      CommonTemplates.loginPageTemplate,
      {},
    );
  }

  /// Prints success message
  void _printSuccessMessage() {
    // ignore: avoid_print
    print('✅ ${getArchitecturePatternName()} project created successfully!');
    // ignore: avoid_print
    print('');
    // ignore: avoid_print
    print('📁 ${getArchitecturePatternName()} Structure:');
    // ignore: avoid_print
    print('');
    printStructureInfo();
    // ignore: avoid_print
    print('');
    // ignore: avoid_print
    print('🎛️  State Management: ${stateManagement.displayName}');
    // ignore: avoid_print
    print('');
    // ignore: avoid_print
    print('📦 Dependencies installed automatically!');
    // ignore: avoid_print
    print('🚀 You can now start developing your app!');
    // ignore: avoid_print
    print('');
  }

  /// Prints structure information - must be implemented by subclasses
  void printStructureInfo();
}
