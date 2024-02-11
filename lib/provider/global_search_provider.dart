import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/config/apis.dart';
import 'package:plane/models/global_search_modal.dart';
import 'package:plane/core/dio/dio_service.dart';
import 'package:plane/utils/enums.dart';

class SearchModal {
  SearchModal({required this.globalSearchState, required this.data});
  factory SearchModal.initialize() {
    return SearchModal(
        data: GlobalSearchModal.initialize(),
        globalSearchState: DataState.empty);
  }
  DataState globalSearchState = DataState.loading;
  GlobalSearchModal? data;

  SearchModal copyWith(
      {DataState? globalSearchState, GlobalSearchModal? data}) {
    return SearchModal(
        data: data,
        globalSearchState: globalSearchState ?? this.globalSearchState);
  }
}

class GlobalSearchProvider extends StateNotifier<SearchModal> {
  GlobalSearchProvider(
      StateNotifierProviderRef<GlobalSearchProvider, SearchModal> this.ref)
      : super(SearchModal(data: null, globalSearchState: DataState.empty));
  Ref ref;

  Future getGlobalData({required String slug, String? input}) async {
    final url =
        '${APIs.globalSearch.replaceFirst('\$SLUG', slug)}?search=$input&workspace_search=true';
    log("REQUEST URL: $url");
    try {
      final response = await DioClient().request(
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
          globalSearchState: DataState.success);
    } catch (e) {
      if (e is DioException) {
        log(e.error.toString());
      }
      log(e.toString());
      state = state.copyWith(globalSearchState: DataState.error);
    }
  }

  void clear() {
    state = state.copyWith(data: null);
  }
}
