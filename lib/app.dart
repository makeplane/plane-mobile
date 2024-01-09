import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:plane/provider/workspace_provider.dart';
import 'package:plane/screens/on_boarding/auth/invite_co_workers.dart';
import 'package:plane/screens/on_boarding/auth/join_workspaces.dart';
import 'package:plane/screens/on_boarding/auth/setup_profile_screen.dart';
import 'package:plane/screens/on_boarding/auth/setup_workspace.dart';
import 'package:plane/screens/on_boarding/auth/sign_in.dart';
import 'package:plane/startup/dependency_resolver.dart';
import 'package:plane/widgets/error_state.dart';
import 'utils/enums.dart';
import 'provider/profile_provider.dart';
import 'provider/provider_list.dart';
import 'screens/home_screen.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  @override
  Widget build(BuildContext context) {
    ref.read(ProviderList.themeProvider).context = context;
    final ProfileProvider profileProv = ref.watch(ProviderList.profileProvider);
    final WorkspaceProvider workspaceProv =
        ref.watch(ProviderList.workspaceProvider);
    final themeProvider = ref.watch(ProviderList.themeProvider);
    return Scaffold(
        body: (profileProv.getProfileState == StateEnum.loading ||
                workspaceProv.workspaceInvitationState == StateEnum.loading)
            ? Center(
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: LoadingIndicator(
                    indicatorType: Indicator.lineSpinFadeLoader,
                    colors: [themeProvider.themeManager.primaryTextColor],
                    strokeWidth: 1.0,
                    backgroundColor: Colors.transparent,
                  ),
                ),
              )
            : profileProv.getProfileState == StateEnum.error
                ? errorState(
                    context: context,
                    showButton: false,
                    ontap: () {
                      DependencyResolver.resolve(ref: ref);
                    })
                : !profileProv.userProfile.isOnboarded!
                    ? (!profileProv
                            .userProfile.onboardingStep!['profile_complete']
                        ? const SetupProfileScreen()
                        : !profileProv
                                .userProfile.onboardingStep!['workspace_create']
                            ? const SetupWorkspace()
                            : !profileProv.userProfile
                                    .onboardingStep!['workspace_invite']
                                ? const InviteCOWorkers()
                                : !profileProv.userProfile
                                        .onboardingStep!['workspace_join']
                                    ? const JoinWorkspaces(
                                        fromOnboard: true,
                                      )
                                    : const SignInScreen())
                    : const HomeScreen(
                        fromSignUp: false,
                      ));
  }
}
