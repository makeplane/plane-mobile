import 'package:flutter_dotenv/flutter_dotenv.dart';

class APIs {
  /// [App based APIs]
  static String baseApi = dotenv.env['BASE_API']!;
  static String signUp = '$baseApi/api/sign-up/';
  static String signIn = '$baseApi/api/sign-in/';
  static String generateMagicLink = '/api/magic-generate/';
  static String googleAuth = '$baseApi/api/social-auth/';
  static String magicValidate = '/api/magic-sign-in/';
  static String profile = '/api/users/me/';
  static String listWorkspaceInvitaion =
      '/api/users/me/invitations/workspaces/';
  static String joinWorkspace = '$baseApi/api/users/me/invitations/workspaces/';
  static String createWorkspace = '$baseApi/api/workspaces/';
  static String inviteToWorkspace = '$baseApi/api/workspaces/\$SLUG/invite/';
  static String inviteToProject =
      '$baseApi/api/workspaces/\$SLUG/projects/\$PROJECTID/members/add/';
  static String listWorkspaces = "$baseApi/api/users/me/workspaces/";
  static String retrieveWorkspace = '$baseApi/api/workspaces/\$SLUG/';
  static String getWorkspaceMembers = '$baseApi/api/workspaces/\$SLUG/members/';
  static String workspaceSlugCheck =
      '$baseApi/api/workspace-slug-check/?slug=SLUG';
  static String fileUpload = '$baseApi/api/users/file-assets/';
  static String listProjects = '$baseApi/api/workspaces/\$SLUG/projects/';
  static String listModules =
      '$baseApi/api/workspaces/\$SLUG/projects/\$PROJECTID/modules/';
  static String listEstimates =
      '$baseApi/api/workspaces/\$SLUG/projects/\$PROJECTID/estimates/';
  static String favouriteModules =
      '$baseApi/api/workspaces/\$SLUG/projects/\$PROJECTID/user-favorite-modules/';
  static String createProjects = '$baseApi/api/workspaces/\$SLUG/projects/';
  static String favouriteProjects =
      '$baseApi/api/workspaces/\$SLUG/user-favorite-projects/';
  static String states =
      '$baseApi/api/workspaces/\$SLUG/projects/\$PROJECTID/states/';
  static String orderByGroupByTypeIssues =
      '$baseApi/api/workspaces/\$SLUG/projects/\$PROJECTID/issues/?order_by=\$ORDERBY&group_by=\$GROUPBY&type=\$TYPE';
  static String orderByGroupByTypeArchivedIssues =
      '$baseApi/api/workspaces/\$SLUG/projects/\$PROJECTID/archived-issues/?order_by=\$ORDERBY&group_by=\$GROUPBY&type=\$TYPE';
  static String orderByGroupByIssues =
      '$baseApi/api/workspaces/\$SLUG/projects/\$PROJECTID/issues/?order_by=\$ORDERBY&group_by=\$GROUPBY';
  static String projectMembers =
      '$baseApi/api/workspaces/\$SLUG/projects/\$PROJECTID/members/';
  static String userIssueView =
      '$baseApi/api/workspaces/\$SLUG/projects/\$PROJECTID/project-members/me';
  static String myIssuesView =
      '$baseApi/api/workspaces/\$SLUG/workspace-members/me/';
  static String updateMyIssuesView =
      '$baseApi/api/workspaces/\$SLUG/workspace-views/';
  static String projectIssues =
      '$baseApi/api/workspaces/\$SLUG/projects/\$PROJECTID/issues/';
  static String moduleIssues =
      '$baseApi/api/workspaces/\$SLUG/projects/\$PROJECTID/modules/\$MODULEID/module-issues/';
  static String moduleLinks =
      '$baseApi/api/workspaces/\$SLUG/projects/\$PROJECTID/modules/\$MODULEID/module-links/';
  static String cycleIssues =
      '$baseApi/api/workspaces/\$SLUG/projects/\$PROJECTID/cycles/\$CYCLEID/cycle-issues/';
  static String transferIssues =
      '$baseApi/api/workspaces/\$SLUG/projects/\$PROJECTID/cycles/\$CYCLEID/transfer-issues/';
  static String issueAttachments =
      '$baseApi/api/workspaces/\$SLUG/projects/\$PROJECTID/issues/\$ISSUEID/issue-attachments/';
  static String issuelinks =
      '$baseApi/api/workspaces/\$SLUG/projects/\$PROJECTID/issues/\$ISSUEID/issue-links/';
  static String issueLabels =
      '$baseApi/api/workspaces/\$SLUG/projects/\$PROJECTID/issue-labels/';
  static String projectViews =
      '$baseApi/api/workspaces/\$SLUG/projects/\$PROJECTID/project-views/';
  static String issueProperties =
      '$baseApi/api/workspaces/\$SLUG/projects/\$PROJECTID/issue-properties/';
  static String issueDetails =
      '$baseApi/api/workspaces/\$SLUG/projects/\$PROJECTID/issues/\$ISSUEID/';
  static String subIssues =
      '$baseApi/api/workspaces/\$SLUG/projects/\$PROJECTID/issues/\$ISSUEID/sub-issues/';
  static String joinProject = '$baseApi/api/workspaces/\$SLUG/projects/join/';
  static String searchIssues =
      '$baseApi/api/workspaces/\$SLUG/projects/\$PROJECTID/search-issues/';
  static String cycles =
      '$baseApi/api/workspaces/\$SLUG/projects/\$PROJECTID/cycles/';
  static String dateCheck =
      '$baseApi/api/workspaces/\$SLUG/projects/\$PROJECTID/cycles/date-check/';
  static String toggleFavoriteCycle =
      '$baseApi/api/workspaces/\$SLUG/projects/\$PROJECTID/user-favorite-cycles/';
  static String orderByGroupByCycleIssues =
      '$baseApi/api/workspaces/\$SLUG/projects/\$PROJECTID/cycles/\$CYCLEID/cycle-issues/?order_by=\$ORDERBY&group_by=\$GROUPBY&type=\$TYPE/';
  static String orderByGroupByModuleIssues =
      '$baseApi/api/workspaces/\$SLUG/projects/\$PROJECTID/modules/\$MODULEID/module-issues/?order_by=\$ORDERBY&group_by=\$GROUPBY&type=\$TYPE/';
  static String myIssues =
      '$baseApi/api/workspaces/\$SLUG/my-issues/?order_by=\$ORDERBY&group_by=\$GROUPBY&type=\$TYPE';
  static String projectIdentifier =
      "$baseApi/api/workspaces/\$SLUG/project-identifiers/?name=\$IDENTIFIER";
  static String activity = '$baseApi/api/users/workspaces/\$SLUG/activities/';
  static String isOnboarded = '$baseApi/api/users/me/onboard/';
  static String dashboard =
      "$baseApi/api/users/me/workspaces/\$SLUG/dashboard/";
  static String integrations = "$baseApi/api/integrations/";
  static String wokspaceIntegrations =
      "$baseApi/api/workspaces/\$SLUG/workspace-integrations/";
  static String sendForgotPassCode = "$baseApi/api/forgot-password/";
  static String resetPassword = "$baseApi/api/reset-password/\$UID/\$TOKEN/";
  static String views =
      "$baseApi/api/workspaces/\$SLUG/projects/\$PROJECTID/views/";
  static String viewsFavourite =
      "$baseApi/api/workspaces/\$SLUG/projects/\$PROJECTID/user-favorite-views/";
  static String globalSearch = "$baseApi/api/workspaces/\$SLUG/search/";
  static String listAllPages =
      "$baseApi/api/workspaces/\$SLUG/projects/\$PROJECTID/pages/?page_view=all";
  static String listAllFavoritePages =
      "$baseApi/api/workspaces/\$SLUG/projects/\$PROJECTID/pages/?page_view=favorite";
  static String listAllRecentPages =
      "$baseApi/api/workspaces/\$SLUG/projects/\$PROJECTID/pages/?page_view=recent";
  static String getPages =
      "$baseApi/api/workspaces/\$SLUG/projects/\$PROJECTID/pages/";
  static String pageBlock =
      "$baseApi/api/workspaces/\$SLUG/projects/\$PROJECTID/pages/\$PAGEID/page-blocks/";
  static String createPage =
      "$baseApi/api/workspaces/\$SLUG/projects/\$PROJECTID/pages/";
  static String favouritePage =
      "$baseApi/api/workspaces/\$SLUG/projects/\$PROJECTID/user-favorite-pages/";
  static String updatePageBlock =
      "$baseApi/api/workspaces/\$SLUG/projects/\$PROJECTID/pages/\$PAGEID/page-blocks/\$BLOCKID/";
  static String deletePageBlock =
      "$baseApi/api/workspaces/\$SLUG/projects/\$PROJECTID/pages/\$PAGEID/page-blocks/\$BLOCKID/";
  static String deletePage =
      "$baseApi/api/workspaces/\$SLUG/projects/\$PROJECTID/pages/\$PAGEID/";
  static String notifications =
      "$baseApi/api/workspaces/\$SLUG/users/notifications/";
  static String retrieveWorkspaceIntegrations =
      '$baseApi/api/workspaces/\$SLUG/workspace-integrations/';
  static String retrieveGithubIntegrations =
      '$baseApi/api/workspaces/\$SLUG/projects/\$PROJECTID/workspace-integrations/\$INTEGRATIONID/github-repository-sync/';
  static String retrieveSlackIntegrations =
      '$baseApi/api/workspaces/\$SLUG/projects/\$PROJECTID/workspace-integrations/\$INTEGRATIONID/project-slack-sync/';
  static String memberProfile =
      '$baseApi/api/workspaces/\$SLUG/user-profile/\$USERID/';
  static String leaveWorkspace =
      '$baseApi/api/workspaces/\$SLUG/members/leave/';
  static String leaveProject =
      '$baseApi/api/workspaces/\$SLUG/projects/\$PROJECTID/members/leave/';
  static String releaseNotes = '$baseApi/api/release-notes/';
  static String userStats =
      '$baseApi/api/workspaces/\$SLUG/user-stats/\$USERID/';
  static String userActivity =
      '$baseApi/api/workspaces/\$SLUG/user-activity/\$USERID/?per_page=15';

  static String userIssues =
      '$baseApi/api/workspaces/\$SLUG/user-issues/\$USERID/';
  static String pendingInvites = '$baseApi/api/workspaces/\$SLUG/invitations/';
  static String retrieveUserRoleOnWorkspace =
      '$baseApi/api/workspaces/\$SLUG/workspace-members/me/';
}
