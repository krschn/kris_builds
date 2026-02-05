part of 'treat_decider_bloc.dart';

sealed class TreatDeciderEvent extends Equatable {
  const TreatDeciderEvent();

  @override
  List<Object?> get props => [];
}

final class AddTeamMember extends TreatDeciderEvent {
  const AddTeamMember(this.name);

  final String name;

  @override
  List<Object?> get props => [name];
}

final class RemoveTeamMember extends TreatDeciderEvent {
  const RemoveTeamMember(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

final class AddLocation extends TreatDeciderEvent {
  const AddLocation(this.name);

  final String name;

  @override
  List<Object?> get props => [name];
}

final class RemoveLocation extends TreatDeciderEvent {
  const RemoveLocation(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

final class SetDate extends TreatDeciderEvent {
  const SetDate(this.date);

  final DateTime date;

  @override
  List<Object?> get props => [date];
}

final class DecideWinner extends TreatDeciderEvent {
  const DecideWinner();
}

final class LoadHistory extends TreatDeciderEvent {
  const LoadHistory();
}

final class ClearHistory extends TreatDeciderEvent {
  const ClearHistory();
}

final class ResetForm extends TreatDeciderEvent {
  const ResetForm();
}
