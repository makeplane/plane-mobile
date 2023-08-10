import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/config/const.dart';
import 'package:plane_startup/utils/custom_toast.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/config/apis.dart';
import 'package:plane_startup/services/dio_service.dart';

class IssueProvider with ChangeNotifier {
  IssueProvider(ChangeNotifierProviderRef<IssueProvider> this.ref);
  Ref ref;
  StateEnum issueDetailState = StateEnum.empty;
  StateEnum issueActivityState = StateEnum.empty;
  StateEnum subscriptionState = StateEnum.empty;

  // set setUpdateIssueState(StateEnum value) {
  //   updateIssueState = value;
  //   print('SABI : setUpdateIssueState to $value');
  // }

  StateEnum updateIssueState = StateEnum.empty;
  StateEnum attachmentState = StateEnum.empty;
  StateEnum addLinkState = StateEnum.empty;
  StateEnum getSubIssueState = StateEnum.empty;
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
    //updateIssueState = StateEnum.empty;
    addLinkState = StateEnum.empty;
    getSubIssueState = StateEnum.empty;
    issueDetails = {};
    // subIssues = {};
    issueActivity = [];
    cyclesList = [];
  }

  //Future getIssueDetailsBlockedIssue()

  Future getIssueDetails(
      {required String slug,
      required String projID,
      required String issueID}) async {
    try {
      var issuesProvider = ref.read(ProviderList.issuesProvider);
      var response = await DioConfig().dioServe(
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
    
      var response = await DioConfig().dioServe(
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
      var response = await DioConfig().dioServe(
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
      await getIssueDetails(slug: slug, projID: projID, issueID: issueID);
      await getIssueActivity(slug: slug, projID: projID, issueID: issueID);
      await ref.read(ProviderList.myIssuesProvider.notifier).getMyIssues(
            slug: slug,
          );

      refs.read(ProviderList.issuesProvider).issuesResponse[refs
          .read(ProviderList.issuesProvider)
          .issuesResponse
          .indexWhere((element) => element["id"] == issueID)] = issueDetails;

      notifyListeners();
    } on DioException catch (e) {
      const String messageOnError = 'Something went wrong, please try again';
      buildContext == null
          ? CustomToast().showSimpleToast(messageOnError)
          : CustomToast().showToast(buildContext, messageOnError, duration: 2);

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
      String fileName = filePath.split('/').last;
      String type = filePath.split('.').last;

      FormData formData = FormData.fromMap({
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
            'Authorization': 'Bearer ${Const.appBearerToken}',
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
      ref.read(ProviderList.issuesProvider).issuesResponse[ref
          .read(ProviderList.issuesProvider)
          .issuesResponse
          .indexWhere((element) => element["id"] == issueId)] = issueDetails;
      attachmentState = StateEnum.success;
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
      var url = linkId == ''
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
      buildContext == null
          ? CustomToast().showSimpleToast(messageOnError)
          : CustomToast().showToast(buildContext, messageOnError, duration: 2);
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
      var url = APIs.subIssues
          .replaceAll("\$SLUG", slug)
          .replaceAll('\$PROJECTID', projectId)
          .replaceAll('\$ISSUEID', issueId);
      var response = await DioConfig().dioServe(
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

  Future deleteSubIssue(
      {required String projectId,
      required String slug,
      required String issueId,
      required int index,
      BuildContext? buildContext}) async {
    try {
      notifyListeners();
      var url = APIs.issueDetails
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
      buildContext == null
          ? CustomToast().showSimpleToast(messageOnError)
          : CustomToast().showToast(buildContext, messageOnError, duration: 2);

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
      notifyListeners();
      var url = APIs.subIssues
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
      notifyListeners();
    }
  }

  clearData() {
    issueDetailState = StateEnum.loading;
    issueActivityState = StateEnum.loading;
    updateIssueState = StateEnum.empty;
    issueDetails = {};
    issueActivity = [];
    notifyListeners();
  }
}
