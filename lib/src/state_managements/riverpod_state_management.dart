import '../commands/create_command.dart';
import '../../utils/file_writer.dart';
import 'base_state_management.dart';

/// Riverpod state management implementation
class RiverpodStateManagement extends BaseStateManagement {
  /// File writer utility
  final FileWriter fileWriter;
  /// Constructor
  RiverpodStateManagement(this.fileWriter) : super(StateManagement.riverpod);

  @override
  Map<String, String> get dependencies => {
        'flutter_riverpod': '^2.4.9',
        'riverpod_annotation': '^2.3.2',
      };

  @override
  Map<String, String> get devDependencies => {
        'riverpod_generator': '^2.3.4',
        'build_runner': '^2.4.7',
      };

  @override
  String getFolderName() => 'notifier';

  @override
  String getImportStatement() =>
      "import 'package:flutter_riverpod/flutter_riverpod.dart';";

  @override
  void createCoreFiles(String projectPath) {
    fileWriter.writeFile('lib/core/state_management/riverpod_helpers.dart', '''
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Base class for all Riverpod Notifiers
abstract class BaseNotifier<T> extends StateNotifier<T> {
  BaseNotifier(T state) : super(state);

  /// Helper method to update state
  void updateState(T newState) {
    state = newState;
  }
}

/// Async Notifier base class
abstract class BaseAsyncNotifier<T> extends AsyncNotifier<T> {
  @override
  Future<T> build();
}
''');
  }

  @override
  String createAppWrapper(String projectName, String homeWidget) {
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
