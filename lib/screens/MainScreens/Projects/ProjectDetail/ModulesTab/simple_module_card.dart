import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:plane/bottom_sheets/delete_cycle_sheet.dart';
import 'package:plane/utils/string_manager.dart';
import '/utils/enums.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/widgets/custom_text.dart';
import 'package:plane/screens/MainScreens/Projects/ProjectDetail/CyclesTab/cycle_detail.dart';

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
    final themeProvider = ref.watch(ProviderList.themeProvider);
    final modulesProvider = ref.watch(ProviderList.modulesProvider);
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
            boxShadow: themeProvider.themeManager.theme == THEME.light
                ? themeProvider.themeManager.shadowXXS
                : null,
            color: themeProvider.themeManager.primaryBackgroundDefaultColor,
            border: themeProvider.themeManager.theme == THEME.light
                ? null
                : Border.all(
                    color: themeProvider.themeManager.borderSubtle01Color,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: SvgPicture.asset('assets/svg_images/group.svg',
                        width: 16,
                        height: 16,
                        colorFilter: ColorFilter.mode(
                            themeProvider.themeManager.primaryTextColor,
                            BlendMode.srcIn)),
                  ),
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
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: widget.isFav
                                ? (((modulesProvider.favModules[widget.index]['completed_issues'] ?? 0)
                                                    .toDouble() /
                                                (modulesProvider.favModules[widget.index]['total_issues'] == 0
                                                    ? 1
                                                    : modulesProvider.favModules[widget.index]
                                                        ['total_issues'])) *
                                            100) >=
                                        75
                                    ? themeProvider
                                        .themeManager.successBackgroundColor
                                    : themeProvider.themeManager
                                        .tertiaryBackgroundDefaultColor
                                : (((modulesProvider.modules[widget.index]['completed_issues'] ?? 0)
                                                    .toDouble() /
                                                (modulesProvider.modules[widget.index]
                                                            ['total_issues'] ==
                                                        0
                                                    ? 1
                                                    : modulesProvider
                                                            .modules[widget.index]
                                                        ['total_issues'])) *
                                            100) >=
                                        75
                                    ? themeProvider.themeManager.successBackgroundColor
                                    : themeProvider.themeManager.tertiaryBackgroundDefaultColor,
                            borderRadius: BorderRadius.circular(5)), // success 10
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
                              color: widget.isFav
                                  ? (((modulesProvider.favModules[widget.index]['completed_issues'] ??
                                                          0)
                                                      .toDouble() /
                                                  (modulesProvider.favModules[widget.index]['total_issues'] == 0
                                                      ? 1
                                                      : modulesProvider
                                                              .favModules[widget.index]
                                                          ['total_issues'])) *
                                              100) >=
                                          75
                                      ? themeProvider
                                          .themeManager.textSuccessColor
                                      : themeProvider
                                          .themeManager.placeholderTextColor
                                  : (((modulesProvider.modules[widget.index]['completed_issues'] ??
                                                          0)
                                                      .toDouble() /
                                                  (modulesProvider.modules[widget.index]['total_issues'] == 0
                                                      ? 1
                                                      : modulesProvider
                                                              .modules[widget.index]
                                                          ['total_issues'])) *
                                              100) >=
                                          75
                                      ? themeProvider.themeManager.textSuccessColor
                                      : themeProvider.themeManager.placeholderTextColor,
                              //themeProvider.themeManager.textSuccessColor,
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
                                  final String moduleID = modulesProvider
                                      .favModules[widget.index]['id'];
                                  modulesProvider.modules.add(
                                      modulesProvider.favModules[widget.index]);
                                  modulesProvider.favModules
                                      .removeAt(widget.index);
                                  modulesProvider.setState();
                                  modulesProvider.favouriteModule(
                                    slug: ref
                                        .read(ProviderList.workspaceProvider)
                                        .selectedWorkspace
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
                                  color:
                                      themeProvider.themeManager.secondaryIcon,
                                ))
                            : GestureDetector(
                                onTap: () async {
                                  final String moduleId = modulesProvider
                                      .modules[widget.index]['id'];
                                  modulesProvider.favModules.add(
                                      modulesProvider.modules[widget.index]);
                                  modulesProvider.modules
                                      .removeAt(widget.index);
                                  modulesProvider.setState();
                                  modulesProvider.favouriteModule(
                                    slug: ref
                                        .read(ProviderList.workspaceProvider)
                                        .selectedWorkspace
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
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            isScrollControlled: true,
                            enableDrag: true,
                            constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.50),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                            ),
                            context: context,
                            builder: (ctx) {
                              return DeleteCycleSheet(
                                id: modulesProvider.modules[widget.index]['id'],
                                name: modulesProvider.modules[widget.index]
                                    ['name'],
                                type: 'Module',
                              );
                            },
                          );
                        },
                        child: Icon(
                          LucideIcons.trash2,
                          color: themeProvider.themeManager.textErrorColor,
                          size: 20,
                        ),
                      ),
                    ],
                  )
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
                        ? StringManager.capitalizeFirstLetter(modulesProvider
                            .favModules[widget.index]['status']
                            .toString())
                        : StringManager.capitalizeFirstLetter(modulesProvider
                            .modules[widget.index]['status']
                            .toString()),
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
