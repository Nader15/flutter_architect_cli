import '../commands/create_command.dart';
import '../../utils/file_writer.dart';
import 'base_state_management.dart';

/// StateNotifier state management implementation
class StateNotifierStateManagement extends BaseStateManagement {
  /// File writer utility
  final FileWriter fileWriter;
  /// Constructor
  StateNotifierStateManagement(this.fileWriter)
      : super(StateManagement.stateNotifier);

  @override
  Map<String, String> get dependencies => {
        'state_notifier': '^1.0.1',
        'flutter_state_notifier': '^1.0.1',
      };

  @override
  Map<String, String> get devDependencies => {};

  @override
  String getFolderName() => 'notifier';

  @override
  String getImportStatement() =>
      "import 'package:flutter_state_notifier/flutter_state_notifier.dart';";

  @override
  void createCoreFiles(String projectPath) {
    fileWriter
        .writeFile('lib/core/state_management/state_notifier_helpers.dart', '''
import 'package:state_notifier/state_notifier.dart';

/// Base class for all State Notifiers
abstract class BaseStateNotifier<T> extends StateNotifier<T> {
  BaseStateNotifier(T state) : super(state);

  /// Helper method to update state
  void updateState(T newState) {
    state = newState;
  }
}
''');
  }

  @override
  String createAppWrapper(String projectName, String homeWidget) {
    return '''MultiStateNotifierProvider(
      providers: [
        // Add your StateNotifier providers here
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
