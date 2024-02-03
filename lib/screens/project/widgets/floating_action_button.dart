import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/screens/create_view_screen.dart';
import 'package:plane/screens/project/cycles/create-cycle/create_cycle.dart';
import 'package:plane/screens/project/modules/create-module/create_module.dart';
import 'package:plane/utils/enums.dart';

// ignore: non_constant_identifier_names
Widget FLActionButton(
  BuildContext context, {
  required WidgetRef ref,
  required int selected,
}) {
  final themeProvider = ref.watch(ProviderList.themeProvider);
  final projectProvider = ref.watch(ProviderList.projectProvider);
  final cycleProvider = ref.watch(ProviderList.cyclesProvider);
  final moduleProvider = ref.watch(ProviderList.modulesProvider);
  final viewsProvider = ref.watch(ProviderList.viewsProvider);

  return selected != 0 &&
          (projectProvider.role == Role.admin ||
              projectProvider.role == Role.member) &&
          ((selected == 1 && cycleProvider.showAddFloatingButton()) ||
              (selected == 2 &&
                  moduleProvider.moduleState != StateEnum.loading &&
                  (moduleProvider.modules.isNotEmpty ||
                      moduleProvider.favModules.isNotEmpty)) ||
              (selected == 3 &&
                  viewsProvider.viewsState != StateEnum.loading &&
                  viewsProvider.views.isNotEmpty))
      ? FloatingActionButton(
          backgroundColor: themeProvider.themeManager.primaryColour,
          child: Icon(
            Icons.add,
            color: themeProvider.themeManager.textonColor,
          ),
          onPressed: () {
            if (selected == 1 && projectProvider.features[1]['show']) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const CreateCycle(),
                ),
              );
            }

            if (selected == 1 &&
                !projectProvider.features[1]['show'] &&
                projectProvider.features[2]['show']) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const CreateModule(),
                ),
              );
            }

            if (selected == 1 &&
                !projectProvider.features[1]['show'] &&
                !projectProvider.features[2]['show']) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const CreateView(),
                ),
              );
            }

            if (selected == 2 &&
                projectProvider.features[2]['show'] &&
                projectProvider.features[1]['show']) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const CreateModule(),
                ),
              );
            }

            if ((selected == 2 &&
                    projectProvider.features[2]['show'] &&
                    !projectProvider.features[1]['show']) ||
                (selected == 2 &&
                    !projectProvider.features[2]['show'] &&
                    projectProvider.features[1]['show'])) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const CreateView(),
                ),
              );
            }
            if (selected == 3) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const CreateView(),
                ),
              );
            }
            // if (selected == 4) {
            //   Navigator.of(context).push(
            //     MaterialPageRoute(
            //       builder: (ctx) => const CreatePage(),
            //     ),
            //   );
            // }
          },
        )
      : Container();
}
