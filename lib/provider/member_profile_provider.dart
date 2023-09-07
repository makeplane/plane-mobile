import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/utils/enums.dart';

import '../config/apis.dart';
import '../services/dio_service.dart';
import 'provider_list.dart';

class MemberProfileStateModel {
  Map<String, dynamic> memberProfile;
  StateEnum getMemberProfileState;

  MemberProfileStateModel({
    required this.memberProfile,
    required this.getMemberProfileState,
  });

  MemberProfileStateModel copyWith({
    Map<String, dynamic>? memberProfile,
    StateEnum? getMemberProfileState,
  }) {
    return MemberProfileStateModel(
      memberProfile: memberProfile ?? this.memberProfile,
      getMemberProfileState:
          getMemberProfileState ?? this.getMemberProfileState,
    );
  }
}

class MemberProfileProvider extends StateNotifier<MemberProfileStateModel> {
  MemberProfileProvider(this.ref)
      : super(MemberProfileStateModel(
            getMemberProfileState: StateEnum.loading, memberProfile: {}));
  Ref ref;
  Future getMemberProfile({required String userID}) async {
    state.getMemberProfileState = StateEnum.loading;
    try {
      var workspaceSlug = ref
          .read(ProviderList.workspaceProvider)
          .selectedWorkspace!
          .workspaceSlug;
      var response = await DioConfig().dioServe(
        url: APIs.memberProfile
            .replaceAll('\$SLUG', workspaceSlug)
            .replaceAll('\$USERID', userID),
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      state = state.copyWith(
          getMemberProfileState: StateEnum.success,
          memberProfile: response.data);
      return state.memberProfile;
    } on DioException catch (err) {
      state = state.copyWith(getMemberProfileState: StateEnum.error);
      log(err.message.toString());
    }
  }
}
