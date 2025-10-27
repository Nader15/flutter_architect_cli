import 'dart:io';
import 'package:args/args.dart';
import '../../flutter_architect_cli.dart';

/// Architecture patterns available for Flutter projects
/// Supported architecture patterns for project scaffolding.
enum ArchitecturePattern {
  /// Clean Architecture pattern option
  cleanArchitecture('Clean Architecture Pattern'),

  /// Model-View-Controller pattern option
  mvc('MVC Pattern'),

  /// Model-View-ViewModel pattern option
  mvvm('MVVM Pattern');

  const ArchitecturePattern(this.displayName);

  /// Human-readable name for the pattern
  final String displayName;
}

/// State Management solutions available for Flutter projects
enum StateManagement {
  /// BLoC (Cubit) state management
  bloc('BLoC (Cubit)'),

  /// Provider state management
  provider('Provider'),

  /// Riverpod state management
  riverpod('Riverpod'),

  /// GetX state management
  getx('GetX');

  const StateManagement(this.displayName);

  /// Human-readable name for the state management
  final String displayName;
}

/// Command to create a new Flutter project with selected architecture pattern and state management.
///
/// This command scaffolds the complete folder structure and foundational
/// files for a Flutter project with the chosen architecture pattern and state management.
class CreateCommand implements Command {
  /// Creates a new [CreateCommand] instance.
  CreateCommand();

  @override
  void execute(ArgResults results) {
    final projectName =
        results.rest.isNotEmpty ? results.rest[0] : 'my_flutter_app';

    // ignore: avoid_print
    print('');
    // ignore: avoid_print
    print('🚀 Creating Flutter project: $projectName');
    // ignore: avoid_print
    print('');

    // Show architecture pattern selection menu
    final selectedPattern = _selectArchitecturePattern();

    // Show state management selection menu
    final selectedStateManagement = _selectStateManagement();

    // ignore: avoid_print
    print('');
    // ignore: avoid_print
    print('🎯 Selected Architecture: ${selectedPattern.displayName}');
    // ignore: avoid_print
    print(
        '🎯 Selected State Management: ${selectedStateManagement.displayName}');
    // ignore: avoid_print
    print('');

    final scaffolder = ProjectScaffolder(
      projectName,
      pattern: selectedPattern,
      stateManagement: selectedStateManagement,
    );
    scaffolder.scaffold();
  }

  /// Displays architecture pattern selection menu and returns user's choice
  ArchitecturePattern _selectArchitecturePattern() {
    // ignore: avoid_print
    print('📁 Please select an architecture pattern:');
    // ignore: avoid_print
    print('');

    for (int i = 0; i < ArchitecturePattern.values.length; i++) {
      // ignore: avoid_print
      print('${i + 1}. ${ArchitecturePattern.values[i].displayName}');
    }

    // ignore: avoid_print
    print('');
    // ignore: avoid_print
    stdout
        .write('Enter your choice (1-${ArchitecturePattern.values.length}): ');

    try {
      String? input = stdin.readLineSync();
      int? choice = int.tryParse(input ?? '');

      while (choice == null ||
          choice < 1 ||
          choice > ArchitecturePattern.values.length) {
        // ignore: avoid_print
        stdout.write(
            'Please enter a valid choice (1-${ArchitecturePattern.values.length}): ');
        input = stdin.readLineSync();
        choice = int.tryParse(input ?? '');
      }

      return ArchitecturePattern.values[choice - 1];
    } catch (e) {
      // If there's an issue with stdin, default to Clean Architecture
      // ignore: avoid_print
      print('');
      // ignore: avoid_print
      print('⚠️  Using default: Clean Architecture Pattern');
      return ArchitecturePattern.cleanArchitecture;
    }
  }

  /// Displays state management selection menu and returns user's choice
  StateManagement _selectStateManagement() {
    // ignore: avoid_print
    print('');
    // ignore: avoid_print
    print('🎛️  Please select a state management solution:');
    // ignore: avoid_print
    print('');

    for (int i = 0; i < StateManagement.values.length; i++) {
      // ignore: avoid_print
      print('${i + 1}. ${StateManagement.values[i].displayName}');
    }

    // ignore: avoid_print
    print('');
    // ignore: avoid_print
    stdout.write('Enter your choice (1-${StateManagement.values.length}): ');

    try {
      String? input = stdin.readLineSync();
      int? choice = int.tryParse(input ?? '');

      while (choice == null ||
          choice < 1 ||
          choice > StateManagement.values.length) {
        // ignore: avoid_print
        stdout.write(
            'Please enter a valid choice (1-${StateManagement.values.length}): ');
        input = stdin.readLineSync();
        choice = int.tryParse(input ?? '');
      }

      return StateManagement.values[choice - 1];
    } catch (e) {
      // If there's an issue with stdin, default to BLoC
      // ignore: avoid_print
      print('');
      // ignore: avoid_print
      print('⚠️  Using default: BLoC (Cubit)');
      return StateManagement.bloc;
    }
  }
}
