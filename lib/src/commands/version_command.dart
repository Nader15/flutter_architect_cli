/// Command to display the current version of the CLI.
class VersionCommand {
  /// Creates a new [VersionCommand] instance.
  VersionCommand();

  /// Executes the version command and prints the current version.
  void execute() {
    // ignore: avoid_print
    print('Flutter Architect CLI v1.0.2');
  }
}
