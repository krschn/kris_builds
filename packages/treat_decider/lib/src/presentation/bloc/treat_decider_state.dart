part of 'treat_decider_bloc.dart';

sealed class TreatDeciderState extends Equatable {
  const TreatDeciderState();

  @override
  List<Object?> get props => [];
}

final class TreatDeciderInitial extends TreatDeciderState {
  const TreatDeciderInitial();
}

final class TreatDeciderInput extends TreatDeciderState {
  const TreatDeciderInput({
    required this.teamMembers,
    required this.locations,
    required this.date,
  });

  final List<TeamMember> teamMembers;
  final List<Location> locations;
  final DateTime date;

  TreatDeciderInput copyWith({
    List<TeamMember>? teamMembers,
    List<Location>? locations,
    DateTime? date,
  }) {
    return TreatDeciderInput(
      teamMembers: teamMembers ?? this.teamMembers,
      locations: locations ?? this.locations,
      date: date ?? this.date,
    );
  }

  @override
  List<Object?> get props => [teamMembers, locations, date];
}

final class TreatDeciderSelecting extends TreatDeciderState {
  const TreatDeciderSelecting({
    required this.teamMembers,
    required this.locations,
    required this.date,
    required this.selectedMember,
    required this.selectedLocation,
  });

  final List<TeamMember> teamMembers;
  final List<Location> locations;
  final DateTime date;
  final TeamMember selectedMember;
  final Location selectedLocation;

  @override
  List<Object?> get props => [
        teamMembers,
        locations,
        date,
        selectedMember,
        selectedLocation,
      ];
}

final class TreatDeciderResult extends TreatDeciderState {
  const TreatDeciderResult({
    required this.result,
    required this.history,
  });

  final TreatResult result;
  final List<TreatResult> history;

  @override
  List<Object?> get props => [result, history];
}

final class TreatDeciderHistoryLoaded extends TreatDeciderState {
  const TreatDeciderHistoryLoaded({required this.history});

  final List<TreatResult> history;

  @override
  List<Object?> get props => [history];
}

final class TreatDeciderError extends TreatDeciderState {
  const TreatDeciderError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
