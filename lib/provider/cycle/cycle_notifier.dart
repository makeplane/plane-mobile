import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plane/constants/cycles.contant.dart';
import 'package:plane/core/exception/plane_exception.dart';
import 'package:plane/models/cycle/cycle_detail.model.dart';
import 'package:plane/provider/cycle/cycle_state.dart';
import 'package:plane/provider/provider_list.dart';
import 'package:plane/repository/cycle.repository.dart';

class CycleNotifier extends StateNotifier<CycleState> {
  CycleNotifier(this.ref, this._cycleRepository) : super(CycleState.initial());
  Ref ref;
  final CycleRepository _cycleRepository;

  Future<Either<PlaneException, CycleDetailModel>> createCycle(
      CycleDetailModel payload) async {
    final workspaceSlug = ref.read(ProviderList.workspaceProvider).slug;
    final projectId = ref.read(ProviderList.projectProvider).currentProjectId;
    final canCreateCycle = await _cycleRepository.checkCycleDate(
        workspaceSlug, projectId, payload.start_date, payload.end_date);
    return canCreateCycle.fold((err) => Left(err), (value) async {
      final response =
          await _cycleRepository.createCycle(workspaceSlug, projectId, payload);
      return response.fold((err) => Left(err), (cycle) {
        state = state.copyWith(cycles: state.cycles);
        return Right(cycle);
      });
    });
  }

  Future<Either<PlaneException, void>> deleteCycle(String cycleId) async {
    final workspaceSlug = ref.read(ProviderList.workspaceProvider).slug;
    final projectId = ref.read(ProviderList.projectProvider).currentProjectId;
    final response =
        await _cycleRepository.deleteCycle(workspaceSlug, projectId, cycleId);
    return response.fold((err) => Left(err), (_) {
      state = state.copyWith(cycles: state.cycles);
      return const Right(null);
    });
  }

  Future<Either<PlaneException, CycleDetailModel>> updateCycle(
      CycleDetailModel payload) async {
    final workspaceSlug = ref.read(ProviderList.workspaceProvider).slug;
    final projectId = ref.read(ProviderList.projectProvider).currentProjectId;
    final response =
        await _cycleRepository.updateCycle(workspaceSlug, projectId, payload);
    return response.fold((err) => Left(err), (cycle) {
      state = state.copyWith(cycles: state.cycles);
      return Right(cycle);
    });
  }

  Future<Either<PlaneException, CycleDetailModel>> fetchCycleDetails(
      String cycleId) async {
    final workspaceSlug = ref.read(ProviderList.workspaceProvider).slug;
    final projectId = ref.read(ProviderList.projectProvider).currentProjectId;
    final response = await _cycleRepository.fetchCycleDetails(
        workspaceSlug, projectId, cycleId);
    return response.fold((err) => Left(err), (cycleDetail) {
      state = state.copyWith(currentCycleDetails: cycleDetail);
      return Right(cycleDetail);
    });
  }

  Future<Either<PlaneException, Map<String, CycleDetailModel>>>
      fetchCycles() async {
    final workspaceSlug = ref.read(ProviderList.workspaceProvider).slug;
    final projectId = ref.read(ProviderList.projectProvider).currentProjectId;
    final response =
        await _cycleRepository.fetchCycles(workspaceSlug, projectId);
    return response.fold((err) => Left(err), (cycles) {
      /// Cycles filtering
      Map<CycleType, Map<String, CycleDetailModel>?> filteredCycles = {
        CycleType.active: state.cycles[CycleType.active],
        CycleType.all: {},
        CycleType.completed: {},
        CycleType.upcoming: {},
        CycleType.draft: {},
      };
      for (final cycle in cycles.values) {
        final cycleStatus = stringToCycleType(cycle.status);
        filteredCycles[CycleType.all]!.addEntries({cycle.id: cycle}.entries);
        if (cycleStatus == CycleType.active) continue;
        filteredCycles[cycleStatus]!.addEntries({cycle.id: cycle}.entries);
      }
      state = state.copyWith(cycles: filteredCycles);
      return Right(cycles);
    });
  }

  Future<Either<PlaneException, CycleDetailModel>> fetchActiveCycle() async {
    final workspaceSlug = ref.read(ProviderList.workspaceProvider).slug;
    final projectId = ref.read(ProviderList.projectProvider).currentProjectId;
    final response = await _cycleRepository.fetchActiveCycle(
      workspaceSlug,
      projectId,
    );
    return response.fold((err) => Left(err), (cycle) {
      final updatedCycles = state.cycles;
      updatedCycles[CycleType.active] = {cycle.id: cycle};
      state = state.copyWith(cycles: updatedCycles);
      return Right(cycle);
    });
  }

  Future<Either<PlaneException, void>> transferIssues(
      String currentCycleId, String newCycleId) async {
    final workspaceSlug = ref.read(ProviderList.workspaceProvider).slug;
    final projectId = ref.read(ProviderList.projectProvider).currentProjectId;
    final response = await _cycleRepository.transferIssues(
        workspaceSlug, projectId, currentCycleId, newCycleId);
    return response.fold((err) => Left(err), (_) {
      state = state.copyWith(cycles: state.cycles);
      return const Right(null);
    });
  }
}
