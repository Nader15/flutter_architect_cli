import 'package:args/args.dart';
import 'command.dart';

/// Command to display the current version of the CLI.
class VersionCommand implements Command {
  /// Creates a new [VersionCommand] instance.
  VersionCommand();

  @override
  void execute(ArgResults results) {
    // ignore: avoid_print
    print('Flutter Architect CLI v1.0.6');
  }
}
