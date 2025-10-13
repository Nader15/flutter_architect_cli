# Flutter Architect CLI Example

## Installation

```bash
dart pub global activate flutter_architect_cli
```

## Usage

### Create a new project:

```bash
flutter_architect create my_flutter_app
```

### Project Structure Created:

```
my_flutter_app/
├── lib/
│   ├── core/
│   │   ├── constants/
│   │   ├── errors/
│   │   ├── usecases/
│   │   └── utils/
│   ├── features/
│   │   └── auth/
│   │       ├── data/
│   │       ├── domain/
│   │       └── presentation/
│   ├── injection_container.dart
│   └── main.dart
└── pubspec.yaml
```

### Next Steps:

```bash
cd my_flutter_app
flutter pub get
flutter run
```

## Features Included

- ✅ Clean Architecture structure
- ✅ Dependency injection setup
- ✅ BLoC state management ready
- ✅ Example auth feature
- ✅ Core utilities and error handling