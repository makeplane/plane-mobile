import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/config/apis.dart';
import 'package:plane_startup/models/global_search_modal.dart';
import 'package:plane_startup/services/dio_service.dart';
import 'package:plane_startup/utils/enums.dart';

class SearchModal {
  StateEnum globalSearchState = StateEnum.loading;
  GlobalSearchModal? data;

  SearchModal({required this.globalSearchState, required this.data});

  SearchModal copyWith(
      {StateEnum? globalSearchState, GlobalSearchModal? data}) {
    return SearchModal(
        data: data,
        globalSearchState: globalSearchState ?? this.globalSearchState);
  }
}

class GlobalSearchProvider extends StateNotifier<SearchModal> {
  GlobalSearchProvider(
      StateNotifierProviderRef<GlobalSearchProvider, SearchModal> this.ref)
      : super(SearchModal(data: null, globalSearchState: StateEnum.empty));
  Ref ref;

  Future getGlobalData({required String slug, String? input}) async {
    var url =
        '${APIs.globalSearch.replaceFirst('\$SLUG', slug)}?search=$input&workspace_search=true';
    log("REQUEST URL: $url");
    try {
      var response = await DioConfig().dioServe(
        hasAuth: true,
        url: url,
        hasBody: false,
        httpMethod: HttpMethod.get,
      );
      // data = null;
      // data.clear();
      // state.copyWith(data: null);
      state = state.copyWith(
          data: GlobalSearchModal.fromJson(response.data),
          globalSearchState: StateEnum.success);
    } catch (e) {
      if (e is DioException) {
        log(e.error.toString());
      }
      log(e.toString());
      state = state.copyWith(globalSearchState: StateEnum.error);
    }
  }

  setState() {
    state = state.copyWith(data: null);
  }
}
