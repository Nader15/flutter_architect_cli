import '../../utils/file_writer.dart';
import '../commands/create_command.dart';
import 'base_state_management.dart';

//// BLoC state management implementation
class BlocStateManagement extends BaseStateManagement {
  /// File writer utility
  final FileWriter fileWriter;
  /// Constructor
  BlocStateManagement(this.fileWriter) : super(StateManagement.bloc);

  @override
  Map<String, String> get dependencies => {
        'flutter_bloc': '^8.1.3',
        'bloc': '^8.1.2',
        'equatable': '^2.0.5',
      };

  @override
  Map<String, String> get devDependencies => {};

  @override
  String getFolderName() => 'bloc';

  @override
  String getImportStatement() =>
      "import 'package:flutter_bloc/flutter_bloc.dart';";

  @override
  void createCoreFiles(String projectPath) {
    fileWriter.writeFile('lib/core/state_management/bloc_helpers.dart', '''
import 'package:flutter_bloc/flutter_bloc.dart';

/// Helper extensions and utilities for BLoC
extension BlocExtension on Bloc {
  /// Dispose method for clean up
  void dispose() {
    close();
  }
}

/// Base class for all BLoCs
abstract class BaseBloc<Event, State> extends Bloc<Event, State> {
  BaseBloc(State initialState) : super(initialState);
}
''');
  }

  @override
  String createAppWrapper(String projectName, String homeWidget) {
    return '''MultiBlocProvider(
      providers: [
        // Add your Bloc providers here
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
