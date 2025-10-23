# 🏗️ Flutter Architect CLI

[![pub package](https://img.shields.io/pub/v/flutter_architect_cli.svg)](https://pub.dev/packages/flutter_architect_cli)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub stars](https://img.shields.io/github/stars/Nader15/flutter_architect_cli.svg?style=social)](https://github.com/Nader15/flutter_architect_cli/stargazers)



A **powerful CLI tool** to scaffold Flutter projects with multiple architecture patterns automatically.  
Choose from **Clean Architecture**, **MVC**, **MVVM**, or **MVP** patterns with interactive selection and get a **production-ready project structure** instantly.

> 🚀 **NEW**: Enhanced with advanced Template System, 80% code reduction, and optimized performance!

---

## 🚀 Features

- 🧱 **4 Architecture Patterns**: Clean Architecture, MVC, MVVM, and MVP  
- ⚙️ **Interactive Selection**: Choose your preferred pattern during project creation  
- 🧩 **Feature-First Organization**: Modular and scalable code structure  
- 🧰 **Production-Ready**: Pre-configured with best practices and utilities  
- 🔐 **Complete Examples**: Auth feature implementation for each pattern  
- 🧭 **Dependency Injection**: Ready-to-use service locator setup  
- 🔄 **5 State Management Options**: BLoC (Cubit), Provider, Riverpod, GetX, State Notifier  
- ⚡ **Zero Configuration**: Start coding immediately with no setup required  
- 🧠 **Best Practices**: Industry-standard patterns and conventions  
- 🎯 **Advanced Template System**: Dynamic code generation with 80% less duplication  
- 🚀 **Optimized Performance**: Faster project generation and better maintainability  
- 🔧 **Modular Architecture**: Clean separation of concerns and extensible design  

---

## 🧩 Installation

### From [pub.dev](https://pub.dev/packages/flutter_architect_cli) (Recommended)
```bash
dart pub global activate flutter_architect_cli
```

### From GitHub (Latest Development)
```bash
dart pub global activate --source git https://github.com/Nader15/flutter_architect_cli.git
```

---

## ⚡ Quick Start

Create a new Flutter project with architecture scaffolding:

```bash
flutter_architect create my_app
```

You'll be prompted to select an architecture pattern and state management:

```
🚀 Creating Flutter project: my_app

📁 Please select an architecture pattern:

1. Clean Architecture Pattern
2. MVC Pattern
3. MVVM Pattern
4. MVP Pattern

Enter your choice (1-4): 1

🎛️  Please select a state management solution:

1. BLoC (Cubit)
2. Provider
3. Riverpod
4. GetX
5. State Notifier

Enter your choice (1-5): 1

🎯 Selected Architecture: Clean Architecture Pattern
🎯 Selected State Management: BLoC (Cubit)

✅ Clean Architecture project created successfully!
```

The CLI will scaffold your complete project structure with the selected architecture and state management — start developing immediately!

---

## 🏗️ Architecture Patterns

### **1. Clean Architecture Pattern ✅**

**Best for:** Enterprise apps, complex business logic, long-term projects

#### 📁 Structure:
```
lib/
├── core/
│   ├── constants/
│   ├── error/
│   ├── network/
│   ├── utils/
│   ├── theme/
│   └── di/
├── features/
│   ├── auth/
│   │   ├── presentation/
│   │   ├── domain/
│   │   └── data/
│   └── [other features]/
└── shared/
```

#### 🌟 Key Benefits
- Highly testable and maintainable  
- Clear separation of concerns  
- Easy to scale and add new features  
- Industry standard for large projects  

#### 🧰 Technologies
- GetIt for dependency injection  
- Multiple state management options (BLoC Cubit, Provider, Riverpod, GetX, State Notifier)  
- Repository pattern  
- Advanced template system for code generation  

---

### **2. MVC Pattern ✅**

**Best for:** Small to medium apps, rapid development, simpler projects

#### 📁 Structure:
```
lib/
├── models/
├── views/
├── controllers/
├── services/
└── utils/
```

#### 🌟 Key Benefits
- Simple and straightforward  
- Fast development cycle  
- Easy to understand for beginners  
- Lightweight architecture  

#### 🧰 Technologies
- Multiple state management options (BLoC Cubit, Provider, Riverpod, GetX, State Notifier)  
- Model classes with JSON serialization  
- Service layer for business logic  
- Template-based code generation  

---

### **3. MVVM Pattern ✅**

**Best for:** Medium to large apps, data-binding focus, modern Flutter apps

#### 📁 Structure:
```
lib/
├── core/
├── data/
├── domain/
├── features/
│   ├── presentation/
│   │   ├── views/
│   │   └── viewmodels/
│   ├── data/
│   └── domain/
└── shared/
```

#### 🌟 Key Benefits
- Strong data binding  
- Clear separation of UI and logic  
- Easier unit testing  
- Suitable for complex UIs  

#### 🧰 Technologies
- Multiple state management options (BLoC Cubit, Provider, Riverpod, GetX, State Notifier)  
- Repository pattern  
- ViewModel for business logic  
- Advanced template system  

---

### **4. MVP Pattern ✅**

**Best for:** Apps requiring testability, presenter-centric logic, contract-based development

#### 📁 Structure:
```
lib/
├── core/
├── features/
│   ├── [feature]/
│   │   ├── model/
│   │   ├── view/
│   │   ├── presenter/
│   │   └── view_interface/
└── shared/
```

#### 🌟 Key Benefits
- Excellent testability  
- Clear contracts between layers  
- Presenter-focused business logic  
- Easy to refactor UI without affecting logic  

#### 🧰 Technologies
- Presenter pattern  
- View interfaces/contracts  
- Repository pattern  
- Template-based code generation  

---

## 🧠 Command Reference

```bash
flutter_architect create <project_name>
```

**Arguments:**
- `<project_name>` – Name of the Flutter project (default: `my_flutter_app`)

**Interactive Selection:**
- 1️⃣ Clean Architecture – Recommended for enterprise applications  
- 2️⃣ MVC – Best for rapid development  
- 3️⃣ MVVM – Ideal for complex data-driven UIs  
- 4️⃣ MVP – Perfect for highly testable code  

**State Management Options:**
- 1️⃣ BLoC (Cubit) – Reactive state management  
- 2️⃣ Provider – Simple state management  
- 3️⃣ Riverpod – Modern state management  
- 4️⃣ GetX – All-in-one solution  
- 5️⃣ State Notifier – Lightweight state management  

---

## 📊 Project Structure Comparison

| Feature | Clean Arch | MVC | MVVM | MVP |
|----------|-------------|-----|------|-----|
| **Complexity** | High | Low | Medium | Medium |
| **Testability** | Excellent | Good | Good | Excellent |
| **Scalability** | Excellent | Good | Very Good | Very Good |
| **Learning Curve** | Steep | Easy | Medium | Medium |
| **Best For** | Large Projects | Quick Prototypes | Data-Heavy Apps | Test-Driven Dev |
| **File Count** | High | Low | Medium | Medium |

---

## 🧩 Generated Files Overview

### Core Components (All Patterns)
- **Constants**
- **Utilities**
- **Theme**
- **Error Handling**
- **Network**
- **Dependency Injection**

### Feature Components (Pattern Specific)
- ✅ User authentication  
- 📦 Data models  
- 🧱 Repository pattern  
- 🔄 State management  
- 🖥️ UI layers  

---

## 🧰 Getting Started After Generation

1. **Open the project**
   ```bash
   cd my_app
   flutter pub get
   ```
2. **Review the structure**  
3. **Replace placeholders**
   - Update API endpoints in constants  
   - Implement actual API calls  
   - Add your business logic  
4. **Add dependencies**
5. **Start coding!** 🎯  

---

## 💉 Dependency Injection Setup

| Pattern | Dependency Injection |
|----------|----------------------|
| Clean Architecture | GetIt |
| MVC | ServiceLocator |
| MVVM | Simple DI container |
| MVP | Manual repository injection |

---

## 🧠 Best Practices Included

- ✅ Separation of concerns  
- ✅ Error handling patterns  
- ✅ Validation utilities  
- ✅ Theme & constants management  
- ✅ Network error handling  
- ✅ Repository pattern implementation  
- ✅ Template-based code generation  
- ✅ Modular architecture design  
- ✅ Consistent code structure across patterns  
- ✅ Optimized performance and maintainability  

---

## 🚀 Recent Improvements

### Template System & Code Optimization
- **80% Code Reduction**: Eliminated massive code duplication across architecture patterns
- **Advanced Template Engine**: Dynamic code generation with variable substitution
- **Modular Design**: Clean separation between template logic and business logic
- **Performance Boost**: Faster project generation and better IDE performance
- **Consistent Structure**: Standardized folder structures and naming conventions

### Enhanced State Management
- **5 State Management Options**: Full support for BLoC, Provider, Riverpod, GetX, and State Notifier
- **Pattern-Specific Integration**: Each architecture pattern optimized for different state management solutions
- **Template-Based Generation**: State management files generated from reusable templates

### Architecture Pattern Refactoring
- **New Base Class System**: `PatternBase` provides common functionality across all patterns
- **Reduced Complexity**: Each pattern file reduced from 1000+ lines to ~150-200 lines
- **Better Maintainability**: Single source of truth for templates and common functionality
- **Extensibility**: Easy to add new patterns and state management solutions

---

## ⚠️ Troubleshooting

**Project not created**
- Ensure you have write permissions  
- Check project name characters  

**Missing dependencies**
```bash
flutter pub get
```

**Build errors**
- Replace placeholder implementations.

---

## 🤝 Contributing

Contributions are welcome! Submit issues and pull requests.

---

## 📄 License

MIT License – see [LICENSE](LICENSE)

---

## 💬 Support

- **GitHub:** [flutter_architect_cli](https://github.com/Nader15/flutter_architect_cli)  
- **pub.dev:** [flutter_architect_cli](https://pub.dev/packages/flutter_architect_cli)

---

### 🎉 Happy Architecting with Flutter! 🚀
