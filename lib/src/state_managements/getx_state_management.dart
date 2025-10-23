import '../commands/create_command.dart';
import '../../utils/file_writer.dart';
import 'base_state_management.dart';

/// GetX state management implementation
class GetxStateManagement extends BaseStateManagement {
  /// File writer utility
  final FileWriter fileWriter;

  /// Constructor
  GetxStateManagement(this.fileWriter) : super(StateManagement.getx);

  @override
  Map<String, String> get dependencies => {
        'get': '^4.6.6',
      };

  @override
  Map<String, String> get devDependencies => {};

  @override
  String getFolderName() => 'controller';

  @override
  String getImportStatement() => "import 'package:get/get.dart';";

  @override
  void createCoreFiles(String projectPath) {
    fileWriter.writeFile('lib/core/state_management/getx_helpers.dart', '''
import 'package:get/get.dart';

/// Base class for all GetX Controllers
abstract class BaseController extends GetxController {
  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final RxnString _error = RxnString();
  String? get error => _error.value;

  void setLoading(bool loading) {
    _isLoading.value = loading;
  }

  void setError(String? errorMessage) {
    _error.value = errorMessage;
  }

  void clearError() {
    _error.value = null;
  }

  @override
  void onClose() {
    _isLoading.close();
    _error.close();
    super.onClose();
  }
}
''');
  }

  @override
  String createAppWrapper(String projectName, String homeWidget) {
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
