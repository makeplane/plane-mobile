import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:plane_startup/config/const.dart';
import 'package:plane_startup/provider/workspace_provider.dart';
import 'package:plane_startup/screens/on_boarding/auth/invite_co_workers.dart';
import 'package:plane_startup/screens/on_boarding/auth/join_workspaces.dart';
import 'package:plane_startup/screens/on_boarding/auth/setup_profile_screen.dart';
import 'package:plane_startup/screens/on_boarding/auth/setup_workspace.dart';
import 'package:plane_startup/screens/on_boarding/auth/sign_in.dart';
import 'package:plane_startup/widgets/error_state.dart';
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
    var themeProvider = ref.watch(ProviderList.themeProvider);
    return Scaffold(
       
        body: (profileProv.getProfileState == StateEnum.loading ||
                workspaceProv.workspaceInvitationState == StateEnum.loading)
            ? Center(
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: LoadingIndicator(
                    indicatorType: Indicator.lineSpinFadeLoader,
                    colors: themeProvider.isDarkThemeEnabled
                        ? [Colors.white]
                        : [Colors.black],
                    strokeWidth: 1.0,
                    backgroundColor: Colors.transparent,
                  ),
                ),
              )
                : profileProv.getProfileState == StateEnum.error
                    ? errorState(
                        context: context,
                        showButton: false,
                      )
                    : !profileProv.userProfile.isOnboarded!
                        ? (!profileProv
                                .userProfile.onboardingStep!['profile_complete']
                            ? const SetupProfileScreen()
                            : !profileProv.userProfile
                                    .onboardingStep!['workspace_create']
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

  Future getData() async {
    var prov = ref.read(ProviderList.profileProvider);
    var projectProv = ref.read(ProviderList.projectProvider);
    var dashProv = ref.read(ProviderList.dashboardProvider);
    final WorkspaceProvider workspaceProv =
        ref.watch(ProviderList.workspaceProvider);
    prov.getProfile().then((value) {
      // log(prov.userProfile.workspace.toString());
      if (prov.userProfile.isOnboarded == false) return;

      workspaceProv.getWorkspaces().then((value) {
        if (workspaceProv.workspaces.isEmpty) {
          return;
        }
        workspaceProv.getWorkspaceMembers();
        // log(prov.userProfile.last_workspace_id.toString());
        dashProv.getDashboard();
        projectProv.getProjects(
          slug: workspaceProv.selectedWorkspace!.workspaceSlug,
        );
        ref.read(ProviderList.notificationProvider).getUnreadCount();

        ref
            .read(ProviderList.notificationProvider)
            .getNotifications(type: 'assigned');
        ref
            .read(ProviderList.notificationProvider)
            .getNotifications(type: 'created');
        ref
            .read(ProviderList.notificationProvider)
            .getNotifications(type: 'watching');
        ref
            .read(ProviderList.notificationProvider)
            .getNotifications(type: 'unread', getUnread: true);
        ref
            .read(ProviderList.notificationProvider)
            .getNotifications(type: 'archived', getArchived: true);
        ref
            .read(ProviderList.notificationProvider)
            .getNotifications(type: 'snoozed', getSnoozed: true);
      });
      setState(() {
        Const.isOnline = true;
      });
    });
  }
}
