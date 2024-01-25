import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/screens/project/issues/create_issue.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_text.dart';

class ListLayoutRoot extends ConsumerStatefulWidget {
  const ListLayoutRoot({super.key});

  @override
  ConsumerState<ListLayoutRoot> createState() => _ListLayoutRootState();
}

class _ListLayoutRootState extends ConsumerState<ListLayoutRoot> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final issuesProvider = ref.watch(ProviderList.issuesProvider);
    final projectProvider = ref.watch(ProviderList.projectProvider);
    return Container(
      color: themeProvider.themeManager.secondaryBackgroundDefaultColor,
      margin: const EdgeInsets.only(top: 5),
      child: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: issuesProvider.issues.issues
                .map((state) => state.items.isEmpty &&
                        !issuesProvider.showEmptyStates
                    ? Container()
                    : SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              // padding: const EdgeInsets.only(left: 15),
                              margin: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                children: [
                                  state.leading ?? Container(),
                                  Container(
                                    padding: const EdgeInsets.only(
                                      left: 10,
                                    ),
                                    child: CustomText(
                                      state.title!,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      type: FontStyle.Large,
                                      color: themeProvider
                                          .themeManager.primaryTextColor,
                                      fontWeight: FontWeightt.Semibold,
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.only(
                                      left: 15,
                                    ),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: themeProvider.themeManager
                                            .tertiaryBackgroundDefaultColor),
                                    height: 25,
                                    width: 30,
                                    child: CustomText(
                                      state.items.length.toString(),
                                      type: FontStyle.Small,
                                    ),
                                  ),
                                  const Spacer(),
                                  projectProvider.role == Role.admin ||
                                          projectProvider.role == Role.member
                                      ? IconButton(
                                          onPressed: () {
                                            if (issuesProvider.issues.groupBY ==
                                                GroupBY.state) {
                                              issuesProvider.createIssuedata[
                                                  'state'] = state.id;
                                            }
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (ctx) =>
                                                        const CreateIssue()));
                                          },
                                          icon: Icon(
                                            Icons.add,
                                            color: themeProvider
                                                .themeManager.tertiaryTextColor,
                                          ))
                                      : Container(
                                          height: 40,
                                        ),
                                ],
                              ),
                            ),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: state.items.map((e) => e).toList()),
                            state.items.isEmpty
                                ? Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    width: MediaQuery.of(context).size.width,
                                    color: themeProvider.themeManager
                                        .primaryBackgroundDefaultColor,
                                    padding: const EdgeInsets.only(
                                        top: 15, bottom: 15, left: 15),
                                    child: const CustomText(
                                      'No issues.',
                                      type: FontStyle.Small,
                                      maxLines: 10,
                                      textAlign: TextAlign.start,
                                    ),
                                  )
                                : Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                  )
                          ],
                        ),
                      ))
                .toList()),
      ),
    );
  }
}
