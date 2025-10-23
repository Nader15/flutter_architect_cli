import '../commands/create_command.dart';
import '../../utils/file_writer.dart';
import 'base_state_management.dart';

/// Provider state management implementation
class ProviderStateManagement extends BaseStateManagement {
  /// File writer utility
  final FileWriter fileWriter;

  /// Constructor
  ProviderStateManagement(this.fileWriter) : super(StateManagement.provider);

  @override
  Map<String, String> get dependencies => {
        'provider': '^6.1.1',
      };

  @override
  Map<String, String> get devDependencies => {};

  @override
  String getFolderName() => 'provider';

  @override
  String getImportStatement() => "import 'package:provider/provider.dart';";

  @override
  void createCoreFiles(String projectPath) {
    fileWriter.writeFile('lib/core/state_management/provider_helpers.dart', '''
import 'package:flutter/foundation.dart';

/// Base class for all Providers
abstract class BaseProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? errorMessage) {
    _error = errorMessage;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
''');
  }

  @override
  String createAppWrapper(String projectName, String homeWidget) {
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
  }

  @override
  String createMainFile() {
    return '''
import 'package:flutter/material.dart';
import 'app.dart';

void main() {
  runApp(const MyApp());
}
''';
  }
}
