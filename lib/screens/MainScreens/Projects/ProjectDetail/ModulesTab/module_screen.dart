import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane_startup/screens/MainScreens/Projects/ProjectDetail/ModulesTab/simple_module_card.dart';
import 'package:plane_startup/utils/enums.dart';
import 'package:plane_startup/widgets/empty.dart';
import 'package:plane_startup/widgets/loading_widget.dart';
import 'package:plane_startup/provider/provider_list.dart';
import 'package:plane_startup/widgets/custom_text.dart';
import 'package:plane_startup/utils/constants.dart';

class ModuleScreen extends ConsumerStatefulWidget {
  const ModuleScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ModuleScreenState();
}

class _ModuleScreenState extends ConsumerState<ModuleScreen> {
  @override
  Widget build(BuildContext context) {
    var themeProvider = ref.watch(ProviderList.themeProvider);
    var modulesProvider = ref.watch(ProviderList.modulesProvider);
    return LoadingWidget(
      loading: modulesProvider.moduleState == StateEnum.loading,
      widgetClass: Padding(
        padding: const EdgeInsets.only(
          top: 16,
          left: 16,
          right: 16,
        ),
        child: (modulesProvider.favModules.isEmpty &&
                modulesProvider.modules.isEmpty)
            ? EmptyPlaceholder.emptyModules(context,ref)
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    modulesProvider.favModules.isNotEmpty
                        ? const CustomText(
                            'Favourite',
                            type: FontStyle.Medium,
                          )
                        : Container(),
                    modulesProvider.favModules.isNotEmpty
                        ? Container(
                            color: themeProvider.isDarkThemeEnabled
                                ? darkBackgroundColor
                                : Colors.white,
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: modulesProvider.favModules.length,
                              itemBuilder: (context, index) {
                                // return ModuleCard(
                                //   index: index,
                                //   isFav: true,
                                // );
                                return SimpleModuleCard(
                                  index: index,
                                  isFav: true,
                                );
                              },
                            ),
                          )
                        : Container(),
                    modulesProvider.favModules.isNotEmpty
                        ? const SizedBox(height: 20)
                        : Container(),
                    modulesProvider.modules.isNotEmpty &&
                            modulesProvider.favModules.isNotEmpty
                        ? const CustomText(
                            'All Modules',
                            type: FontStyle.Medium,
                          )
                        : Container(),
                    Container(
                        color: themeProvider.isDarkThemeEnabled
                            ? darkBackgroundColor
                            : Colors.white,
                        // padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: modulesProvider.modules.length,
                          itemBuilder: (context, index) {
                            // return ModuleCard(
                            //   index: index,
                            //   isFav: false,
                            // );
                            return SimpleModuleCard(
                              index: index,
                              isFav: false,
                            );
                          },
                        )),
                    const SizedBox(height: 15)
                  ],
                ),
              ),
      ),
    );
  }
}
