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

  /// The organization/package name
  final String organization;

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
    this.organization = 'com.example',
    this.pattern = ArchitecturePattern.cleanArchitecture,
    this.stateManagement = StateManagement.bloc,
  })  : projectDir = Directory(projectName),
        fileWriter = FileWriter(projectName);

  /// Scaffolds the complete project structure based on selected pattern and state management
  void scaffold() {
    // Step 1: Create a complete Flutter project first
    _createFlutterProject();

    // Step 2: Replace the default lib structure with our architecture
    _replaceLibStructure();

    // Step 3: Update pubspec.yaml with our dependencies
    _updatePubspecWithDependencies();

    // Step 4: Run pub get
    _runPubGet();

    // Step 5: Print completion message
    _printCompletionMessage();
  }

  /// Creates a complete Flutter project using flutter create
  void _createFlutterProject() {
    // ignore: avoid_print
    print('📱 Creating base Flutter project...');

    final process = Process.runSync(
      'flutter',
      [
        'create',
        '--org',
        organization,
        '--project-name',
        projectName,
        projectName
      ],
      runInShell: true,
    );

    if (process.exitCode != 0) {
      throw Exception('Failed to create Flutter project: ${process.stderr}');
    }

    // ignore: avoid_print
    print('✅ Base Flutter project created successfully!');
  }

  /// Replaces the default lib structure with our architecture pattern
  void _replaceLibStructure() {
    // ignore: avoid_print
    print('🏗️  Applying ${pattern.displayName} architecture...');

    // Delete the default lib folder
    final libDir = Directory(path.join(projectName, 'lib'));
    if (libDir.existsSync()) {
      libDir.deleteSync(recursive: true);
    }

    // Create our architecture pattern
    final patternScaffolder = _createPatternScaffolder();
    patternScaffolder.scaffold();

    // ignore: avoid_print
    print('✅ Architecture applied successfully!');
  }

  /// Updates pubspec.yaml with our architecture dependencies
  void _updatePubspecWithDependencies() {
    // ignore: avoid_print
    print('📦 Configuring dependencies...');

    final patternScaffolder = _createPatternScaffolder();

    // Get the updated pubspec content from the pattern
    // This will replace the default pubspec with our architecture-specific one
    final pubspecFile = File(path.join(projectName, 'pubspec.yaml'));
    if (pubspecFile.existsSync()) {
      pubspecFile.deleteSync();
    }

    // Let the pattern create the pubspec file
    patternScaffolder.createPubspecFile();

    // ignore: avoid_print
    print('✅ Dependencies configured!');
  }

  /// Creates the appropriate pattern scaffolder based on selected pattern
  PatternBase _createPatternScaffolder() {
    switch (pattern) {
      case ArchitecturePattern.cleanArchitecture:
        return CleanArchitecturePattern(
            projectName, fileWriter, stateManagement,
            organization: organization);
      case ArchitecturePattern.mvvm:
        return MvvmPattern(projectName, fileWriter, stateManagement,
            organization: organization);
      case ArchitecturePattern.mvc:
        return MvcPattern(projectName, fileWriter, stateManagement,
            organization: organization);
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
  }

  /// Prints completion message
  void _printCompletionMessage() {
    // ignore: avoid_print
    print('');
    // ignore: avoid_print
    print('🎉 Project created successfully!');
    // ignore: avoid_print
    print('');
    // ignore: avoid_print
    print('📱 Platform folders generated:');
    // ignore: avoid_print
    print('   ✅ android/ - Android platform code');
    // ignore: avoid_print
    print('   ✅ ios/     - iOS platform code');
    // ignore: avoid_print
    print('   ✅ web/     - Web platform code');
    // ignore: avoid_print
    print('   ✅ windows/ - Windows desktop code');
    // ignore: avoid_print
    print('   ✅ macos/   - macOS desktop code');
    // ignore: avoid_print
    print('   ✅ linux/   - Linux desktop code');
    // ignore: avoid_print
    print('');
    // ignore: avoid_print
    print('🏗️  Architecture applied: ${pattern.displayName}');
    // ignore: avoid_print
    print('🎛️  State Management: ${stateManagement.displayName}');
    // ignore: avoid_print
    print('🏢 Organization: $organization');
    // ignore: avoid_print
    print('');
    // ignore: avoid_print
    print('🚀 Next steps:');
    // ignore: avoid_print
    print('   cd $projectName');
    // ignore: avoid_print
    print('   flutter run');
    // ignore: avoid_print
    print('');
  }
}
