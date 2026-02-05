import 'package:flutter_test/flutter_test.dart';
import 'package:treat_decider/src/domain/entities/location.dart';
import 'package:treat_decider/src/domain/entities/team_member.dart';
import 'package:treat_decider/src/domain/entities/treat_result.dart';

void main() {
  group('TreatResult', () {
    final testDate = DateTime(2024, 3, 15);
    final testCreatedAt = DateTime(2024, 3, 10);
    const winner = TeamMember(id: '1', name: 'John');
    const location = Location(id: '1', name: 'Pizza Place');
    const teamMembers = [
      TeamMember(id: '1', name: 'John'),
      TeamMember(id: '2', name: 'Jane'),
    ];

    test('should create a valid TreatResult', () {
      final result = TreatResult(
        id: 'result-1',
        date: testDate,
        winner: winner,
        location: location,
        teamMembers: teamMembers,
        createdAt: testCreatedAt,
      );

      expect(result.id, 'result-1');
      expect(result.date, testDate);
      expect(result.winner, winner);
      expect(result.location, location);
      expect(result.teamMembers, teamMembers);
      expect(result.createdAt, testCreatedAt);
    });

    test('should support value equality', () {
      final result1 = TreatResult(
        id: 'result-1',
        date: testDate,
        winner: winner,
        location: location,
        teamMembers: teamMembers,
        createdAt: testCreatedAt,
      );
      final result2 = TreatResult(
        id: 'result-1',
        date: testDate,
        winner: winner,
        location: location,
        teamMembers: teamMembers,
        createdAt: testCreatedAt,
      );

      expect(result1, equals(result2));
    });

    test('should be different when id differs', () {
      final result1 = TreatResult(
        id: 'result-1',
        date: testDate,
        winner: winner,
        location: location,
        teamMembers: teamMembers,
        createdAt: testCreatedAt,
      );
      final result2 = TreatResult(
        id: 'result-2',
        date: testDate,
        winner: winner,
        location: location,
        teamMembers: teamMembers,
        createdAt: testCreatedAt,
      );

      expect(result1, isNot(equals(result2)));
    });

    test('should be different when winner differs', () {
      const differentWinner = TeamMember(id: '2', name: 'Jane');
      final result1 = TreatResult(
        id: 'result-1',
        date: testDate,
        winner: winner,
        location: location,
        teamMembers: teamMembers,
        createdAt: testCreatedAt,
      );
      final result2 = TreatResult(
        id: 'result-1',
        date: testDate,
        winner: differentWinner,
        location: location,
        teamMembers: teamMembers,
        createdAt: testCreatedAt,
      );

      expect(result1, isNot(equals(result2)));
    });
  });
}
