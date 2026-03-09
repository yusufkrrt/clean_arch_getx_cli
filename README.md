# Flutter GetX CLI

A Dart CLI tool that generates production-ready **Flutter + GetX Clean Architecture** projects and modules with a single command.

## 📁 Generated Project Structure

```
lib/
├── main.dart
└── app/
    ├── di.dart                      # Dependency injection setup
    ├── core/
    │   ├── constants/
    │   │   └── app_constants.dart
    │   ├── theme/
    │   │   └── app_theme.dart
    │   ├── utils/
    │   │   └── extensions.dart
    │   └── widgets/                 # Shared widgets (Loading, Error, Empty)
    ├── data/
    │   ├── entities/
    │   ├── models/
    │   ├── providers/
    │   │   └── base_provider.dart   # Dio-based HTTP base class
    │   ├── repositories/
    │   │   └── base_repository.dart
    │   ├── services/
    │   │   └── network_service.dart # Configured Dio instance
    │   └── usecases/
    ├── modules/
    │   └── splash/                  # Generated with every project
    │       ├── bindings/
    │       ├── controllers/
    │       └── views/
    └── routes/
        ├── app_routes.dart          # Route name constants
        ├── app_pages.dart           # GetPage definitions
        └── routes.dart              # Barrel export
```

## 🚀 Installation

### Option 1: Install globally via `dart pub global activate`

```bash
dart pub global activate clean_arch_getx_cli
```

### Option 2: Install from GitHub source

```bash
dart pub global activate --source git https://github.com/yusufkrrt/clean_arch_getx_cli
```

## 🛠 Usage

### Create a new Flutter project

```bash
getx_cli create my_app
```

With custom organization:
```bash
getx_cli create my_app --org com.mycompany
```

Apply to an **existing** Flutter project (skip `flutter create`):
```bash
getx_cli create my_app --no-flutter
```

### Add a module to an existing project

Run from inside your Flutter project root:

```bash
cd my_app
getx_cli module home
getx_cli module user_profile
getx_cli module product_detail
```

Each module generates:
```
lib/app/modules/<module_name>/
├── bindings/<module_name>_binding.dart
├── controllers/<module_name>_controller.dart
└── views/<module_name>_view.dart
```

Routes in `app_routes.dart` and `app_pages.dart` are **automatically updated**.

## 📦 Dependencies added to generated projects

| Package | Purpose |
|---|---|
| `get` | State management, routing, DI |
| `dio` | HTTP client |
| `get_storage` | Local key-value storage |
| `flutter_dotenv` | Environment variables |

## 🔧 Development

```bash
# Run from source
dart run bin/getx_cli.dart create my_app

# Compile to exe
dart compile exe bin/getx_cli.dart -o bin/getx_cli.exe

# Analyze
dart analyze
```
