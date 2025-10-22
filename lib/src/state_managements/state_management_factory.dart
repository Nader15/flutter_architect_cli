import '../commands/create_command.dart';
import '../../utils/file_writer.dart';
import 'base_state_management.dart';
import 'bloc_state_management.dart';
import 'provider_state_management.dart';
import 'riverpod_state_management.dart';
import 'getx_state_management.dart';
import 'state_notifier_state_management.dart';

/// Factory class to create state management instances
class StateManagementFactory {
  /// Creates a state management instance based on the selected type
  static BaseStateManagement create(
    StateManagement stateManagement,
    FileWriter fileWriter,
  ) {
    switch (stateManagement) {
      case StateManagement.bloc:
        return BlocStateManagement(fileWriter);
      case StateManagement.provider:
        return ProviderStateManagement(fileWriter);
      case StateManagement.riverpod:
        return RiverpodStateManagement(fileWriter);
      case StateManagement.getx:
        return GetxStateManagement(fileWriter);
      case StateManagement.stateNotifier:
        return StateNotifierStateManagement(fileWriter);
    }
  }
}
