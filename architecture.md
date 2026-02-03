# Modular Monorepo Architecture

## Plug-and-Play Feature Packages with Riverpod

---

## Table of Contents

1. [Executive Summary](#executive-summary)
2. [Architectural Overview](#architectural-overview)
3. [The Vision](#the-vision)
4. [Current State Analysis](#current-state-analysis)
5. [Target Architecture](#target-architecture)
6. [Why Riverpod Over BLoC](#why-riverpod-over-bloc)
7. [Architecture Deep Dive](#architecture-deep-dive)
8. [Package Design Patterns](#package-design-patterns)
9. [Multi-App Strategy](#multi-app-strategy)
10. [Migration Strategy](#migration-strategy)
11. [Decision Matrix](#decision-matrix)

---

## Executive Summary

### What We're Building

A **modular monorepo architecture** where:

- Each feature is an independent, self-contained package
- Packages work immediately upon import (zero configuration required)
- Multiple apps can share packages with optional customization
- Adding or removing features requires no changes to host app wiring

### Why This Matters

**Current Pain → Target Solution**

- **Adding a feature requires updating host app DI** → Import package and use
- **Each app duplicates injection setup** → Apps share packages, override only what differs
- **Cross-feature dependencies need manual wiring** → Automatic dependency resolution
- **Package changes ripple through DI layer** → Changes stay contained in package

### The Core Principle

> **"Batteries Included, Optionally Swappable"**
>
> Packages ship with working defaults. Apps configure only when they need to differ.

---

## Architectural Overview

### Complete System Architecture

```
┌──────────────────────────────────────────────────────────────────────────────┐
│                                                                              │
│                              HOST APPLICATIONS                               │
│                                                                              │
│    ┌──────────────┐      ┌──────────────┐      ┌──────────────┐             │
│    │ Consumer App │      │Enterprise App│      │  Admin App   │             │
│    │              │      │              │      │              │             │
│    │ ┌──────────┐ │      │ ┌──────────┐ │      │ ┌──────────┐ │             │
│    │ │ Provider │ │      │ │ Provider │ │      │ │ Provider │ │             │
│    │ │  Scope   │ │      │ │  Scope   │ │      │ │  Scope   │ │             │
│    │ │          │ │      │ │ override │ │      │ │ override │ │             │
│    │ │ (default)│ │      │ │   SSO    │ │      │ │  admin   │ │             │
│    │ └──────────┘ │      │ └──────────┘ │      │ └──────────┘ │             │
│    └───────┬──────┘      └───────┬──────┘      └───────┬──────┘             │
│            │                     │                     │                     │
│            └─────────────────────┼─────────────────────┘                     │
│                                  │                                           │
│                                  ▼                                           │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│                           FEATURE PACKAGES                                   │
│                        (Pluggable Business Logic)                            │
│                                                                              │
│    ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐  │
│    │  Auth   │ │  Todo   │ │ Profile │ │Settings │ │Payments │ │  Chat   │  │
│    │         │ │         │ │         │ │         │ │         │ │         │  │
│    │ ┌─────┐ │ │ ┌─────┐ │ │ ┌─────┐ │ │ ┌─────┐ │ │ ┌─────┐ │ │ ┌─────┐ │  │
│    │ │Notif│ │ │ │Notif│ │ │ │Notif│ │ │ │Notif│ │ │ │Notif│ │ │ │Notif│ │  │
│    │ ├─────┤ │ │ ├─────┤ │ │ ├─────┤ │ │ ├─────┤ │ │ ├─────┤ │ │ ├─────┤ │  │
│    │ │Repo │ │ │ │Repo │ │ │ │Repo │ │ │ │Repo │ │ │ │Repo │ │ │ │Repo │ │  │
│    │ ├─────┤ │ │ ├─────┤ │ │ ├─────┤ │ │ ├─────┤ │ │ ├─────┤ │ │ ├─────┤ │  │
│    │ │Data │ │ │ │Data │ │ │ │Data │ │ │ │Data │ │ │ │Data │ │ │ │Data │ │  │
│    │ ├─────┤ │ │ ├─────┤ │ │ ├─────┤ │ │ ├─────┤ │ │ ├─────┤ │ │ ├─────┤ │  │
│    │ │Confg│ │ │ │Confg│ │ │ │Confg│ │ │ │Confg│ │ │ │Confg│ │ │ │Confg│ │  │
│    │ └─────┘ │ │ └─────┘ │ │ └─────┘ │ │ └─────┘ │ │ └─────┘ │ │ └─────┘ │  │
│    └────┬────┘ └────┬────┘ └────┬────┘ └────┬────┘ └────┬────┘ └────┬────┘  │
│         │           │           │           │           │           │        │
│         └───────────┴───────────┴─────┬─────┴───────────┴───────────┘        │
│                                       │                                      │
│                                       ▼                                      │
├──────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│                             CORE PACKAGES                                    │
│                    (Shared Foundation - ALL must use)                        │
│                                                                              │
│    ┌────────────────────┐ ┌──────────────┐ ┌───────────┐ ┌───────────┐      │
│    │   DESIGN SYSTEM    │ │  Networking  │ │  Storage  │ │   Utils   │      │
│    │   ═══════════════  │ │              │ │           │ │           │      │
│    │                    │ │  - HTTP      │ │  - Hive   │ │  - Ext    │      │
│    │  - AppButton       │ │  - Intercept │ │  - Secure │ │  - Const  │      │
│    │  - AppTextField    │ │  - Error     │ │  - Cache  │ │  - Helper │      │
│    │  - AppCard         │ │  - Retry     │ │           │ │           │      │
│    │  - AppTheme        │ │              │ │           │ │           │      │
│    │  - AppColors       │ │              │ │           │ │           │      │
│    │  - AppTypography   │ │              │ │           │ │           │      │
│    │  - AppSpacing      │ │              │ │           │ │           │      │
│    │                    │ │              │ │           │ │           │      │
│    │  ⚠️ MANDATORY FOR  │ │              │ │           │ │           │      │
│    │    ALL UI CODE     │ │              │ │           │ │           │      │
│    └────────────────────┘ └──────────────┘ └───────────┘ └───────────┘      │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
```

### Directory Structure

```
kris_builds/
│
├── apps/                              # ━━━ HOST APPLICATIONS ━━━
│   │                                  # Orchestration only, no business logic
│   ├── consumer_app/                  # Public-facing mobile app
│   ├── enterprise_app/                # B2B app with SSO overrides
│   └── admin_app/                     # Internal admin tools
│
├── packages/
│   │
│   ├── core/                          # ━━━ SHARED FOUNDATION ━━━
│   │   │                              # Every package depends on these
│   │   │
│   │   ├── design_system/             # 🎨 UI Components & Theming
│   │   │   ├── components/            #    AppButton, AppCard, AppTextField...
│   │   │   ├── theme/                 #    AppTheme, AppColors, AppTypography
│   │   │   └── tokens/                #    Design tokens
│   │   │
│   │   ├── networking/                # 🌐 HTTP & API Layer
│   │   │   ├── client/                #    Dio/HTTP client setup
│   │   │   ├── interceptors/          #    Auth, logging, retry
│   │   │   └── errors/                #    API error handling
│   │   │
│   │   ├── storage/                   # 💾 Local Persistence
│   │   │   ├── hive/                  #    Hive adapters & boxes
│   │   │   ├── secure/                #    Secure storage wrapper
│   │   │   └── cache/                 #    Caching strategies
│   │   │
│   │   └── utils/                     # 🔧 Utilities
│   │       ├── extensions/            #    Dart/Flutter extensions
│   │       ├── constants/             #    App-wide constants
│   │       └── helpers/               #    Helper functions
│   │
│   └── features/                      # ━━━ FEATURE PACKAGES ━━━
│       │                              # Pluggable, self-contained
│       │
│       ├── auth/                      # 🔐 Authentication
│       ├── todo/                      # ✅ Todo Management
│       ├── profile/                   # 👤 User Profile
│       ├── settings/                  # ⚙️ App Settings
│       ├── payments/                  # 💳 Payment Processing
│       └── notifications/             # 🔔 Push Notifications
│
├── melos.yaml                         # Monorepo configuration
├── architecture.md                    # This document
└── CLAUDE.md                          # Development guidelines
```

### Dependency Flow

```
ALLOWED DEPENDENCIES
════════════════════

    Apps ──────► Features ──────► Core ──────► Flutter SDK
      │              │              │
      │              │              └──► Other Core packages (minimal)
      │              │
      │              └──► Other Features (explicit, via ref.watch)
      │
      └──► Core (for design system, utilities)


FORBIDDEN DEPENDENCIES
══════════════════════

    Features ──✗──► Apps          (features don't know about apps)
    Core ──────✗──► Features      (core doesn't know about features)
    Core ──────✗──► Apps          (core doesn't know about apps)
```

### Modularity & Coupling Analysis

```
┌─────────────────────────────────────────────────────────────────────┐
│                    MODULARITY SCORECARD                             │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  COMPONENT          │ MODULAR? │ LOOSELY COUPLED? │ NOTES          │
│  ───────────────────┼──────────┼──────────────────┼─────────────── │
│  Feature Packages   │    ✅    │       ✅         │ Self-contained │
│  Core Packages      │    ✅    │       ✅         │ No biz logic   │
│  Host Apps          │    ✅    │       ✅         │ Orchestration  │
│  Cross-Feature Deps │    ✅    │       ⚠️         │ Explicit watch │
│                                                                     │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ⚠️ CROSS-FEATURE COUPLING EXPLAINED:                               │
│                                                                     │
│  When FeatureB watches FeatureA (ref.watch(authProvider)):         │
│                                                                     │
│    • This is INTENTIONAL coupling                                  │
│    • The dependency is EXPLICIT and TRACEABLE                      │
│    • Type-safe at compile time                                     │
│    • Better than hidden coupling via shared repositories           │
│                                                                     │
│  For COMPLETE decoupling, use event bus pattern:                   │
│                                                                     │
│    ref.read(eventBusProvider).emit(UserLoggedInEvent(user));       │
│                                                                     │
│  But for most cases, explicit ref.watch is the right balance.      │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### Design System Enforcement

```
┌─────────────────────────────────────────────────────────────────────┐
│                    DESIGN SYSTEM RULES                              │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  ❌ FORBIDDEN                      │  ✅ REQUIRED                    │
│  ────────────────────────────────  │  ────────────────────────────  │
│                                    │                                │
│  ElevatedButton()                  │  AppButton()                   │
│  TextButton()                      │  AppButton.text()              │
│  TextField()                       │  AppTextField()                │
│  Card()                            │  AppCard()                     │
│  ListTile()                        │  AppListTile()                 │
│  Colors.blue                       │  AppColors.primary             │
│  TextStyle(fontSize: 16)           │  AppTypography.bodyLarge       │
│  EdgeInsets.all(16)                │  AppSpacing.md                 │
│                                    │                                │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  WHY?                                                               │
│  • Consistent look across all apps                                  │
│  • Theme changes propagate automatically                            │
│  • Accessibility built-in                                           │
│  • White-labeling becomes trivial (just override theme)             │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

---

## The Vision

```
┌─────────────────────────────────────────────────────────────────────┐
│                        MONOREPO STRUCTURE                           │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│   ┌─────────────┐  ┌─────────────┐  ┌─────────────┐                 │
│   │   App A     │  │   App B     │  │   App C     │   APPS          │
│   │  Consumer   │  │  Business   │  │  Internal   │                 │
│   └──────┬──────┘  └──────┬──────┘  └──────┬──────┘                 │
│          │                │                │                        │
│          └────────────────┼────────────────┘                        │
│                           │                                         │
│                           ▼                                         │
│   ┌─────────────────────────────────────────────────────────────┐   │
│   │                    FEATURE PACKAGES                         │   │
│   │  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌────────┐ │   │
│   │  │  Auth   │ │  Todo   │ │ Payment │ │ Profile │ │  Chat  │ │   │
│   │  │    ✓    │ │    ✓    │ │    ✓    │ │    ✓    │ │    ✓   │ │   │
│   │  └─────────┘ └─────────┘ └─────────┘ └─────────┘ └────────┘ │   │
│   └─────────────────────────────────────────────────────────────┘   │
│                           │                                         │
│                           ▼                                         │
│   ┌─────────────────────────────────────────────────────────────┐   │
│   │                    SHARED PACKAGES                          │   │
│   │  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐            │   │
│   │  │ Widgets │ │ Network │ │ Storage │ │  Utils  │            │   │
│   │  └─────────┘ └─────────┘ └─────────┘ └─────────┘            │   │
│   └─────────────────────────────────────────────────────────────┘   │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘

✓ = Self-contained, works on import, optionally configurable
```

### Key Characteristics

- **Self-Contained** — Each package owns its data, logic, and UI layers
- **Zero-Config Default** — Works immediately with sensible defaults
- **Optionally Configurable** — Apps can override specific behaviors when needed
- **Independently Testable** — No external wiring required for unit tests
- **Loosely Coupled** — Packages declare dependencies, not implementations

---

## Current State Analysis

### Current Architecture (BLoC-based)

```
┌─────────────────────────────────────────────────────────────────────┐
│                         HOST APP                                    │
│  ┌───────────────────────────────────────────────────────────────┐  │
│  │                      Injection.dart                           │  │
│  │  ┌─────────────────────────────────────────────────────────┐  │  │
│  │  │  - Initialize AuthModule with DataSource                │  │  │
│  │  │  - Initialize TodoModule with DataSource                │  │  │
│  │  │  - Initialize PaymentModule with DataSource  ◄── GROWS  │  │  │
│  │  │  - Initialize ProfileModule with DataSource             │  │  │
│  │  │  - ... every new feature adds here                      │  │  │
│  │  └─────────────────────────────────────────────────────────┘  │  │
│  └───────────────────────────────────────────────────────────────┘  │
│                                │                                    │
│                                ▼                                    │
│  ┌───────────────────────────────────────────────────────────────┐  │
│  │                    MultiBlocProvider                          │  │
│  │  ┌─────────────────────────────────────────────────────────┐  │  │
│  │  │  BlocProvider<AuthBloc>                                 │  │  │
│  │  │  BlocProvider<TodoBloc>                                 │  │  │
│  │  │  BlocProvider<PaymentBloc>     ◄── GROWS                │  │  │
│  │  │  BlocProvider<ProfileBloc>                              │  │  │
│  │  │  ... every new feature adds here                        │  │  │
│  │  └─────────────────────────────────────────────────────────┘  │  │
│  └───────────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────┘
```

### Files Required Per Feature (Current)

```
packages/auth/
├── lib/src/
│   ├── presentation/bloc/
│   │   ├── auth_bloc.dart          # ~120 lines
│   │   ├── auth_event.dart         # ~60 lines
│   │   └── auth_state.dart         # ~50 lines
│   └── auth_module.dart            # ~60 lines (DI wiring)
└── ...

apps/example_app/
└── lib/core/di/
    └── injection.dart              # Must update for EVERY package
```

### Current Pain Points

```
┌────────────────────────────────────────────────────────────────┐
│  ADDING A NEW FEATURE PACKAGE                                  │
├────────────────────────────────────────────────────────────────┤
│                                                                │
│  1. Create feature_bloc.dart      ───┐                         │
│  2. Create feature_event.dart        │ In Package              │
│  3. Create feature_state.dart        │                         │
│  4. Create feature_module.dart    ───┘                         │
│                                                                │
│  5. Update injection.dart         ───┐                         │
│  6. Add module initialization        │ In EVERY Host App       │
│  7. Add to providers list            │                         │
│  8. Update MultiBlocProvider      ───┘                         │
│                                                                │
│  Steps 5-8 must be repeated for EACH app using the package     │
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

---

## Target Architecture

### Riverpod Package-First Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                         HOST APP                                    │
│  ┌───────────────────────────────────────────────────────────────┐  │
│  │                         main.dart                             │  │
│  │  ┌─────────────────────────────────────────────────────────┐  │  │
│  │  │  ProviderScope(                                         │  │  │
│  │  │    overrides: [  // OPTIONAL - only if customizing      │  │  │
│  │  │      // Override only what differs from defaults        │  │  │
│  │  │    ],                                                   │  │  │
│  │  │    child: App(),                                        │  │  │
│  │  │  )                                                      │  │  │
│  │  └─────────────────────────────────────────────────────────┘  │  │
│  └───────────────────────────────────────────────────────────────┘  │
│                                                                     │
│         NO Injection.dart    NO MultiBlocProvider setup             │
│         NO module wiring     NO provider list management            │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘

                    ▲
                    │ Just import and use
                    │
┌─────────────────────────────────────────────────────────────────────┐
│                      FEATURE PACKAGE                                │
│  ┌───────────────────────────────────────────────────────────────┐  │
│  │  Self-Contained Provider Graph                                │  │
│  │                                                               │  │
│  │    ┌─────────────────┐                                        │  │
│  │    │  featureConfig  │ ◄── Overridable (optional)             │  │
│  │    └────────┬────────┘                                        │  │
│  │             │                                                 │  │
│  │             ▼                                                 │  │
│  │    ┌─────────────────┐                                        │  │
│  │    │   dataSource    │ ◄── Uses config or default             │  │
│  │    └────────┬────────┘                                        │  │
│  │             │                                                 │  │
│  │             ▼                                                 │  │
│  │    ┌─────────────────┐                                        │  │
│  │    │   repository    │     Internal                           │  │
│  │    └────────┬────────┘                                        │  │
│  │             │                                                 │  │
│  │             ▼                                                 │  │
│  │    ┌─────────────────┐                                        │  │
│  │    │    feature      │ ◄── Public API                         │  │
│  │    │   (notifier)    │                                        │  │
│  │    └─────────────────┘                                        │  │
│  │                                                               │  │
│  └───────────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────┘
```

### Files Required Per Feature (Target)

```
packages/auth/
├── lib/src/
│   ├── providers/
│   │   └── auth_providers.dart     # ~100 lines (config + state + notifier)
│   └── ... (domain, data layers unchanged)
└── ...

apps/example_app/
└── lib/
    └── main.dart                   # NO changes needed for new packages
```

### Adding a New Feature (Target)

```
┌────────────────────────────────────────────────────────────────┐
│  ADDING A NEW FEATURE PACKAGE                                  │
├────────────────────────────────────────────────────────────────┤
│                                                                │
│  1. Create feature_providers.dart  ─── In Package             │
│  2. Export from package barrel     ─── In Package             │
│                                                                │
│  3. Import in app                  ─── One line               │
│                                                                │
│  Done. No wiring. No provider registration. Just works.       │
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

---

## Why Riverpod Over BLoC

### Architectural Comparison

- **DI Philosophy**
  - BLoC: Manual — host app wires everything
  - Riverpod: Automatic — providers self-register
- **Package Coupling**
  - BLoC: Tight — host app knows internals
  - Riverpod: Loose — host app uses public API
- **Configuration**
  - BLoC: Constructor injection
  - Riverpod: Provider overrides
- **Cross-Feature Deps**
  - BLoC: Complex (streams, callbacks, shared repos)
  - Riverpod: Simple (`ref.watch`)
- **Boilerplate**
  - BLoC: 4 files per feature
  - Riverpod: 1-2 files per feature
- **Testing**
  - BLoC: Mock entire DI chain
  - Riverpod: Override specific providers

### Code Comparison

#### BLoC: Using Auth in Another Feature

```dart
// TodoBloc needs to know if user is authenticated
// Option 1: Pass AuthBloc (tight coupling)
class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc({required AuthBloc authBloc}) : _authBloc = authBloc;

  void _onLoadTodos(LoadTodos event, Emitter emit) {
    // Listen to auth state changes - complex stream handling
    _authBloc.stream.listen((authState) {
      if (authState is AuthAuthenticated) {
        // load todos
      }
    });
  }
}

// Option 2: Pass AuthRepository (still needs wiring)
class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc({required AuthRepository authRepo}) : _authRepo = authRepo;
  // Host app must wire this dependency
}
```

#### Riverpod: Using Auth in Another Feature

```dart
// TodoNotifier needs to know if user is authenticated
final todoProvider = NotifierProvider<TodoNotifier, TodoState>(
  TodoNotifier.new,
);

class TodoNotifier extends Notifier<TodoState> {
  @override
  TodoState build() {
    // Simply watch auth - automatic dependency, automatic cleanup
    final authState = ref.watch(authProvider);

    if (authState is! AuthAuthenticated) {
      return const TodoUnauthorized();
    }

    // Automatically re-runs when auth changes
    _loadTodos();
    return const TodoLoading();
  }
}

// No wiring needed. No streams. No manual subscription management.
```

### Scalability Comparison

```
Number of Feature Packages
     │
  10 ┤                                    ╭──── Riverpod
     │                              ╭─────╯     (constant host app complexity)
   8 ┤                        ╭─────╯
     │                  ╭─────╯
   6 ┤            ╭─────╯
     │       ╭────╯
   4 ┤  ╭────╯                            ╭──── BLoC
     │  │                          ╭──────╯     (linear host app growth)
   2 ┤──╯                   ╭──────╯
     │               ╭──────╯
   0 ┼───────────────╯
     └────┬────┬────┬────┬────┬────┬────┬────▶
          │    │    │    │    │    │    │
          2    4    6    8   10   12   14

              Host App Complexity (files to modify)
```

---

## Architecture Deep Dive

### Package Internal Structure

```
packages/feature/
├── lib/
│   ├── feature.dart                    # Public barrel file
│   └── src/
│       ├── providers/                  # NEW: Riverpod providers
│       │   ├── feature_providers.dart  # Config, DataSource, Repository, Notifier
│       │   └── feature_state.dart      # State classes
│       │
│       ├── domain/                     # UNCHANGED: Business logic
│       │   ├── entities/
│       │   ├── repositories/           # Abstract repository interface
│       │   └── usecases/               # Optional: if using clean arch
│       │
│       ├── data/                       # UNCHANGED: Data layer
│       │   ├── datasources/
│       │   ├── models/
│       │   └── repositories/           # Repository implementation
│       │
│       └── presentation/               # SIMPLIFIED: No bloc folder
│           ├── pages/
│           └── widgets/
│
└── test/
    └── ...                             # Tests use provider overrides
```

### Provider Hierarchy Design

```dart
// feature_providers.dart
// NO CODE GENERATION — all providers are manual

/// ═══════════════════════════════════════════════════════════════════
/// LAYER 1: CONFIGURATION (Overridable by host app)
/// ═══════════════════════════════════════════════════════════════════

class FeatureConfig {
  final Duration timeout;
  final bool enableAnalytics;
  final FeatureDataSource? customDataSource;

  const FeatureConfig({
    this.timeout = const Duration(seconds: 30),
    this.enableAnalytics = true,
    this.customDataSource,
  });
}

final featureConfigProvider = Provider<FeatureConfig>((ref) {
  return const FeatureConfig(); // Sensible defaults
});

/// ═══════════════════════════════════════════════════════════════════
/// LAYER 2: DATA SOURCE (Uses config or default)
/// ═══════════════════════════════════════════════════════════════════

final featureDataSourceProvider = Provider<FeatureDataSource>((ref) {
  final config = ref.watch(featureConfigProvider);

  // Use custom if provided, otherwise default implementation
  return config.customDataSource ?? DefaultFeatureDataSource(
    timeout: config.timeout,
  );
});

/// ═══════════════════════════════════════════════════════════════════
/// LAYER 3: REPOSITORY (Internal - not meant for override)
/// ═══════════════════════════════════════════════════════════════════

final featureRepositoryProvider = Provider<FeatureRepository>((ref) {
  return FeatureRepositoryImpl(
    dataSource: ref.watch(featureDataSourceProvider),
  );
});

/// ═══════════════════════════════════════════════════════════════════
/// LAYER 4: NOTIFIER (Public API - the main interface)
/// ═══════════════════════════════════════════════════════════════════

final featureProvider = NotifierProvider<FeatureNotifier, FeatureState>(
  FeatureNotifier.new,
);

class FeatureNotifier extends Notifier<FeatureState> {
  @override
  FeatureState build() {
    return const FeatureInitial();
  }

  Future<void> doSomething() async {
    state = const FeatureLoading();
    try {
      final result = await ref.read(featureRepositoryProvider).doSomething();
      state = FeatureSuccess(result);
    } catch (e) {
      state = FeatureError(e.toString());
    }
  }
}
```

### State Classes (Dart 3 Sealed Classes)

```dart
// feature_state.dart
// NO FREEZED — use native Dart 3 sealed classes

sealed class FeatureState {
  const FeatureState();
}

final class FeatureInitial extends FeatureState {
  const FeatureInitial();
}

final class FeatureLoading extends FeatureState {
  const FeatureLoading();
}

final class FeatureSuccess extends FeatureState {
  final Data data;
  const FeatureSuccess(this.data);
}

final class FeatureError extends FeatureState {
  final String message;
  const FeatureError(this.message);
}
```

### Public API Surface

```dart
// feature.dart (barrel file)

// Public - for app consumption
export 'src/providers/feature_providers.dart'
    show
      featureProvider,           // Main notifier
      featureConfigProvider,     // For overrides
      FeatureConfig;             // Config class

export 'src/providers/feature_state.dart';
export 'src/domain/entities/feature_entity.dart';

// NOT exported: datasource, repository implementations
// These are internal implementation details
```

---

## Package Design Patterns

### Pattern 1: Simple Feature (No Configuration Needed)

```dart
// For features that rarely need customization

final settingsProvider = NotifierProvider<SettingsNotifier, SettingsState>(
  SettingsNotifier.new,
);

class SettingsNotifier extends Notifier<SettingsState> {
  @override
  SettingsState build() {
    _loadSettings();
    return const SettingsLoading();
  }

  // All implementation internal
  // No config provider exposed
}
```

**Host app usage:**
```dart
// Just use it
ref.watch(settingsProvider);
```

### Pattern 2: Configurable Feature (Your Standard Pattern)

```dart
// For features that may need customization per app

final featureConfigProvider = Provider<FeatureConfig>((ref) {
  return const FeatureConfig();
});

final featureDataSourceProvider = Provider<FeatureDataSource>((ref) {
  final config = ref.watch(featureConfigProvider);
  return config.customDataSource ?? DefaultDataSource();
});

final featureProvider = NotifierProvider<FeatureNotifier, FeatureState>(
  FeatureNotifier.new,
);

class FeatureNotifier extends Notifier<FeatureState> { ... }
```

**Host app usage:**
```dart
// Default behavior
ProviderScope(child: App())

// Custom behavior
ProviderScope(
  overrides: [
    featureConfigProvider.overrideWithValue(FeatureConfig(
      customDataSource: MyCustomDataSource(),
    )),
  ],
  child: App(),
)
```

### Pattern 3: Feature with Required External Dependency

```dart
// For features that MUST receive something from host app
// (e.g., API base URL, analytics service)

final apiBaseUrlProvider = Provider<String>((ref) {
  throw UnimplementedError('apiBaseUrlProvider must be overridden');
});

final featureDataSourceProvider = Provider<FeatureDataSource>((ref) {
  final baseUrl = ref.watch(apiBaseUrlProvider);
  return ApiFeatureDataSource(baseUrl);
});
```

**Host app usage:**
```dart
// MUST provide override
ProviderScope(
  overrides: [
    apiBaseUrlProvider.overrideWithValue('https://api.myapp.com'),
  ],
  child: App(),
)
```

### Pattern 4: Cross-Feature Dependencies

```dart
// Feature B depends on Feature A

// In feature_b/providers.dart
final featureBProvider = NotifierProvider<FeatureBNotifier, FeatureBState>(
  FeatureBNotifier.new,
);

class FeatureBNotifier extends Notifier<FeatureBState> {
  @override
  FeatureBState build() {
    // Watch another feature - automatic dependency
    final authState = ref.watch(authProvider);

    if (authState is! AuthAuthenticated) {
      return const FeatureBUnauthorized();
    }

    return const FeatureBReady();
  }
}
```

```
┌─────────────────┐         ┌─────────────────┐
│   Auth Package  │         │ FeatureB Package│
│                 │         │                 │
│  authProvider ──┼────────►│ ref.watch(auth) │
│                 │         │                 │
└─────────────────┘         └─────────────────┘

No manual wiring. Riverpod handles the dependency graph.
```

---

## Multi-App Strategy

### Shared Packages, Different Configurations

```
┌─────────────────────────────────────────────────────────────────────┐
│                         MONOREPO                                    │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐    │
│  │                    SHARED PACKAGES                          │    │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐        │    │
│  │  │   Auth   │ │   Todo   │ │ Profile  │ │ Settings │        │    │
│  │  │ Firebase │ │  Hive    │ │   REST   │ │  Local   │        │    │
│  │  │ default  │ │ default  │ │ default  │ │ default  │        │    │
│  │  └──────────┘ └──────────┘ └──────────┘ └──────────┘        │    │
│  └─────────────────────────────────────────────────────────────┘    │
│           │              │              │              │            │
│           ▼              ▼              ▼              ▼            │
│  ┌─────────────────────────────────────────────────────────────┐    │
│  │  App A (Consumer)                                           │    │
│  │  ┌────────────────────────────────────────────────────────┐ │    │
│  │  │ ProviderScope(                                         │ │    │
│  │  │   // Uses all defaults - zero config                   │ │    │
│  │  │   child: ConsumerApp(),                                │ │    │
│  │  │ )                                                      │ │    │
│  │  └────────────────────────────────────────────────────────┘ │    │
│  └─────────────────────────────────────────────────────────────┘    │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐    │
│  │  App B (Enterprise)                                         │    │
│  │  ┌────────────────────────────────────────────────────────┐ │    │
│  │  │ ProviderScope(                                         │ │    │
│  │  │   overrides: [                                         │ │    │
│  │  │     // Only override auth - uses enterprise SSO        │ │    │
│  │  │     authConfigProvider.overrideWithValue(              │ │    │
│  │  │       AuthConfig(customDataSource: SSOAuthDataSource())│ │    │
│  │  │     ),                                                 │ │    │
│  │  │   ],                                                   │ │    │
│  │  │   child: EnterpriseApp(),                              │ │    │
│  │  │ )                                                      │ │    │
│  │  └────────────────────────────────────────────────────────┘ │    │
│  └─────────────────────────────────────────────────────────────┘    │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐    │
│  │  App C (White Label)                                        │    │
│  │  ┌────────────────────────────────────────────────────────┐ │    │
│  │  │ ProviderScope(                                         │ │    │
│  │  │   overrides: [                                         │ │    │
│  │  │     // Override multiple for complete customization    │ │    │
│  │  │     authConfigProvider.overrideWithValue(...),         │ │    │
│  │  │     profileConfigProvider.overrideWithValue(...),      │ │    │
│  │  │     themeConfigProvider.overrideWithValue(...),        │ │    │
│  │  │   ],                                                   │ │    │
│  │  │   child: WhiteLabelApp(),                              │ │    │
│  │  │ )                                                      │ │    │
│  │  └────────────────────────────────────────────────────────┘ │    │
│  └─────────────────────────────────────────────────────────────┘    │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘
```

### Environment-Based Configuration

```dart
// In host app main.dart

void main() {
  final overrides = switch (AppEnvironment.current) {
    AppEnvironment.development => [
      authConfigProvider.overrideWithValue(AuthConfig(
        customDataSource: MockAuthDataSource(),
      )),
      apiBaseUrlProvider.overrideWithValue('https://dev-api.example.com'),
    ],
    AppEnvironment.staging => [
      apiBaseUrlProvider.overrideWithValue('https://staging-api.example.com'),
    ],
    AppEnvironment.production => [
      apiBaseUrlProvider.overrideWithValue('https://api.example.com'),
      analyticsConfigProvider.overrideWithValue(AnalyticsConfig(enabled: true)),
    ],
  };

  runApp(ProviderScope(
    overrides: overrides,
    child: const App(),
  ));
}
```

---

## Migration Strategy

### Overview

```
┌──────────────────────────────────────────────────────────────────┐
│                     MIGRATION PHASES                             │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Phase 1          Phase 2          Phase 3          Phase 4     │
│  ─────────        ─────────        ─────────        ─────────   │
│  Foundation       Coexistence      Migration        Cleanup     │
│                                                                  │
│  ┌─────────┐     ┌─────────┐      ┌─────────┐     ┌─────────┐  │
│  │ Add     │     │ New     │      │ Convert │     │ Remove  │  │
│  │ Riverpod│────►│ features│─────►│ existing│────►│ BLoC    │  │
│  │ deps    │     │ use     │      │ packages│     │ entirely│  │
│  │         │     │ Riverpod│      │         │     │         │  │
│  └─────────┘     └─────────┘      └─────────┘     └─────────┘  │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

### Phase 1: Foundation

**Goal:** Add Riverpod infrastructure without breaking existing code.

**Steps:**

1. Add dependencies to root `pubspec.yaml`:
   ```yaml
   dependencies:
     flutter_riverpod: ^2.5.0
   ```
   Note: No `riverpod_annotation`, `riverpod_generator`, or `build_runner` needed.

2. Wrap existing app with `ProviderScope`:
   ```dart
   // main.dart
   runApp(
     ProviderScope(  // Add this
       child: MultiBlocProvider(  // Keep existing
         providers: Injection.providers,
         child: const App(),
       ),
     ),
   );
   ```

3. BLoC and Riverpod now coexist. No functionality changes.

### Phase 2: Coexistence

**Goal:** New features use Riverpod. Existing features continue with BLoC.

**Guidelines:**
- All NEW packages use Riverpod providers
- Existing packages remain BLoC-based
- Cross-dependency: Riverpod can watch BLoC via `StreamProvider`

```dart
// Bridge: Riverpod watching existing BLoC
final authStreamProvider = StreamProvider<AuthState>((ref) {
  final bloc = // get from context or service locator
  return bloc.stream;
});

// New feature can now depend on existing auth
final newFeatureProvider = NotifierProvider<NewFeatureNotifier, NewFeatureState>(
  NewFeatureNotifier.new,
);

class NewFeatureNotifier extends Notifier<NewFeatureState> {
  @override
  NewFeatureState build() {
    final authState = ref.watch(authStreamProvider);
    // ...
  }
}
```

### Phase 3: Migration

**Goal:** Convert existing packages one by one.

**Per-Package Migration Steps:**

```
┌────────────────────────────────────────────────────────────────┐
│  MIGRATING A SINGLE PACKAGE                                    │
├────────────────────────────────────────────────────────────────┤
│                                                                │
│  1. Create providers/                                          │
│     └── feature_providers.dart                                 │
│         - FeatureConfig                                        │
│         - configProvider                                       │
│         - dataSourceProvider                                   │
│         - repositoryProvider                                   │
│         - Feature notifier                                     │
│                                                                │
│  2. Create providers/                                          │
│     └── feature_state.dart                                     │
│         - Copy state classes from BLoC                         │
│         - Remove Equatable if not needed                       │
│                                                                │
│  3. Update presentation/pages/                                 │
│     - Replace BlocBuilder with Consumer                        │
│     - Replace context.read<Bloc>().add() with                  │
│       ref.read(provider.notifier).method()                     │
│                                                                │
│  4. Update barrel file exports                                 │
│                                                                │
│  5. Remove from host app's Injection.dart                      │
│                                                                │
│  6. Delete bloc/ folder                                        │
│     - feature_bloc.dart                                        │
│     - feature_event.dart                                       │
│     - feature_state.dart (old)                                 │
│                                                                │
│  7. Delete feature_module.dart                                 │
│                                                                │
│  8. Run tests, verify functionality                            │
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

**Migration Priority:**
1. Smallest packages first (learn the pattern)
2. Packages with most cross-dependencies (biggest benefit)
3. Core packages last (auth - highest risk)

### Phase 4: Cleanup

**Goal:** Remove all BLoC infrastructure.

**Steps:**

1. Remove `MultiBlocProvider` from main.dart
2. Delete `Injection` class entirely
3. Remove `flutter_bloc` from dependencies
4. Remove BLoC-related dev dependencies

**Final main.dart:**
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();

  runApp(
    ProviderScope(
      overrides: [
        // Only environment-specific overrides if any
      ],
      child: const App(),
    ),
  );
}
```

### Detailed Migration: Auth Package Example

**Before (BLoC):**

```dart
// auth_bloc.dart
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
    // ... many dependencies
  }) : super(const AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter emit) async {
    emit(const AuthLoading());
    try {
      final user = await _loginUseCase(email: event.email, password: event.password);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}

// auth_event.dart - 60 lines of event classes
// auth_state.dart - 50 lines of state classes
// auth_module.dart - 60 lines of DI wiring
```

**After (Riverpod — No Code Generation):**

```dart
// auth_providers.dart

class AuthConfig {
  final AuthDataSource? customDataSource;
  final Duration sessionTimeout;

  const AuthConfig({
    this.customDataSource,
    this.sessionTimeout = const Duration(hours: 24),
  });
}

final authConfigProvider = Provider<AuthConfig>((ref) {
  return const AuthConfig();
});

final authDataSourceProvider = Provider<AuthDataSource>((ref) {
  final config = ref.watch(authConfigProvider);
  return config.customDataSource ?? DefaultAuthDataSource();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(authDataSourceProvider));
});

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    _checkAuthStatus();
    return const AuthInitial();
  }

  Future<void> login(String email, String password) async {
    state = const AuthLoading();
    try {
      final user = await ref.read(authRepositoryProvider).login(email, password);
      state = AuthAuthenticated(user);
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  Future<void> logout() async {
    state = const AuthLoading();
    await ref.read(authRepositoryProvider).logout();
    state = const AuthUnauthenticated();
  }
}

// auth_state.dart — Dart 3 sealed classes (no freezed)
sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class AuthAuthenticated extends AuthState {
  final User user;
  const AuthAuthenticated(this.user);
}

final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

final class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}
```

**Line Count Comparison:**

| Component | BLoC | Riverpod | Reduction |
|-----------|------|----------|-----------|
| State Management | ~230 lines (4 files) | ~80 lines (2 files) | 65% |
| DI/Module | ~60 lines | 0 lines | 100% |
| Host App Injection | ~20 lines per package | 0 lines | 100% |
| **Total** | **~310 lines** | **~80 lines** | **74%** |

---

## Decision Matrix

### When to Use Each Pattern

| Scenario | Recommendation |
|----------|----------------|
| New greenfield project | Riverpod |
| Single app, <3 packages | BLoC is fine |
| Multi-app monorepo | Riverpod strongly recommended |
| 5+ feature packages | Riverpod |
| Team knows BLoC well, deadline tight | Stay with BLoC |
| Long-term maintainability priority | Riverpod |
| Need plug-and-play packages | Riverpod |

### Risk Assessment

| Risk | Mitigation |
|------|------------|
| Team learning curve | Phase 2 allows gradual learning with new features |
| Breaking existing functionality | Coexistence phase - no rewrites under pressure |
| Migration takes too long | Prioritize high-value packages, leave low-risk ones for later |
| Testing gaps | Each package migrates with its tests |

### Success Metrics

| Metric | Target |
|--------|--------|
| New package setup time | <30 minutes (vs hours with BLoC) |
| Host app changes for new package | 0 lines |
| Cross-package dependency wiring | 0 lines |
| Package test isolation | 100% (no host app mocking) |

---

## No Code Generation Policy

### Why No build_runner, freezed, or @riverpod Annotations

This architecture intentionally avoids code generation for several reasons:

```
┌────────────────────────────────────────────────────────────────┐
│              CODE GENERATION: COSTS vs BENEFITS                │
├────────────────────────────────────────────────────────────────┤
│                                                                │
│  COSTS (Why we avoid it)                                       │
│  ─────────────────────────                                     │
│  • AI context noise — .g.dart files clutter codebase           │
│  • Context rot — AI models degrade with noisy/generated code   │
│  • Build complexity — Extra CI/CD step, slower builds          │
│  • Onboarding friction — "Run build_runner first"              │
│  • Debugging indirection — Generated code is hard to trace     │
│                                                                │
│  BENEFITS (What we give up)                                    │
│  ─────────────────────────                                     │
│  • Slightly less boilerplate (minimal with Dart 3)             │
│  • Auto-generated copyWith (rarely needed with sealed classes) │
│  • Auto-generated equality (use const constructors instead)    │
│                                                                │
│  VERDICT: Costs outweigh benefits for this architecture        │
│                                                                │
└────────────────────────────────────────────────────────────────┘
```

### What We Use Instead

| Instead of | We use | Why |
|------------|--------|-----|
| `@riverpod` | Manual `Provider`, `NotifierProvider` | Explicit, no generation |
| `freezed` | Dart 3 `sealed class` | Native pattern matching |
| `json_serializable` | Manual `fromJson`/`toJson` | Clear, debuggable |
| `equatable` | `const` constructors | Identity equality via const |

### Manual Provider Example

```dart
// No annotations, no generation, just clear Dart code

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthInitial();

  Future<void> login(String email, String password) async {
    state = const AuthLoading();
    // ...
  }
}
```

---

## Conclusion

The **Package-First Riverpod Architecture** delivers on the promise of true plug-and-play feature packages:

1. **Packages are self-contained** - They work on import with no host app wiring
2. **Apps stay simple** - Just `ProviderScope` with optional overrides
3. **Scaling is linear** - Adding packages doesn't increase host app complexity
4. **Multi-app is natural** - Share packages, override configurations
5. **Testing is isolated** - Each package tests independently

The migration path is incremental and safe. BLoC and Riverpod coexist during transition, allowing the team to learn and adapt without risking production stability.

---

## Next Steps

1. **Review this document** with the team
2. **Create proof-of-concept** by migrating one small package
3. **Evaluate in practice** - does it deliver the promised benefits?
4. **Decide go/no-go** on full migration
5. **Execute phased migration** if approved

---

*Document Version: 1.0*
*Last Updated: February 2026*
