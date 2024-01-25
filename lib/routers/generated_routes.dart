import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:plane/screens/Activity/activity.dart';
import 'package:plane/screens/project/create_project_screen.dart';
import 'package:plane/screens/project/cycles/create_cycle.dart';
import 'package:plane/screens/project/issues/create_issue.dart';
import 'package:plane/screens/project/modules/create_module.dart';
import 'package:plane/screens/create_state.dart';
import 'package:plane/screens/home_screen.dart';
import 'package:plane/screens/onboarding/on_boarding_screen.dart';
import 'package:plane/screens/onboarding/auth/setup_profile_screen.dart';
import 'package:plane/screens/onboarding/auth/setup_workspace.dart';
import 'package:plane/screens/onboarding/auth/sign_in.dart';
import 'package:plane/utils/page_route_builder.dart';
import 'routes_path.dart';

class GeneratedRoutes {
  bool isAutheticated() {
    return true;
  }

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesPaths.home:
        return PageRoutesBuilder.sharedAxis(
          const HomeScreen(
            fromSignUp: false,
          ),
          SharedAxisTransitionType.horizontal,
        );
      case RoutesPaths.createCycle:
        return PageRoutesBuilder.sharedAxis(
          const CreateCycle(),
          SharedAxisTransitionType.horizontal,
        );
      case RoutesPaths.createIssue:
        return PageRoutesBuilder.sharedAxis(
          const CreateIssue(),
          SharedAxisTransitionType.horizontal,
        );
      case RoutesPaths.createProject:
        return PageRoutesBuilder.sharedAxis(
          const CreateProject(),
          SharedAxisTransitionType.horizontal,
        );
      case RoutesPaths.createModule:
        return PageRoutesBuilder.sharedAxis(
          const CreateModule(),
          SharedAxisTransitionType.horizontal,
        );
      case RoutesPaths.activity:
        return PageRoutesBuilder.sharedAxis(
          const Activity(),
          SharedAxisTransitionType.horizontal,
        );
      case RoutesPaths.createState:
        return PageRoutesBuilder.sharedAxis(
          const CreateState(),
          SharedAxisTransitionType.horizontal,
        );
      case RoutesPaths.onboarding:
        return PageRoutesBuilder.sharedAxis(
          const OnBoardingScreen(),
          SharedAxisTransitionType.horizontal,
        );
      case RoutesPaths.signin:
        return PageRoutesBuilder.sharedAxis(
          const SignInScreen(),
          SharedAxisTransitionType.horizontal,
        );
      case RoutesPaths.setupProfile:
        return PageRoutesBuilder.sharedAxis(
          const SetupProfileScreen(),
          SharedAxisTransitionType.horizontal,
        );
      case RoutesPaths.setupWorkspace:
        return PageRoutesBuilder.sharedAxis(
          const SetupWorkspace(),
          SharedAxisTransitionType.horizontal,
        );

      default:
        return PageRoutesBuilder.sharedAxis(
          const HomeScreen(
            fromSignUp: false,
          ),
          SharedAxisTransitionType.horizontal,
        );
    }
  }
}
