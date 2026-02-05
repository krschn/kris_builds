import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/location.dart';
import '../../domain/entities/team_member.dart';
import '../../domain/entities/treat_result.dart';
import '../../domain/usecases/decide_winner_usecase.dart';
import '../../domain/usecases/get_history_usecase.dart';
import '../../domain/usecases/save_result_usecase.dart';

part 'treat_decider_event.dart';
part 'treat_decider_state.dart';

class TreatDeciderBloc extends Bloc<TreatDeciderEvent, TreatDeciderState> {
  TreatDeciderBloc({
    required DecideWinnerUseCase decideWinnerUseCase,
    required SaveResultUseCase saveResultUseCase,
    required GetHistoryUseCase getHistoryUseCase,
    Uuid? uuid,
  })  : _decideWinnerUseCase = decideWinnerUseCase,
        _saveResultUseCase = saveResultUseCase,
        _getHistoryUseCase = getHistoryUseCase,
        _uuid = uuid ?? const Uuid(),
        super(const TreatDeciderInitial()) {
    on<AddTeamMember>(_onAddTeamMember);
    on<RemoveTeamMember>(_onRemoveTeamMember);
    on<AddLocation>(_onAddLocation);
    on<RemoveLocation>(_onRemoveLocation);
    on<SetDate>(_onSetDate);
    on<DecideWinner>(_onDecideWinner);
    on<LoadHistory>(_onLoadHistory);
    on<ClearHistory>(_onClearHistory);
    on<ResetForm>(_onResetForm);
  }

  final DecideWinnerUseCase _decideWinnerUseCase;
  final SaveResultUseCase _saveResultUseCase;
  final GetHistoryUseCase _getHistoryUseCase;
  final Uuid _uuid;

  TreatDeciderInput _getCurrentInput() {
    final currentState = state;
    if (currentState is TreatDeciderInput) {
      return currentState;
    }
    return TreatDeciderInput(
      teamMembers: const [],
      locations: const [],
      date: DateTime.now(),
    );
  }

  void _onAddTeamMember(
    AddTeamMember event,
    Emitter<TreatDeciderState> emit,
  ) {
    final input = _getCurrentInput();
    final trimmedName = event.name.trim();
    if (trimmedName.isEmpty) return;

    // Check for duplicates
    final exists = input.teamMembers.any(
      (m) => m.name.toLowerCase() == trimmedName.toLowerCase(),
    );
    if (exists) return;

    final newMember = TeamMember(
      id: _uuid.v4(),
      name: trimmedName,
    );
    emit(input.copyWith(
      teamMembers: [...input.teamMembers, newMember],
    ));
  }

  void _onRemoveTeamMember(
    RemoveTeamMember event,
    Emitter<TreatDeciderState> emit,
  ) {
    final input = _getCurrentInput();
    emit(input.copyWith(
      teamMembers: input.teamMembers.where((m) => m.id != event.id).toList(),
    ));
  }

  void _onAddLocation(
    AddLocation event,
    Emitter<TreatDeciderState> emit,
  ) {
    final input = _getCurrentInput();
    final trimmedName = event.name.trim();
    if (trimmedName.isEmpty) return;

    // Check for duplicates
    final exists = input.locations.any(
      (l) => l.name.toLowerCase() == trimmedName.toLowerCase(),
    );
    if (exists) return;

    final newLocation = Location(
      id: _uuid.v4(),
      name: trimmedName,
    );
    emit(input.copyWith(
      locations: [...input.locations, newLocation],
    ));
  }

  void _onRemoveLocation(
    RemoveLocation event,
    Emitter<TreatDeciderState> emit,
  ) {
    final input = _getCurrentInput();
    emit(input.copyWith(
      locations: input.locations.where((l) => l.id != event.id).toList(),
    ));
  }

  void _onSetDate(
    SetDate event,
    Emitter<TreatDeciderState> emit,
  ) {
    final input = _getCurrentInput();
    emit(input.copyWith(date: event.date));
  }

  Future<void> _onDecideWinner(
    DecideWinner event,
    Emitter<TreatDeciderState> emit,
  ) async {
    final input = _getCurrentInput();

    if (input.teamMembers.isEmpty) {
      emit(const TreatDeciderError('Please add at least one team member'));
      return;
    }

    if (input.locations.isEmpty) {
      emit(const TreatDeciderError('Please add at least one location'));
      return;
    }

    // Decide winner first so we can pass it to the animation
    final decision = _decideWinnerUseCase.execute(
      teamMembers: input.teamMembers,
      locations: input.locations,
    );

    // Emit selecting state for animation with the pre-decided winner
    emit(TreatDeciderSelecting(
      teamMembers: input.teamMembers,
      locations: input.locations,
      date: input.date,
      selectedMember: decision.winner,
      selectedLocation: decision.location,
    ));

    // Wait for animation to complete (animation runs ~3.5 seconds)
    await Future<void>.delayed(const Duration(milliseconds: 3500));

    final result = TreatResult(
      id: _uuid.v4(),
      date: input.date,
      winner: decision.winner,
      location: decision.location,
      teamMembers: input.teamMembers,
      createdAt: DateTime.now(),
    );

    // Save result
    await _saveResultUseCase.execute(result);

    // Load updated history
    final history = await _getHistoryUseCase.execute();

    emit(TreatDeciderResult(result: result, history: history));
  }

  Future<void> _onLoadHistory(
    LoadHistory event,
    Emitter<TreatDeciderState> emit,
  ) async {
    final history = await _getHistoryUseCase.execute();
    emit(TreatDeciderHistoryLoaded(history: history));
  }

  Future<void> _onClearHistory(
    ClearHistory event,
    Emitter<TreatDeciderState> emit,
  ) async {
    await _saveResultUseCase.repository.clearHistory();
    final history = await _getHistoryUseCase.execute();
    emit(TreatDeciderHistoryLoaded(history: history));
  }

  void _onResetForm(
    ResetForm event,
    Emitter<TreatDeciderState> emit,
  ) {
    emit(TreatDeciderInput(
      teamMembers: const [],
      locations: const [],
      date: DateTime.now(),
    ));
  }
}
