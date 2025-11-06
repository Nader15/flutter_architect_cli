import '../../utils/file_writer.dart';
import '../commands/create_command.dart';

/// Template engine for generating code files
class TemplateEngine {
  /// File writer utility
  final FileWriter fileWriter;

  /// Project name
  final String projectName;

  /// Organization name
  final String organization;

  /// State management choice
  final StateManagement stateManagement;

  /// Constructor
  TemplateEngine({
    required this.fileWriter,
    required this.projectName,
    required this.organization,
    required this.stateManagement,
  });

  /// Renders a template with variables
  String renderTemplate(String template, Map<String, dynamic> variables) {
    String result = template;

    // Add common variables
    final allVariables = {
      'projectName': projectName,
      'organization': organization,
      'stateManagement': stateManagement.displayName,
      'stateManagementImport': getStateManagementImport(),
      'stateManagementFolder': getStateManagementFolder(),
      'stateManagementFileName': getStateManagementFileName(),
      ...variables,
    };

    // Replace variables in template
    allVariables.forEach((key, value) {
      result = result.replaceAll('{{$key}}', value.toString());
    });

    return result;
  }

  /// Writes a file using template
  void writeTemplateFile(
      String filePath, String template, Map<String, dynamic> variables) {
    final content = renderTemplate(template, variables);
    fileWriter.writeFile(filePath, content);
  }

  /// Gets state management import statement
  String getStateManagementImport() {
    switch (stateManagement) {
      case StateManagement.bloc:
        return "import 'package:flutter_bloc/flutter_bloc.dart';";
      case StateManagement.provider:
        return "import 'package:provider/provider.dart';";
      case StateManagement.riverpod:
        return "import 'package:flutter_riverpod/flutter_riverpod.dart';";
      case StateManagement.getx:
        return "import 'package:get/get.dart';";
    }
  }

  /// Gets state management folder name
  String getStateManagementFolder() {
    switch (stateManagement) {
      case StateManagement.bloc:
        return 'cubit';
      case StateManagement.provider:
        return 'provider';
      case StateManagement.riverpod:
        return 'notifier';
      case StateManagement.getx:
        return 'controller';
    }
  }

  /// Gets state management file name
  String getStateManagementFileName() {
    switch (stateManagement) {
      case StateManagement.bloc:
        return 'auth_cubit.dart';
      case StateManagement.provider:
        return 'auth_provider.dart';
      case StateManagement.riverpod:
        return 'auth_notifier.dart';
      case StateManagement.getx:
        return 'auth_controller.dart';
    }
  }
}
