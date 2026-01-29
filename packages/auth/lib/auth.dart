/// Authentication package with domain, data, and presentation layers.
///
/// This package provides a complete authentication solution that can be
/// plugged into any Flutter app. It uses clean architecture principles
/// with abstract navigation to decouple from specific routing solutions.
library;

// Module
export 'src/auth_module.dart';

// Domain - Entities
export 'src/domain/entities/user.dart';

// Domain - Repositories
export 'src/domain/repositories/auth_repository.dart';

// Domain - Use Cases
export 'src/domain/usecases/forgot_password_usecase.dart';
export 'src/domain/usecases/get_current_user_usecase.dart';
export 'src/domain/usecases/login_usecase.dart';
export 'src/domain/usecases/logout_usecase.dart';
export 'src/domain/usecases/register_usecase.dart';

// Data - Data Sources
export 'src/data/datasources/auth_datasource.dart';
export 'src/data/datasources/mock_auth_datasource.dart';

// Data - Models
export 'src/data/models/user_model.dart';

// Data - Repositories
export 'src/data/repositories/auth_repository_impl.dart';

// Presentation - BLoC
export 'src/presentation/bloc/auth_bloc.dart';

// Presentation - Pages
export 'src/presentation/pages/forgot_password_page.dart';
export 'src/presentation/pages/login_page.dart';
export 'src/presentation/pages/register_page.dart';

// Presentation - Navigation
export 'src/presentation/navigation/auth_navigation.dart';
export 'src/presentation/navigation/auth_navigation_provider.dart';
