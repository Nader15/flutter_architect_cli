import 'dart:io';
import 'package:args/args.dart';
import '../../flutter_architect_cli.dart';

/// Architecture patterns available for Flutter projects
enum ArchitecturePattern {
  cleanArchitecture('Clean Architecture Pattern'),
  mvc('MVC Pattern'),
  mvvm('MVVM Pattern'),
  mvp('MVP Pattern');

  const ArchitecturePattern(this.displayName);
  final String displayName;
}

/// Command to create a new Flutter project with selected architecture pattern.
///
/// This command scaffolds the complete folder structure and foundational
/// files for a Flutter project with the chosen architecture pattern.
class CreateCommand implements Command {
  /// Creates a new [CreateCommand] instance.
  CreateCommand();

  @override
  void execute(ArgResults results) {
    final projectName =
        results.rest.isNotEmpty ? results.rest[0] : 'my_flutter_app';

    // ignore: avoid_print
    print('🚀 Creating Flutter project: $projectName');
    // ignore: avoid_print
    print('');

    // Show architecture pattern selection menu
    final selectedPattern = _selectArchitecturePattern();
    
    if (selectedPattern == ArchitecturePattern.cleanArchitecture) {
      // ignore: avoid_print
      print('📁 Selected: ${selectedPattern.displayName}');
      // ignore: avoid_print
      print('');

      final scaffolder = ProjectScaffolder(projectName);
      scaffolder.scaffold();

      // ignore: avoid_print
      print('✅ Project created successfully!');
      // ignore: avoid_print
      print('');
      // ignore: avoid_print
      print('Next steps:');
      // ignore: avoid_print
      print('  cd $projectName');
      // ignore: avoid_print
      print('  flutter pub get');
      // ignore: avoid_print
      print('  flutter run');
    } else {
      // ignore: avoid_print
      print('📁 Selected: ${selectedPattern.displayName}');
      // ignore: avoid_print
      print('');
      // ignore: avoid_print
      print('🚧 Coming Soon!');
      // ignore: avoid_print
      print('${selectedPattern.displayName} support is currently under development.');
      // ignore: avoid_print
      print('Please try Clean Architecture Pattern for now.');
    }
  }

  /// Displays architecture pattern selection menu and returns user's choice
  ArchitecturePattern _selectArchitecturePattern() {
    // ignore: avoid_print
    print('Please select an architecture pattern:');
    // ignore: avoid_print
    print('');

    for (int i = 0; i < ArchitecturePattern.values.length; i++) {
      // ignore: avoid_print
      print('${i + 1}. ${ArchitecturePattern.values[i].displayName}');
    }

    // ignore: avoid_print
    print('');
    // ignore: avoid_print
    stdout.write('Enter your choice (1-${ArchitecturePattern.values.length}): ');

    try {
      String? input = stdin.readLineSync();
      int? choice = int.tryParse(input ?? '');

      while (choice == null || choice < 1 || choice > ArchitecturePattern.values.length) {
        // ignore: avoid_print
        stdout.write('Please enter a valid choice (1-${ArchitecturePattern.values.length}): ');
        input = stdin.readLineSync();
        choice = int.tryParse(input ?? '');
      }

      return ArchitecturePattern.values[choice - 1];
    } catch (e) {
      // If there's an issue with stdin (like in non-interactive environments), default to Clean Architecture
      // ignore: avoid_print
      print('');
      // ignore: avoid_print
      print('⚠️  Using default: Clean Architecture Pattern');
      return ArchitecturePattern.cleanArchitecture;
    }
  }
}
