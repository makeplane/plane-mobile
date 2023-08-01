
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/screens/MainScreens/Projects/ProjectDetail/PagesTab/page_card.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/widgets/loading_widget.dart';
import 'package:plane_startup/widgets/empty.dart';

class PageScreen extends ConsumerStatefulWidget {
  const PageScreen({super.key});

  @override
  ConsumerState<PageScreen> createState() => _PageScreenState();
}

class _PageScreenState extends ConsumerState<PageScreen> {
  @override
  Widget build(BuildContext context) {
    var pageProvider = ref.watch(ProviderList.pageProvider);
    return LoadingWidget(
      loading: pageProvider.pagesListState == StateEnum.loading ,
         
      widgetClass: Padding(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: pageProvider.pages[pageProvider.selectedFilter]!.isNotEmpty
            ? SingleChildScrollView(
                child: Column(
                  children: [
                       ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: pageProvider.pages[pageProvider.selectedFilter]!.length,
                            itemBuilder: (context, index) {
                              return PageCard(
                                  index: index);
                            },
                          ),
                 
                  ],
                ),
              )
            : EmptyPlaceholder.emptyPages(context),
      ),
    );
  }
}
