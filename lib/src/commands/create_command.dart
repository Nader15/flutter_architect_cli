import 'package:args/args.dart';
import '../../flutter_architect_cli.dart';

/// Command to create a new Flutter Clean Architecture project.
///
/// This command scaffolds the complete folder structure and foundational
/// files for a Clean Architecture Flutter project.
class CreateCommand implements Command {
  /// Creates a new [CreateCommand] instance.
  CreateCommand();

  @override
  void execute(ArgResults results) {
    final projectName =
        results.rest.isNotEmpty ? results.rest[0] : 'my_flutter_app';

    // ignore: avoid_print
    print('🚀 Creating Flutter Clean Architecture project: $projectName');

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
  }
}
