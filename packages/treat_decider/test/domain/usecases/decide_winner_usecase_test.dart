import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:treat_decider/src/domain/entities/location.dart';
import 'package:treat_decider/src/domain/entities/team_member.dart';
import 'package:treat_decider/src/domain/usecases/decide_winner_usecase.dart';

void main() {
  group('DecideWinnerUseCase', () {
    test('should select a team member and location from the provided lists', () {
      final random = Random(42); // Fixed seed for predictable tests
      final useCase = DecideWinnerUseCase(random: random);

      const teamMembers = [
        TeamMember(id: '1', name: 'John'),
        TeamMember(id: '2', name: 'Jane'),
        TeamMember(id: '3', name: 'Bob'),
      ];
      const locations = [
        Location(id: '1', name: 'Pizza Place'),
        Location(id: '2', name: 'Burger Joint'),
      ];

      final result = useCase.execute(
        teamMembers: teamMembers,
        locations: locations,
      );

      expect(teamMembers, contains(result.winner));
      expect(locations, contains(result.location));
    });

    test('should throw when team members list is empty', () {
      final useCase = DecideWinnerUseCase();

      const locations = [Location(id: '1', name: 'Pizza Place')];

      expect(
        () => useCase.execute(teamMembers: [], locations: locations),
        throwsArgumentError,
      );
    });

    test('should throw when locations list is empty', () {
      final useCase = DecideWinnerUseCase();

      const teamMembers = [TeamMember(id: '1', name: 'John')];

      expect(
        () => useCase.execute(teamMembers: teamMembers, locations: []),
        throwsArgumentError,
      );
    });

    test('should work with single team member', () {
      final useCase = DecideWinnerUseCase();

      const teamMembers = [TeamMember(id: '1', name: 'Solo')];
      const locations = [Location(id: '1', name: 'Pizza Place')];

      final result = useCase.execute(
        teamMembers: teamMembers,
        locations: locations,
      );

      expect(result.winner, teamMembers.first);
      expect(result.location, locations.first);
    });

    test('should produce different winners with different random seeds', () {
      const teamMembers = [
        TeamMember(id: '1', name: 'John'),
        TeamMember(id: '2', name: 'Jane'),
        TeamMember(id: '3', name: 'Bob'),
        TeamMember(id: '4', name: 'Alice'),
        TeamMember(id: '5', name: 'Charlie'),
      ];
      const locations = [
        Location(id: '1', name: 'Pizza Place'),
        Location(id: '2', name: 'Burger Joint'),
        Location(id: '3', name: 'Taco Stand'),
      ];

      final results = <DecideWinnerResult>{};
      for (var seed = 0; seed < 100; seed++) {
        final useCase = DecideWinnerUseCase(random: Random(seed));
        final result = useCase.execute(
          teamMembers: teamMembers,
          locations: locations,
        );
        results.add(result);
      }

      // With 100 different seeds, we should get multiple different results
      expect(results.length, greaterThan(1));
    });
  });
}
