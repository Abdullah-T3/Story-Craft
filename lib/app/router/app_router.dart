import 'package:flutter/material.dart';
import 'package:story_craft/app/router/route_error_page.dart';
import 'package:story_craft/app/router/routs.dart';
import 'package:story_craft/core/widgets/main_layout.dart';
import 'package:story_craft/features/auth/login/presentation/pages/login_page.dart';
import 'package:story_craft/features/auth/sign_up/presentation/pages/sign_up_page.dart';
import 'package:story_craft/features/notifications/presentation/pages/notifications_page.dart';
import 'package:story_craft/features/stories/presentation/pages/story_pages_editor_screen.dart';
import 'package:story_craft/features/stories/presentation/pages/story_setup_screen.dart';
import 'package:story_craft/features/onboarding/presentation/page/onboarding.dart';
import 'package:story_craft/features/profile/presentation/pages/account_page.dart';
import 'package:story_craft/features/profile/presentation/pages/achievements_page.dart';
import 'package:story_craft/features/profile/presentation/pages/parental_control_page.dart';
import 'package:story_craft/features/profile/presentation/pages/personal_info_page.dart';
import 'package:story_craft/features/profile/presentation/pages/saved_stories_page.dart';
import 'package:story_craft/features/stories/presentation/pages/category_page.dart';
import 'package:story_craft/features/stories/presentation/pages/library_page.dart';
import 'package:story_craft/features/stories/presentation/pages/search_page.dart';
import 'package:story_craft/features/stories/presentation/pages/story_details_page.dart';
import 'package:story_craft/features/stories/presentation/pages/story_reader_page.dart';

abstract final class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.onboardingPath:
        return MaterialPageRoute<void>(
          builder: (_) => const OnboardingScreen(),
          settings: settings,
        );
      case AppRoutes.loginPath:
        return MaterialPageRoute<void>(
          builder: (_) => const LoginPage(),
          settings: settings,
        );
      case AppRoutes.signUpPath:
        return MaterialPageRoute<void>(
          builder: (_) => const SignUpPage(),
          settings: settings,
        );
      case AppRoutes.storySetupPath:
        return MaterialPageRoute<void>(
          builder: (_) => const StorySetupPage(),
          settings: settings,
        );
      case AppRoutes.storyPagesEditorPath:
        return MaterialPageRoute<void>(
          builder: (_) => const StoryPagesEditorScreen(),
          settings: settings,
        );
      case AppRoutes.mainLayoutPath:
        final initial = (settings.arguments is int)
            ? settings.arguments as int
            : 0;
        return MaterialPageRoute<void>(
          builder: (_) => MainLayout(initialIndex: initial),
          settings: settings,
        );
      case AppRoutes.accountPath:
        return MaterialPageRoute<void>(
          builder: (_) => const AccountPage(),
          settings: settings,
        );
      case AppRoutes.achievementsPath:
        return MaterialPageRoute<void>(
          builder: (_) => const AchievementsPage(),
          settings: settings,
        );
      case AppRoutes.savedStoriesPath:
        return MaterialPageRoute<void>(
          builder: (_) => const SavedStoriesPage(),
          settings: settings,
        );
      case AppRoutes.parentalControlPath:
        return MaterialPageRoute<void>(
          builder: (_) => const ParentalControlPage(),
          settings: settings,
        );
      case AppRoutes.personalInfoPath:
        return MaterialPageRoute<void>(
          builder: (_) => const PersonalInfoPage(),
          settings: settings,
        );
      case AppRoutes.libraryPath:
        return MaterialPageRoute<void>(
          builder: (_) => const LibraryPage(),
          settings: settings,
        );
      case AppRoutes.storyDetailsPath:
        final id = (settings.arguments as String?) ?? '';
        return MaterialPageRoute<void>(
          builder: (_) => StoryDetailsPage(storyId: id),
          settings: settings,
        );
      case AppRoutes.storyReaderPath:
        final id = (settings.arguments as String?) ?? '';
        return MaterialPageRoute<void>(
          builder: (_) => StoryReaderPage(storyId: id),
          settings: settings,
        );
      case AppRoutes.searchPath:
        return MaterialPageRoute<void>(
          builder: (_) => const SearchPage(),
          settings: settings,
        );
      case AppRoutes.categoryPath:
        final id = (settings.arguments as String?) ?? 'all';
        return MaterialPageRoute<void>(
          builder: (_) => CategoryPage(categoryId: id),
          settings: settings,
        );
      case AppRoutes.notificationsPath:
        return MaterialPageRoute<void>(
          builder: (_) => const NotificationsPage(),
          settings: settings,
        );
      default:
        return MaterialPageRoute<void>(
          builder: (_) => RouteErrorPage(routeName: settings.name),
          settings: settings,
        );
    }
  }
}
