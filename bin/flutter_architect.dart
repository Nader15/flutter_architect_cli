#!/usr/bin/env dart

import 'dart:io';
import 'package:args/args.dart';
import 'package:flutter_architect_cli/src/commands/create_command.dart';
import 'package:flutter_architect_cli/src/commands/version_command.dart';

/// Main entry point for Flutter Architect CLI
void main(List<String> arguments) {
  final parser = ArgParser()
    ..addCommand('create')
    ..addCommand('version');

  try {
    final result = parser.parse(arguments);

    if (result.command == null) {
      _printUsage(parser);
      return;
    }

    switch (result.command!.name) {
      case 'create':
        final command = CreateCommand();
        command.execute(result.command!);
        break;
      case 'version':
        final command = VersionCommand();
        command.execute();
        break;
      default:
        _printUsage(parser);
    }
  } catch (e) {
    // ignore: avoid_print
    print('Error: $e');
    exit(1);
  }
}

/// Prints usage information for the CLI
void _printUsage(ArgParser parser) {
  // ignore: avoid_print
  print('''
Flutter Architect CLI

Usage:
  flutter_architect <command> [arguments]

Commands:
  create    Create a new Flutter Clean Architecture project
  version   Print the current version

Run "flutter_architect help <command>" for more information about a command.
''');
}
