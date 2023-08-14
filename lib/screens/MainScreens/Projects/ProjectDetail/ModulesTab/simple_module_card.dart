import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import '/utils/enums.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/widgets/custom_text.dart';
import 'package:plane_startup/utils/constants.dart';
import 'package:plane_startup/screens/MainScreens/Projects/ProjectDetail/CyclesTab/cycle_detail.dart';

class SimpleModuleCard extends ConsumerStatefulWidget {
  const SimpleModuleCard({
    super.key,
    required this.index,
    required this.isFav,
  });

  final bool isFav;
  final int index;

  @override
  ConsumerState<SimpleModuleCard> createState() => _SimpleModuleCardState();
}

class _SimpleModuleCardState extends ConsumerState<SimpleModuleCard> {
  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var modulesProvider = ref.watch(ProviderList.modulesProvider);
    return GestureDetector(
      onTap: () {
        modulesProvider.currentModule = widget.isFav
            ? modulesProvider.favModules[widget.index]
            : modulesProvider.modules[widget.index];
        // modulesProvider.setState();
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
                color: themeProvider.isDarkThemeEnabled
                    ? darkThemeBorder
                    : strokeColor,
                width: 1),
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset('assets/svg_images/group.svg',
                      width: 17,
                      height: 17,
                      colorFilter: ColorFilter.mode(
                          themeProvider.themeManager.primaryTextColor,
                          BlendMode.srcIn)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomText(
                      widget.isFav
                          ? modulesProvider.favModules[widget.index]['name']
                              .toString()
                          : modulesProvider.modules[widget.index]['name']
                              .toString(),
                      overflow: TextOverflow.ellipsis,
                      type: FontStyle.H6,
                      fontWeight: FontWeightt.Medium,
                      color: themeProvider.themeManager.primaryTextColor,
                    ),
                  ),
                  SizedBox(
                    //color:const Color.fromARGB(255, 240, 253, 244), // success 10
                    height: 28,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: CustomText(
                          widget.isFav
                              ? '${(((modulesProvider.favModules[widget.index]['completed_issues'] ?? 0).toDouble() / (modulesProvider.favModules[widget.index]['total_issues'] == 0 ? 1 : modulesProvider.favModules[widget.index]['total_issues'])) * 100).toStringAsFixed(0)} %'
                              : '${(((modulesProvider.modules[widget.index]['completed_issues'] ?? 0).toDouble() / (modulesProvider.modules[widget.index]['total_issues'] == 0 ? 1 : modulesProvider.modules[widget.index]['total_issues'])) * 100).toStringAsFixed(0)} %',
                          type: FontStyle.Small,
                          fontWeight: FontWeightt.Regular,
                          color: const Color.fromARGB(255, 34, 197, 94),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    child: widget.isFav
                        ? GestureDetector(
                            //visualDensity: VisualDensity.compact,
                            onTap: () async {
                              String moduleID = modulesProvider
                                  .favModules[widget.index]['id'];
                              modulesProvider.modules.add(
                                  modulesProvider.favModules[widget.index]);
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
                            child: Icon(
                              Icons.star,
                              color: themeProvider.themeManager.secondaryIcon,
                            ))
                        : GestureDetector(
                            onTap: () async {
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
                            child: Icon(Icons.star_border,
                                color: themeProvider
                                    .themeManager.placeholderTextColor),
                          ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                margin: const EdgeInsets.only(left: 25),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color:
                      themeProvider.themeManager.tertiaryBackgroundDefaultColor,
                ),
                child: CustomText(
                    widget.isFav
                        ? modulesProvider.favModules[widget.index]['status']
                            .toString()
                        : modulesProvider.modules[widget.index]['status']
                            .toString(),
                    type: FontStyle.Small,
                    fontWeight: FontWeightt.Regular,
                    color: themeProvider.themeManager.tertiaryTextColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
