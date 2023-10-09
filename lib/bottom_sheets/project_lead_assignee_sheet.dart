import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/mixins/widget_state_mixin.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/utils/constants.dart';
import 'package:plane/utils/enums.dart';
import 'package:plane/widgets/custom_text.dart';

class ProjectLeadAssigneeSheet extends ConsumerStatefulWidget {
  const ProjectLeadAssigneeSheet(
      {required this.title,
      required this.leadId,
      required this.assigneId,
      super.key});
  final String title;
  final String leadId;
  final String assigneId;

  @override
  ConsumerState<ProjectLeadAssigneeSheet> createState() =>
      _ProjectLeadAssigneeSheetState();
}

class _ProjectLeadAssigneeSheetState
    extends ConsumerState<ProjectLeadAssigneeSheet> with WidgetStateMixin {
  int currentIndex = 0;
  double height = 0;

  @override
  LoadingType getLoading(WidgetRef ref) {
    return setWidgetState(
        [ref.read(ProviderList.projectProvider).updateProjectState],
        allowError: false, loadingType: LoadingType.wrap);
  }

  @override
  Widget render(BuildContext context) {
    final projectProvider = ref.watch(ProviderList.projectProvider);
    final themeProvider = ref.watch(ProviderList.themeProvider);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final box = context.findRenderObject() as RenderBox;
      height = box.size.height;
    });
    return SizedBox(
      // height: height * 0.7,
      child:
          //  LoadingWidget(
          //   loading: projectProvider.updateProjectState == StateEnum.loading,
          //   allowBorderRadius: true,
          //   widgetClass:
          Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Wrap(
                children: [
                  Container(
                    height: 50,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: projectProvider.projectMembers.length,
                    padding:
                        EdgeInsets.only(bottom: bottomSheetConstBottomPadding),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              currentIndex = index;
                            });
                            widget.title == 'Lead '
                                ? projectProvider
                                    .updateProjectLead(
                                        leadId: widget.leadId,
                                        index: index,
                                        ref: ref)
                                    .then((value) => Navigator.pop(context))
                                : projectProvider
                                    .updateProjectAssignee(
                                      assigneeId: widget.assigneId,
                                      index: index,
                                      ref: ref,
                                    )
                                    .then((value) => Navigator.pop(context));
                          },
                          child: Row(
                            children: [
                              projectProvider.projectMembers[index]['member']
                                              ['avatar'] ==
                                          null ||
                                      projectProvider.projectMembers[index]
                                              ['member']['avatar'] ==
                                          ""
                                  ? CircleAvatar(
                                      radius: 20,
                                      backgroundColor: strokeColor,
                                      child: Center(
                                        child: CustomText(
                                          projectProvider.projectMembers[index]
                                                  ['member']['display_name'][0]
                                              .toString()
                                              .toUpperCase(),
                                          color: Colors.black,
                                          type: FontStyle.Medium,
                                          fontWeight: FontWeightt.Semibold,
                                        ),
                                      ),
                                    )
                                  : CircleAvatar(
                                      radius: 16,
                                      backgroundImage: NetworkImage(
                                          projectProvider.projectMembers[index]
                                              ['member']['avatar']),
                                    ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: CustomText(
                                  '${projectProvider.projectMembers[index]['member']['display_name']}',
                                  type: FontStyle.Medium,
                                  maxLines: 1,
                                  color: themeProvider
                                      .themeManager.primaryTextColor,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              (widget.title == 'Lead '
                                          ? widget.leadId
                                          : widget.assigneId) ==
                                      projectProvider.projectMembers[index]
                                          ['member']['id']
                                  ? Icon(
                                      Icons.check,
                                      color: themeProvider
                                          .themeManager.textSuccessColor,
                                    )
                                  : Container()
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Container(
              height: 50,
              color: themeProvider.themeManager.primaryBackgroundDefaultColor,
              child: Row(
                children: [
                  CustomText(
                    'Select ${widget.title}',
                    type: FontStyle.H4,
                    fontWeight: FontWeightt.Semibold,
                    color: themeProvider.themeManager.primaryTextColor,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.close,
                      size: 27,
                      color: themeProvider.themeManager.placeholderTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // ),
    );
  }
}
