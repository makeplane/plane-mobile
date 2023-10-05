// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/config/const.dart';
import 'package:plane/screens/MainScreens/Profile/User_profile/user_profile.dart';
import 'package:plane/screens/MainScreens/Projects/ProjectDetail/IssuesTab/issue_detail.dart';
import 'package:plane/utils/custom_toast.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/config/apis.dart';
import 'package:plane/services/dio_service.dart';
import 'package:url_launcher/url_launcher.dart';

import '../screens/MainScreens/Projects/ProjectDetail/CyclesTab/cycle_detail.dart';
import '../utils/global_functions.dart';
// import 'package:webview_cookie_manager/webview_cookie_manager.dart';

class IssueProvider with ChangeNotifier {
  IssueProvider(ChangeNotifierProviderRef<IssueProvider> this.ref);
  Ref ref;
  StateEnum issueDetailState = StateEnum.empty;
  StateEnum issueActivityState = StateEnum.empty;
  StateEnum subscriptionState = StateEnum.empty;
  StateEnum cookiesState = StateEnum.empty;
  StateEnum updateIssueState = StateEnum.empty;
  StateEnum attachmentState = StateEnum.empty;
  StateEnum addLinkState = StateEnum.empty;
  StateEnum getSubIssueState = StateEnum.empty;
  StateEnum addSubIssueState = StateEnum.empty;
  Map<String, dynamic> issueDetails = {};
  List<dynamic> issueActivity = [];
  // Map<String, dynamic> subIssues = {};
  List<dynamic> subIssues = [];
  List cyclesList = [];
  List modulesList = [];

  void clear() {
    issueDetailState = StateEnum.empty;
    issueActivityState = StateEnum.empty;
    updateIssueState = StateEnum.empty;
    attachmentState = StateEnum.empty;
    subscriptionState = StateEnum.empty;
    addSubIssueState = StateEnum.empty;
    //updateIssueState = StateEnum.empty;
    addLinkState = StateEnum.empty;
    getSubIssueState = StateEnum.empty;
    issueDetails = {};
    // subIssues = {};
    issueActivity = [];
    cyclesList = [];
  }

  void setState() {
    notifyListeners();
  }

  //Future getIssueDetailsBlockedIssue()

  Future getIssueDetails(
      {required String slug,
      required String projID,
      required String issueID}) async {
    try {
      final issuesProvider = ref.read(ProviderList.issuesProvider);
      final response = await DioConfig().dioServe(
        hasAuth: true,
        url: APIs.issueDetails
            .replaceAll("\$SLUG", slug)
            .replaceAll('\$PROJECTID', projID)
            .replaceAll('\$ISSUEID', issueID),
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      issueDetails = response.data;
      //log(issueDetails.toString());
      issuesProvider.blockingIssuesIds.clear();
      issuesProvider.blockedByIssuesIds.clear();
      issuesProvider.blockedByIssues.clear();
      issuesProvider.blockingIssues.clear();
      issuesProvider.selectedLabels.clear();

      for (int i = 0; i < response.data['blocked_issues'].length; i++) {
        issuesProvider.blockedByIssues.add(
          {
            'id': response.data['blocked_issues'][i]['blocked_issue_detail']
                ['id'],
            'title': response.data['project_detail']['identifier'] +
                '-' +
                response.data['blocked_issues'][i]['blocked_issue_detail']
                        ['sequence_id']
                    .toString(),
          },
        );
        issuesProvider.blockedByIssuesIds.add(
            response.data['blocked_issues'][i]['blocked_issue_detail']['id']);
      }
      for (int i = 0; i < response.data['blocker_issues'].length; i++) {
        issuesProvider.blockingIssues.add({
          'id': response.data['blocker_issues'][i]['blocker_issue_detail']
              ['id'],
          'title': response.data['project_detail']['identifier'] +
              '-' +
              response.data['blocker_issues'][i]['blocker_issue_detail']
                      ['sequence_id']
                  .toString(),
        });
        issuesProvider.blockingIssuesIds.add(
            response.data['blocker_issues'][i]['blocker_issue_detail']['id']);
      }
      for (int i = 0; i < response.data['label_details'].length; i++) {
        issuesProvider.selectedLabels.add(
          {
            'id': response.data['label_details'][i]['id'],
            'name': response.data['label_details'][i]['name'],
            'color': response.data['label_details'][i]['color'],
          },
        );
      }

      issueDetailState = StateEnum.success;
      notifyListeners();
    } on DioException catch (e) {
      log(e.error.toString());
      issueDetailState = StateEnum.error;
      notifyListeners();
    }
  }

  Future getIssueActivity(
      {required String slug,
      required String projID,
      required String issueID}) async {
    try {
      issueActivityState = StateEnum.loading;
      final response = await DioConfig().dioServe(
        hasAuth: true,
        url:
            '${APIs.issueDetails.replaceAll("\$SLUG", slug).replaceAll('\$PROJECTID', projID).replaceAll('\$ISSUEID', issueID)}history/',
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      issueActivity = response.data;
      issueActivityState = StateEnum.success;
      notifyListeners();
    } on DioException catch (e) {
      log(e.response!.data.toString());
      issueActivityState = StateEnum.error;
      notifyListeners();
    }
  }

  Future getSubscriptionStatus({
    required String slug,
    required String projID,
    required String issueID,
    required HttpMethod httpMethod,
  }) async {
    try {
      subscriptionState = StateEnum.loading;
      notifyListeners();
      final response = await DioConfig().dioServe(
        hasAuth: true,
        url:
            '${APIs.issueDetails.replaceAll("\$SLUG", slug).replaceAll('\$PROJECTID', projID).replaceAll('\$ISSUEID', issueID)}subscribe/',
        hasBody: false,
        httpMethod: httpMethod,
      );
      log('getSubscriptionStatus ${response.data}');
      issueDetails['subscribed'] = httpMethod == HttpMethod.get
          ? response.data['subscribed']
          : httpMethod == HttpMethod.post
              ? true
              : false;
      subscriptionState = StateEnum.success;
      notifyListeners();
    } on DioException catch (e) {
      //  print('===== ERROR ');
      log(e.response.toString());
      subscriptionState = StateEnum.error;
      notifyListeners();
      return null;
    }
  }

  Future upDateIssue(
      {required String slug,
      required String projID,
      required String issueID,
      required Map data,
      required WidgetRef refs,
      BuildContext? buildContext}) async {
    final workspaceProvider = refs.watch(ProviderList.workspaceProvider);
    final projectProvider = refs.watch(ProviderList.projectProvider);
    try {
      updateIssueState = StateEnum.loading;
      notifyListeners();
      await DioConfig().dioServe(
          hasAuth: true,
          url: APIs.issueDetails
              .replaceAll("\$SLUG", slug)
              .replaceAll('\$PROJECTID', projID)
              .replaceAll('\$ISSUEID', issueID),
          hasBody: true,
          httpMethod: HttpMethod.patch,
          data: data);
      updateIssueState = StateEnum.success;
      postHogService(
          eventName: 'ISSUE_UPDATE',
          properties: {
            'WORKSPACE_ID': workspaceProvider.selectedWorkspace.workspaceId,
            'WORKSPACE_SLUG': workspaceProvider.selectedWorkspace.workspaceSlug,
            'WORKSPACE_NAME': workspaceProvider.selectedWorkspace.workspaceName,
            'PROJECT_ID': projID,
            'PROJECT_NAME': projectProvider.projects
                .firstWhere((element) => element['id'] == projID)['name'],
            'ISSUE_ID': issueID
          },
          ref: refs);
      await getIssueDetails(slug: slug, projID: projID, issueID: issueID);
      await getIssueActivity(slug: slug, projID: projID, issueID: issueID);
      await ref.read(ProviderList.myIssuesProvider.notifier).getMyIssues(
            slug: slug,
          );
      await ref.read(ProviderList.issuesProvider).filterIssues(
            slug: slug,
            projID: projID,
          );

      refs.read(ProviderList.issuesProvider).issuesResponse[refs
          .read(ProviderList.issuesProvider)
          .issuesResponse
          .indexWhere((element) => element["id"] == issueID)] = issueDetails;

      notifyListeners();
    } on DioException catch (e) {
      const String messageOnError = 'Something went wrong, please try again';
      if (buildContext != null) {
        CustomToast.showToast(buildContext,
            message: messageOnError, toastType: ToastType.failure, duration: 2);
      }

      log('Error : issue_provider : upDateIssue : ${e.message.toString()}');
      updateIssueState = StateEnum.error;
      notifyListeners();
    }
  }

  Future removeIssueAttachment(
      {required String projectId,
      required String slug,
      required String issueId,
      required String attachmentId,
      required int index}) async {
    try {
      updateIssueState = StateEnum.loading;
      notifyListeners();
      await DioConfig().dioServe(
        hasAuth: true,
        url:
            '${APIs.issueAttachments.replaceAll("\$SLUG", slug).replaceAll('\$PROJECTID', projectId).replaceAll('\$ISSUEID', issueId)}$attachmentId/',
        hasBody: true,
        httpMethod: HttpMethod.delete,
      );

      await getIssueDetails(slug: slug, projID: projectId, issueID: issueId);
      await getIssueActivity(slug: slug, projID: projectId, issueID: issueId);
      ref.read(ProviderList.issuesProvider).issuesResponse[index] =
          issueDetails;
      updateIssueState = StateEnum.success;
      notifyListeners();
    } on DioException catch (e) {
      log(e.response.toString());
      ScaffoldMessenger.of(Const.globalKey.currentContext!).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong, please try again!'),
        ),
      );
      updateIssueState = StateEnum.error;
      notifyListeners();
    }
  }

  Future addIssueAttachment(
      {required String filePath,
      required String projectId,
      required String slug,
      required String issueId,
      required int fileSize}) async {
    try {
      attachmentState = StateEnum.loading;
      notifyListeners();
      log(File(filePath).toString());
      final String fileName = filePath.split('/').last;
      final String type = filePath.split('.').last;

      final FormData formData = FormData.fromMap({
        "asset": await MultipartFile.fromFile(filePath,
            filename: fileName, contentType: MediaType('', type)),
        "attributes": json.encode(
          {
            "name": fileName,
            "size": fileSize,
          },
        ),
      });
      await Dio().post(
        APIs.issueAttachments
            .replaceAll("\$SLUG", slug)
            .replaceAll('\$PROJECTID', projectId)
            .replaceAll('\$ISSUEID', issueId),
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer ${Const.accessToken}',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      // await DioConfig().dioServe(
      //   hasAuth: true,
      //   url: APIs.issueAttachments
      //       .replaceAll("\$SLUG", slug)
      //       .replaceAll('\$PROJECTID', projectId)
      //       .replaceAll('\$ISSUEID', issueId),
      //   hasBody: true,
      //   httpMethod: HttpMethod.post,
      //   data: formData,
      // );
      await getIssueDetails(slug: slug, projID: projectId, issueID: issueId);
      await getIssueActivity(slug: slug, projID: projectId, issueID: issueId);
      attachmentState = StateEnum.success;
      ref.read(ProviderList.issuesProvider).issuesResponse[ref
          .read(ProviderList.issuesProvider)
          .issuesResponse
          .indexWhere((element) => element["id"] == issueId)] = issueDetails;

      notifyListeners();
    } on DioException catch (e) {
      log(e.response.toString());
      log(e.toString());
      ScaffoldMessenger.of(Const.globalKey.currentContext!).showSnackBar(
        SnackBar(
          content: e.response!.data['detail'] != null
              ? Text(e.response!.data['detail'].toString())
              : Text(e.response.toString()),
        ),
      );
      attachmentState = StateEnum.error;
      notifyListeners();
    }
  }

  Future addLink(
      {required String projectId,
      required String slug,
      required String issueId,
      required Map data,
      required CRUD method,
      required String linkId,
      BuildContext? buildContext}) async {
    try {
      addLinkState = StateEnum.loading;
      notifyListeners();
      final url = linkId == ''
          ? APIs.issuelinks
              .replaceAll("\$SLUG", slug)
              .replaceAll('\$PROJECTID', projectId)
              .replaceAll('\$ISSUEID', issueId)
          : '${APIs.issuelinks.replaceAll("\$SLUG", slug).replaceAll('\$PROJECTID', projectId).replaceAll('\$ISSUEID', issueId)}$linkId/';
      await DioConfig().dioServe(
          hasAuth: true,
          url: url,
          hasBody: true,
          httpMethod:
              method == CRUD.create ? HttpMethod.post : HttpMethod.delete,
          data: data);
      addLinkState = StateEnum.success;
      await getIssueDetails(slug: slug, projID: projectId, issueID: issueId);
      await getIssueActivity(slug: slug, projID: projectId, issueID: issueId);
      ref.read(ProviderList.issuesProvider).issuesResponse[ref
          .read(ProviderList.issuesProvider)
          .issuesResponse
          .indexWhere((element) => element["id"] == issueId)] = issueDetails;
      notifyListeners();
    } catch (e) {
      const String messageOnError = 'Something went wrong, please try again';
      if (buildContext != null) {
        CustomToast.showToast(buildContext,
            message: messageOnError, toastType: ToastType.failure, duration: 2);
      }
      if (e is DioException) {
        log(e.response.toString());
      }
      // print(e);
      ScaffoldMessenger.of(Const.globalKey.currentContext!).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong, please try again!'),
        ),
      );
      addLinkState = StateEnum.error;
      notifyListeners();
    }
  }

  Future getSubIssues({
    required String projectId,
    required String slug,
    required String issueId,
  }) async {
    getSubIssueState = StateEnum.loading;
    notifyListeners();
    try {
      //updateIssueState = StateEnum.loading;
      notifyListeners();
      final url = APIs.subIssues
          .replaceAll("\$SLUG", slug)
          .replaceAll('\$PROJECTID', projectId)
          .replaceAll('\$ISSUEID', issueId);
      final response = await DioConfig().dioServe(
        hasAuth: true,
        url: url,
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      subIssues.clear();
      subIssues = (response.data as Map).entries.first.value;
      getSubIssueState = StateEnum.success;
      // if(fromMyIssues) {
      // ref.read(ProviderList.issuesProvider).issuesResponse[index] =
      //     issueDetails;
      // }
      // else {

      // }
      notifyListeners();
    } catch (e) {
      if (e is DioException) {
        log(e.response.toString());
      } else {
        log(e.toString());
        ScaffoldMessenger.of(Const.globalKey.currentContext!).showSnackBar(
          const SnackBar(
            content: Text('Something went wrong, please try again!'),
          ),
        );
      }
      getSubIssueState = StateEnum.error;
      notifyListeners();
    }
  }

  Future setCookies({required String key, required String value}) async {
    if (value.isEmpty) return;
    final Uri baseWebUrl = Uri.parse(dotenv.env['EDITOR_URL']!);
    final cookieManager = CookieManager.instance();
    await cookieManager.setCookie(
      url: baseWebUrl,
      name: key,
      value: value,
    );
  }

  Future clearCookies() async {
    final cookieManager = CookieManager.instance();
    cookieManager.deleteAllCookies();
  }

  Future initCookies({String data = ""}) async {
    try {
      cookiesState = StateEnum.loading;
      final cookieManager = CookieManager.instance();
      cookieManager.deleteAllCookies();
      final Uri baseWebUrl = Uri.parse(dotenv.env['EDITOR_URL']!);
      if (data.isNotEmpty) {
        await cookieManager.setCookie(
          url: baseWebUrl,
          name: "data",
          value: data,
        );
      }
      await cookieManager.setCookie(
        url: baseWebUrl,
        name: "accessToken",
        value: Const.accessToken!,
      );
      await cookieManager.setCookie(
        url: baseWebUrl,
        name: "refreshToken",
        value: Const.refreshToken!,
      );
      // await cookieManager.getCookies(url: baseWebUrl).then((value) {
      //   log(value.toString());
      // });
      cookiesState = StateEnum.success;
      notifyListeners();
    } catch (e) {
      log(e.toString());
      cookiesState = StateEnum.error;
      notifyListeners();
    }
  }

  Future deleteSubIssue(
      {required String projectId,
      required String slug,
      required String issueId,
      required int index,
      BuildContext? buildContext}) async {
    try {
      notifyListeners();
      final url = APIs.issueDetails
          .replaceAll("\$SLUG", slug)
          .replaceAll('\$PROJECTID', projectId)
          .replaceAll('\$ISSUEID', issueId);
      await DioConfig().dioServe(
          hasAuth: true,
          url: url,
          hasBody: true,
          httpMethod: HttpMethod.patch,
          data: {'parent': null});

      notifyListeners();
    } catch (e) {
      if (e is DioException) {
        log(e.response.toString());
      }
      const String messageOnError = 'Something went wrong, please try again';
      if (buildContext != null) {
        CustomToast.showToast(buildContext,
            message: messageOnError, toastType: ToastType.failure, duration: 2);
      }

      notifyListeners();
    }
  }

  Future addSubIssue({
    required String projectId,
    required String slug,
    required String issueId,
    required Map data,
  }) async {
    try {
      addSubIssueState = StateEnum.loading;
      notifyListeners();
      final url = APIs.subIssues
          .replaceAll("\$SLUG", slug)
          .replaceAll('\$PROJECTID', projectId)
          .replaceAll('\$ISSUEID', issueId);
      await DioConfig().dioServe(
          hasAuth: true,
          url: url,
          hasBody: true,
          httpMethod: HttpMethod.post,
          data: data);
      getSubIssues(
        projectId: projectId,
        slug: slug,
        issueId: issueId,
      );
      addSubIssueState = StateEnum.success;
      notifyListeners();
    } catch (e) {
      if (e is DioException) {
        log(e.response.toString());
      }
      ScaffoldMessenger.of(Const.globalKey.currentContext!).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong, please try again!'),
        ),
      );
      addSubIssueState = StateEnum.error;
      notifyListeners();
    }
  }

  void clearData() {
    issueDetailState = StateEnum.loading;
    issueActivityState = StateEnum.loading;
    updateIssueState = StateEnum.empty;
    addSubIssueState = StateEnum.empty;
    issueDetails = {};
    issueActivity = [];
    notifyListeners();
  }

  void handleIssueDetailRedirection(
      {required BuildContext context,
      required ConsoleMessage msg,
      required PreviousScreen previousScreen}) async {
    log(msg.message);
    if (msg.message.startsWith('link')) {
      launchUrl(Uri.parse(msg.message.substring(5)));
    } else if (msg.message.startsWith("cycle")) {
      final Map data = json.decode(msg.message.substring(5));
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CycleDetail(
            from: previousScreen,
            cycleId: data['cycle_id'],
            projId: data['project_id'],
            cycleName: data['cycle_name'],
          ),
        ),
      );
    } else if (msg.message.startsWith("module")) {
      final Map data = json.decode(msg.message.substring(6));
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CycleDetail(
            from: previousScreen,
            fromModule: true,
            moduleId: data['module_id'],
            projId: data['project_id'],
            moduleName: data['module_name'],
          ),
        ),
      );
    } else if (msg.message.startsWith("issue")) {
      final Map data = json.decode(msg.message.substring(5));
      Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => IssueDetail(
                from: previousScreen,
                appBarTitle: data['issue_identifier'],
                projID: data['project_id'],
                issueId: data['issue_id'],
              )));
    } else if (msg.message.startsWith("toast")) {
      final Map data = json.decode(msg.message.substring(5));

      CustomToast.showToast(context,
          message: data['message'],
          toastType: data['type'] == 'success'
              ? ToastType.success
              : data['type'] == 'warning'
                  ? ToastType.warning
                  : ToastType.failure);
    } else if (msg.message.startsWith("user")) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserProfileScreen(
            userID: msg.message.substring(5),
          ),
        ),
      );
    }
  }
}
