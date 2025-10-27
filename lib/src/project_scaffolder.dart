import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:flutter_architect_cli/src/commands/create_command.dart';
import '../utils/file_writer.dart';
import 'architecture_patterns/pattern_base.dart';
import 'architecture_patterns/clean_architecture_pattern.dart';
import 'architecture_patterns/mvc_pattern.dart';
import 'architecture_patterns/mvvm_pattern.dart';

/// Scaffolds Flutter projects with different architecture patterns and state management
class ProjectScaffolder {
  /// The name of the project to create
  final String projectName;

  /// The directory where the project will be created
  final Directory projectDir;

  /// The architecture pattern to use
  final ArchitecturePattern pattern;

  /// The state management solution to use
  final StateManagement stateManagement;

  /// File writer utility
  final FileWriter fileWriter;

  /// Creates a new ProjectScaffolder instance
  ProjectScaffolder(
    this.projectName, {
    this.pattern = ArchitecturePattern.cleanArchitecture,
    this.stateManagement = StateManagement.bloc,
  })  : projectDir = Directory(projectName),
        fileWriter = FileWriter(projectName);

  /// Scaffolds the complete project structure based on selected pattern and state management
  void scaffold() {
    // Delete existing lib folder if it exists
    _deleteExistingLibFolder();

    final patternScaffolder = _createPatternScaffolder();
    patternScaffolder.scaffold();

    // Run pub get after scaffolding
    _runPubGet();
  }

  /// Creates the appropriate pattern scaffolder based on selected pattern
  PatternBase _createPatternScaffolder() {
    switch (pattern) {
      case ArchitecturePattern.cleanArchitecture:
        return CleanArchitecturePattern(
            projectName, fileWriter, stateManagement);
      case ArchitecturePattern.mvvm:
        return MvvmPattern(projectName, fileWriter, stateManagement);
      case ArchitecturePattern.mvc:
        return MvcPattern(projectName, fileWriter, stateManagement);
    }
  }

  /// Deletes the existing lib folder if it exists
  void _deleteExistingLibFolder() {
    final libDir = Directory(path.join(projectName, 'lib'));

    if (libDir.existsSync()) {
      // ignore: avoid_print
      print('🗑️  Removing existing lib folder...');
      libDir.deleteSync(recursive: true);
      // ignore: avoid_print
      print('');
      // ignore: avoid_print
      print('✅ Existing lib folder removed');
      // ignore: avoid_print
      print('');
    }
  }

  /// Runs pub get to install dependencies
  void _runPubGet() {
    // ignore: avoid_print
    print('📦 Installing dependencies...');

    final process = Process.runSync(
      'flutter',
      ['pub', 'get'],
      workingDirectory: projectName,
      runInShell: true,
    );

    if (process.exitCode == 0) {
      // ignore: avoid_print
      print('✅ Dependencies installed successfully!');
    } else {
      // ignore: avoid_print
      print('❌ Failed to install dependencies: ${process.stderr}');
      // ignore: avoid_print
      print(
          '💡 You can manually run `flutter pub get` in the project directory.');
    }

    // ignore: avoid_print
    print('');
  }
}
