import 'package:plane/constants/cycles.contant.dart';
import 'package:plane/models/cycle/cycle_detail.model.dart';
import 'package:plane/utils/enums.dart';

class CycleState {
  CycleState(
      {required this.cycles,
      this.currentCycleDetails,
      required this.fetchCycleDetailState});

  Map<CycleType, Map<String, CycleDetailModel>?> cycles;
  CycleDetailModel? currentCycleDetails;
  DataState fetchCycleDetailState = DataState.empty;

  CycleState copyWith({
    Map<CycleType, Map<String, CycleDetailModel>?>? cycles,
    CycleDetailModel? currentCycleDetails,
    DataState? fetchCycleDetailState,
  }) {
    return CycleState(
        fetchCycleDetailState:
            fetchCycleDetailState ?? this.fetchCycleDetailState,
        cycles: cycles ?? this.cycles,
        currentCycleDetails: currentCycleDetails ?? this.currentCycleDetails);
  }

  factory CycleState.initial() {
    return CycleState(cycles: {}, fetchCycleDetailState: DataState.empty);
  }
}
