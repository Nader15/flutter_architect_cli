import 'package:args/args.dart';

/// Abstract base class for all CLI commands.
///
/// Implement this class to create new commands for the CLI tool.
abstract class Command {
  /// Creates a new [Command] instance.
  Command();

  /// Executes the command with the given arguments.
  ///
  /// [results] contains the parsed command-line arguments.
  void execute(ArgResults results);
}
