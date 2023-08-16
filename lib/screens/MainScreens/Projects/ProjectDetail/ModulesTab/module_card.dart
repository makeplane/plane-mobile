import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:plane_startup/bottom_sheets/delete_module_sheet.dart';

import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/screens/MainScreens/Projects/ProjectDetail/CyclesTab/cycle_detail.dart';
import 'package:plane_startup/widgets/custom_text.dart';
import 'package:plane_startup/utils/constants.dart';
import '/utils/enums.dart';

// ignore: must_be_immutable
class ModuleCard extends ConsumerStatefulWidget {
  bool isFav;
  int index;
  ModuleCard({
    super.key,
    required this.index,
    required this.isFav,
  });

  @override
  ConsumerState<ModuleCard> createState() => _ModuleCardState();
}

class _ModuleCardState extends ConsumerState<ModuleCard> {
  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var modulesProvider = ref.watch(ProviderList.modulesProvider);
    return GestureDetector(
      onTap: () {
        modulesProvider.currentModule = widget.isFav
            ? modulesProvider.favModules[widget.index]
            : modulesProvider.modules[widget.index];
        modulesProvider.setState();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CycleDetail(
              moduleId: widget.isFav
                  ? modulesProvider.favModules[widget.index]['id']
                  : modulesProvider.modules[widget.index]['id'],
              moduleName: widget.isFav
                  ? modulesProvider.favModules[widget.index]['name']
                  : modulesProvider.modules[widget.index]['name'],
              fromModule: true,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(top: 15),
        decoration: BoxDecoration(
            color: themeProvider.themeManager.primaryBackgroundDefaultColor,
            border: Border.all(
              color: Colors.grey.shade300,
            ),
            //elevation
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
                  child: CustomText(
                    widget.isFav
                        ? modulesProvider.favModules[widget.index]['name']
                            .toString()
                        : modulesProvider.modules[widget.index]['name']
                            .toString(),
                    overflow: TextOverflow.ellipsis,
                    type: FontStyle.H5,
                  ),
                ),
                const Spacer(),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 3, bottom: 3),
                  color: themeProvider.isDarkThemeEnabled
                      ? darkSecondaryBGC
                      : lightSecondaryBackgroundColor,
                  height: 28,
                  child: Row(
                    children: [
                      // Container(
                      //   height: 20,
                      //   width: 20,
                      //   decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(20),
                      //       border: Border.all(
                      //         color: const Color.fromRGBO(172, 181, 189, 1),
                      //       )),
                      // ),
                      // const SizedBox(
                      //   width: 10,
                      // ),
                      CustomText(
                        widget.isFav
                            ? modulesProvider.favModules[widget.index]['status']
                                .toString()
                            : modulesProvider.modules[widget.index]['status']
                                .toString(),
                        type: FontStyle.Medium,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: widget.isFav
                      ? IconButton(
                          visualDensity: VisualDensity.compact,
                          onPressed: () async {
                            String moduleID =
                                modulesProvider.favModules[widget.index]['id'];
                            modulesProvider.modules
                                .add(modulesProvider.favModules[widget.index]);
                            modulesProvider.favModules.removeAt(widget.index);
                            modulesProvider.setState();
                            modulesProvider.favouriteModule(
                              slug: ref
                                  .read(ProviderList.workspaceProvider)
                                  .selectedWorkspace!
                                  .workspaceSlug,
                              projId: ref
                                  .read(ProviderList.projectProvider)
                                  .currentProject['id'],
                              moduleId: moduleID,
                              isFav: true,
                            );
                          },
                          icon: Icon(
                            Icons.star,
                            color: themeProvider.themeManager.tertiaryTextColor,
                          ))
                      : IconButton(
                          onPressed: () async {
                            String moduleId =
                                modulesProvider.modules[widget.index]['id'];
                            modulesProvider.favModules
                                .add(modulesProvider.modules[widget.index]);
                            modulesProvider.modules.removeAt(widget.index);
                            modulesProvider.setState();
                            modulesProvider.favouriteModule(
                              slug: ref
                                  .read(ProviderList.workspaceProvider)
                                  .selectedWorkspace!
                                  .workspaceSlug,
                              projId: ref
                                  .read(ProviderList.projectProvider)
                                  .currentProject['id'],
                              moduleId: moduleId,
                              isFav: false,
                            );
                          },
                          icon: Icon(
                            Icons.star_border,
                            color:
                                themeProvider.themeManager.placeholderTextColor,
                          )),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: IconButton(
                      visualDensity: VisualDensity.compact,
                      //remove extra margin
                      padding: const EdgeInsets.all(0),
                      splashRadius: 2,
                      onPressed: () {
                        //show bottom sheet
                        showModalBottomSheet(
                            context: context,
                            constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.4),
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20))),
                            builder: (context) {
                              return DeleteModules(
                                moduleId: widget.isFav
                                    ? modulesProvider.favModules[widget.index]
                                        ['id']
                                    : modulesProvider.modules[widget.index]
                                        ['id'],
                              );
                            });
                      },
                      icon: Icon(
                        Icons.more_vert,
                        color: themeProvider.isDarkThemeEnabled
                            ? darkPrimaryTextColor
                            : lightPrimaryTextColor,
                      )),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_month,
                    color: themeProvider.isDarkThemeEnabled
                        ? darkPrimaryTextColor
                        : lightPrimaryTextColor,
                    size: 18,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  CustomText(
                    //convert yyyy-mm-dd to month_name day, year
                    widget.isFav
                        ? DateFormat('MMM dd, yyyy').format(DateTime.parse(
                            (modulesProvider.favModules[widget.index]
                                        ['start_date'] ??
                                    DateTime.now())
                                .toString()))
                        : DateFormat('MMM dd, yyyy').format(DateTime.parse(
                            (modulesProvider.modules[widget.index]
                                        ['start_date'] ??
                                    DateTime.now())
                                .toString())),

                    type: FontStyle.Small,
                  ),
                  const SizedBox(
                    width: 40,
                  ),
                  Icon(
                    Icons.my_location_sharp,
                    size: 18,
                    color: themeProvider.isDarkThemeEnabled
                        ? darkPrimaryTextColor
                        : lightPrimaryTextColor,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  CustomText(
                    widget.isFav
                        ? DateFormat('MMM dd, yyyy').format(DateTime.parse(
                            (modulesProvider.favModules[widget.index]
                                        ['target_date'] ??
                                    DateTime.now())
                                .toString()))
                        : DateFormat('MMM dd, yyyy').format(DateTime.parse(
                            (modulesProvider.modules[widget.index]
                                        ['target_date'] ??
                                    DateTime.now())
                                .toString())),
                    type: FontStyle.Small,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            // Container(
            //   padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
            //   child: Row(
            //     children: [
            //       Container(
            //         height: 20,
            //         width: 20,
            //         decoration: BoxDecoration(
            //             color: Colors.amber,
            //             borderRadius: BorderRadius.circular(15)),
            //       ),
            //       const SizedBox(
            //         width: 10,
            //       ),
            //       CustomText(
            //         ' Vamsi Kurama',
            //         type: FontStyle.Medium,
            //       ),
            //     ],
            //   ),
            // ),
            const SizedBox(
              height: 15,
            ),
            Container(
              height: 1,
              color: Colors.grey.shade300,
            ),
            Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 15),
                height: 40,
                //color: const Color.fromRGBO(250, 250, 250, 1),
                child: Row(
                  children: [
                    const CustomText(
                      'Progress',
                      type: FontStyle.Small,
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.47,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          backgroundColor: Colors.grey.shade300,
                          color: greenHighLight,
                          value: widget.isFav
                              ? ((modulesProvider.favModules[widget.index]
                                              ['completed_issues'] ??
                                          0)
                                      .toDouble() /
                                  (modulesProvider.favModules[widget.index]
                                              ['total_issues'] ==
                                          0
                                      ? 1
                                      : modulesProvider.favModules[widget.index]
                                          ['total_issues']))
                              : ((modulesProvider.modules[widget.index]
                                              ['completed_issues'] ??
                                          0)
                                      .toDouble() /
                                  (modulesProvider.modules[widget.index]['total_issues'] == 0
                                      ? 1
                                      : modulesProvider.modules[widget.index]
                                          ['total_issues'])),
                          minHeight: 5,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    CustomText(
                      widget.isFav
                          ? '${(((modulesProvider.favModules[widget.index]['completed_issues'] ?? 0).toDouble() / (modulesProvider.favModules[widget.index]['total_issues'] == 0 ? 1 : modulesProvider.favModules[widget.index]['total_issues'])) * 100).toStringAsFixed(2)} %'
                          : '${(((modulesProvider.modules[widget.index]['completed_issues'] ?? 0).toDouble() / (modulesProvider.modules[widget.index]['total_issues'] == 0 ? 1 : modulesProvider.modules[widget.index]['total_issues'])) * 100).toStringAsFixed(2)} %',
                      type: FontStyle.Small,
                    ),
                    const SizedBox(
                      width: 15,
                    )
                  ],
                )),
            Container(
              padding: const EdgeInsets.only(bottom: 15),
              //color: const Color.fromRGBO(250, 250, 250, 1),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 15, top: 20),
                    child: const CustomText(
                      'Last Updated: ',
                      type: FontStyle.Medium,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 15, top: 20),
                    // child: const Text(
                    //   '12 March, 2023',
                    //   style: TextStyle(fontSize: 15, color: Colors.blacklack),
                    // ),
                    child: CustomText(
                      //convert "2023-05-04T18":"30":"46.473850+05":30, to month_name day, year
                      widget.isFav
                          ? DateFormat('MMM dd, yyyy').format(DateTime.parse(
                              modulesProvider.favModules[widget.index]
                                      ['updated_at']
                                  .toString()))
                          : DateFormat('MMM dd, yyyy').format(DateTime.parse(
                              modulesProvider.modules[widget.index]
                                      ['updated_at']
                                  .toString())),
                      type: FontStyle.Medium,
                    ),
                  ),
                  const Spacer(),
                  widget.isFav
                      ? (modulesProvider.favModules[widget.index]
                                      ['members_detail'] !=
                                  null &&
                              modulesProvider
                                  .favModules[widget.index]['members_detail']
                                  .isNotEmpty)
                          ? SizedBox(
                              height: 30,
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: themeProvider
                                            .themeManager.borderSubtle01Color),
                                    borderRadius: BorderRadius.circular(5)),
                                height: 30,
                                margin: const EdgeInsets.only(right: 5),
                                width: (modulesProvider
                                            .favModules[widget.index]
                                                ['members_detail']
                                            .length *
                                        22.0) +
                                    ((modulesProvider
                                                .favModules[widget.index]
                                                    ['members_detail']
                                                .length) ==
                                            1
                                        ? 15
                                        : 0),
                                child: Stack(
                                  alignment: Alignment.center,
                                  fit: StackFit.passthrough,
                                  children: (modulesProvider
                                              .favModules[widget.index]
                                          ['members_detail'] as List)
                                      .map((e) => Positioned(
                                            right: ((modulesProvider.favModules[
                                                                    widget
                                                                        .index][
                                                                'members_detail']
                                                            as List)
                                                        .indexOf(e) *
                                                    15) +
                                                10,
                                            child: Container(
                                              height: 20,
                                              alignment: Alignment.center,
                                              width: 20,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Color.fromRGBO(
                                                    55, 65, 81, 1),
                                                // image: DecorationImage(
                                                //   image: NetworkImage(
                                                //       e['profileUrl']),
                                                //   fit: BoxFit.cover,
                                                // ),
                                              ),
                                              child: CustomText(
                                                e['first_name'][0]
                                                    .toString()
                                                    .toUpperCase(),
                                                type: FontStyle.Small,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                ),
                              ))
                          : Container(
                              height: 30,
                              margin: const EdgeInsets.only(right: 5),
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, top: 5, bottom: 5),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: themeProvider
                                          .themeManager.borderSubtle01Color),
                                  borderRadius: BorderRadius.circular(5)),
                              child: const Icon(
                                Icons.groups_2_outlined,
                                size: 18,
                                color: greyColor,
                              ),
                            )
                      : (modulesProvider.modules[widget.index]
                                      ['members_detail'] !=
                                  null &&
                              modulesProvider
                                  .modules[widget.index]['members_detail']
                                  .isNotEmpty)
                          ? SizedBox(
                              height: 30,
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: themeProvider
                                            .themeManager.borderSubtle01Color),
                                    borderRadius: BorderRadius.circular(5)),
                                height: 30,
                                margin: const EdgeInsets.only(right: 5),
                                width: (modulesProvider
                                            .modules[widget.index]
                                                ['members_detail']
                                            .length *
                                        22.0) +
                                    ((modulesProvider
                                                .modules[widget.index]
                                                    ['members_detail']
                                                .length) ==
                                            1
                                        ? 15
                                        : 0),
                                child: Stack(
                                  alignment: Alignment.center,
                                  fit: StackFit.passthrough,
                                  children: (modulesProvider
                                              .modules[widget.index]
                                          ['members_detail'] as List)
                                      .map((e) => Positioned(
                                            right: ((modulesProvider.modules[
                                                                    widget
                                                                        .index][
                                                                'members_detail']
                                                            as List)
                                                        .indexOf(e) *
                                                    15) +
                                                10,
                                            child: Container(
                                              height: 20,
                                              alignment: Alignment.center,
                                              width: 20,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Color.fromRGBO(
                                                    55, 65, 81, 1),
                                                // image: DecorationImage(
                                                //   image: NetworkImage(
                                                //       e['profileUrl']),
                                                //   fit: BoxFit.cover,
                                                // ),
                                              ),
                                              child: CustomText(
                                                e['first_name'][0]
                                                    .toString()
                                                    .toUpperCase(),
                                                type: FontStyle.Small,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                ),
                              ))
                          : Container(
                              height: 30,
                              margin: const EdgeInsets.only(right: 5),
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, top: 5, bottom: 5),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: themeProvider
                                          .themeManager.borderSubtle01Color),
                                  borderRadius: BorderRadius.circular(5)),
                              child: const Icon(
                                Icons.groups_2_outlined,
                                size: 18,
                                color: greyColor,
                              ),
                            ),

                  // Stack(
                  //   children: [
                  //     Container(
                  //       margin: const EdgeInsets.only(left: 30, top: 15),
                  //       height: 20,
                  //       width: 20,
                  //       decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(25),
                  //           color: const Color.fromRGBO(247, 174, 89, 1)),
                  //     ),
                  //     Container(
                  //       margin: const EdgeInsets.only(left: 15, top: 15),
                  //       height: 20,
                  //       width: 20,
                  //       decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(25),
                  //           color: const Color.fromRGBO(140, 193, 255, 1)),
                  //     ),
                  //     Container(
                  //       margin: const EdgeInsets.only(top: 15),
                  //       height: 20,
                  //       width: 20,
                  //       decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(25),
                  //           color: const Color.fromRGBO(30, 57, 88, 1)),
                  //     ),
                  //   ],
                  // ),
                  const SizedBox(
                    width: 15,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
