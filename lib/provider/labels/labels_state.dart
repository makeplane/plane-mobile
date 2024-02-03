import 'package:plane/models/Project/Label/label.model.dart';
import 'package:plane/utils/enums.dart';

class LabelState {
  // Properties
  StateEnum labelState = StateEnum.empty;
  Map<String, LabelModel> projectLabels = {};
  Map<String, LabelModel> workspaceLabels = {};

  // Constructor
  LabelState({
    required this.projectLabels,
    required this.workspaceLabels,
    required this.labelState,
  });

  // CopyWith
  LabelState copyWith(
      {StateEnum? labelState,
      Map<String, LabelModel>? projectLabels,
      Map<String, LabelModel>? workspaceLabels}) {
    return LabelState(
        labelState: labelState ?? this.labelState,
        projectLabels: projectLabels ?? this.projectLabels,
        workspaceLabels: workspaceLabels ?? this.workspaceLabels);
  }

  // Initialize with empty states
  factory LabelState.initialize() {
    return LabelState(
        projectLabels: {}, workspaceLabels: {}, labelState: StateEnum.empty);
  }
}