import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plane/core/icons/state_group_icon.dart';
import 'package:plane/models/project/state/state_model.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/core/extensions/string_extensions.dart';
import 'package:plane/widgets/custom_expansion_tile.dart';
import 'package:plane/widgets/rectangular_chip.dart';

class StateFilter extends ConsumerStatefulWidget {
  const StateFilter({required this.states, required this.onChange, super.key});
  final List<StateModel> states;
  final Function(String labelId) onChange;

  @override
  ConsumerState<StateFilter> createState() => _StateFilterState();
}

class _StateFilterState extends ConsumerState<StateFilter> {
  List<StateModel> stateGroups = [
    StateModel.initialize().copyWith(
        group: 'backlog',
        name: 'Backlog',
        color: '#5e6ad2',
        stateIcon: StateGroupIcon('backlog')),
    StateModel.initialize().copyWith(
        group: 'unstarted',
        name: 'Unstarted',
        color: '#eb5757',
        stateIcon: StateGroupIcon('unstarted')),
    StateModel.initialize().copyWith(
        group: 'started',
        name: 'Started',
        color: '#26b5ce',
        stateIcon: StateGroupIcon('started')),
    StateModel.initialize().copyWith(
        group: 'completed',
        name: 'Completed',
        color: '#f2c94c',
        stateIcon: StateGroupIcon('completed')),
    StateModel.initialize().copyWith(
        group: 'cancelled',
        name: 'Cancelled',
        color: '#4cb782',
        stateIcon: StateGroupIcon('cancelled'))
  ];
  @override
  Widget build(BuildContext context) {
    final themeManager = ref.read(ProviderList.themeProvider).themeManager;
    return CustomExpansionTile(
      title: 'State',
      child: Wrap(
          children: widget.states.map((state) {
        return GestureDetector(
          onTap: () => widget.onChange(state.id),
          child: RectangularChip(
            ref: ref,
            icon: SvgPicture.asset(
              state.group == 'backlog'
                  ? 'assets/svg_images/circle.svg'
                  : state.group == 'cancelled'
                      ? 'assets/svg_images/cancelled.svg'
                      : state.group == 'started'
                          ? 'assets/svg_images/in_progress.svg'
                          : state.group == 'completed'
                              ? 'assets/svg_images/done.svg'
                              : 'assets/svg_images/unstarted.svg',
              colorFilter: ColorFilter.mode(
                  widget.states.contains(state.id)
                      ? (Colors.white)
                      : state.color.toColor(),
                  BlendMode.srcIn),
              height: 20,
              width: 20,
            ),
            text: state.name,
            color: widget.states.contains(state.id)
                ? themeManager.primaryColour
                : themeManager.secondaryBackgroundDefaultColor,
            selected: widget.states.contains(state.id),
          ),
        );
      }).toList()),
    );
  }
}
