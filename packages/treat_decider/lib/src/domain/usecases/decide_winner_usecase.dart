import 'dart:math';

import 'package:equatable/equatable.dart';

import '../entities/location.dart';
import '../entities/team_member.dart';

class DecideWinnerResult extends Equatable {
  const DecideWinnerResult({
    required this.winner,
    required this.location,
  });

  final TeamMember winner;
  final Location location;

  @override
  List<Object?> get props => [winner, location];
}

class DecideWinnerUseCase {
  DecideWinnerUseCase({Random? random}) : _random = random ?? Random();

  final Random _random;

  DecideWinnerResult execute({
    required List<TeamMember> teamMembers,
    required List<Location> locations,
  }) {
    if (teamMembers.isEmpty) {
      throw ArgumentError('Team members list cannot be empty');
    }
    if (locations.isEmpty) {
      throw ArgumentError('Locations list cannot be empty');
    }

    final winnerIndex = _random.nextInt(teamMembers.length);
    final locationIndex = _random.nextInt(locations.length);

    return DecideWinnerResult(
      winner: teamMembers[winnerIndex],
      location: locations[locationIndex],
    );
  }
}
