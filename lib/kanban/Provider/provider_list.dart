import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'board_list_provider.dart';
import 'board_provider.dart';
import 'list_item_provider.dart';

class ProviderList {

  static Map<String, ChangeNotifierProvider<BoardProvider>> boardProviders = {};

  static Map<String, ChangeNotifierProvider<ListItemProvider>> cardProviders =
      {};

  static Map<String, ChangeNotifierProvider<BoardListProvider>>
      boardListProviders = {};
}
