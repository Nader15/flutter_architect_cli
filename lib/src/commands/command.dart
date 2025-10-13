import 'package:args/args.dart';

/// Abstract base class for all CLI commands
abstract class Command {
  /// Executes the command with the given arguments
  void execute(ArgResults results);
}
