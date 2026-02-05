import 'package:equatable/equatable.dart';

import 'location.dart';
import 'team_member.dart';

class TreatResult extends Equatable {
  const TreatResult({
    required this.id,
    required this.date,
    required this.winner,
    required this.location,
    required this.teamMembers,
    required this.createdAt,
  });

  final String id;
  final DateTime date;
  final TeamMember winner;
  final Location location;
  final List<TeamMember> teamMembers;
  final DateTime createdAt;

  @override
  List<Object?> get props => [id, date, winner, location, teamMembers, createdAt];
}
