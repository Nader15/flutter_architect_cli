import 'dart:io';
import 'package:path/path.dart' as path;

/// Utility class for writing files
class FileWriter {
  /// The project name or root directory
  final String projectName;

  /// Constructor
  FileWriter(this.projectName);

  /// Writes content to a file at the specified relative path
  void writeFile(String relativePath, String content) {
    final file = File(path.join(projectName, relativePath));
    file.createSync(recursive: true);
    file.writeAsStringSync(content);
  }
}
