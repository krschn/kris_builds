import 'package:flutter_test/flutter_test.dart';
import 'package:treat_decider/src/data/models/treat_result_model.dart';
import 'package:treat_decider/src/domain/entities/location.dart';
import 'package:treat_decider/src/domain/entities/team_member.dart';
import 'package:treat_decider/src/domain/entities/treat_result.dart';

void main() {
  group('TreatResultModel', () {
    final testDate = DateTime(2024, 3, 15);
    final testCreatedAt = DateTime(2024, 3, 10, 14, 30, 45);
    const winner = TeamMember(id: '1', name: 'John');
    const location = Location(id: '1', name: 'Pizza Place');
    const teamMembers = [
      TeamMember(id: '1', name: 'John'),
      TeamMember(id: '2', name: 'Jane'),
    ];

    test('should create from entity', () {
      final entity = TreatResult(
        id: 'result-1',
        date: testDate,
        winner: winner,
        location: location,
        teamMembers: teamMembers,
        createdAt: testCreatedAt,
      );

      final model = TreatResultModel.fromEntity(entity);

      expect(model.id, entity.id);
      expect(model.date, entity.date);
      expect(model.winner, entity.winner);
      expect(model.location, entity.location);
      expect(model.teamMembers, entity.teamMembers);
      expect(model.createdAt, entity.createdAt);
    });

    test('should convert to JSON', () {
      final model = TreatResultModel(
        id: 'result-1',
        date: testDate,
        winner: winner,
        location: location,
        teamMembers: teamMembers,
        createdAt: testCreatedAt,
      );

      final json = model.toJson();

      expect(json['id'], 'result-1');
      expect(json['date'], testDate.toIso8601String());
      expect(json['winner'], {'id': '1', 'name': 'John'});
      expect(json['location'], {'id': '1', 'name': 'Pizza Place'});
      expect(json['teamMembers'], [
        {'id': '1', 'name': 'John'},
        {'id': '2', 'name': 'Jane'},
      ]);
      expect(json['createdAt'], testCreatedAt.toIso8601String());
    });

    test('should create from JSON', () {
      final json = {
        'id': 'result-1',
        'date': testDate.toIso8601String(),
        'winner': {'id': '1', 'name': 'John'},
        'location': {'id': '1', 'name': 'Pizza Place'},
        'teamMembers': [
          {'id': '1', 'name': 'John'},
          {'id': '2', 'name': 'Jane'},
        ],
        'createdAt': testCreatedAt.toIso8601String(),
      };

      final model = TreatResultModel.fromJson(json);

      expect(model.id, 'result-1');
      expect(model.date, testDate);
      expect(model.winner, winner);
      expect(model.location, location);
      expect(model.teamMembers, teamMembers);
      expect(model.createdAt, testCreatedAt);
    });

    test('should roundtrip through JSON', () {
      final original = TreatResultModel(
        id: 'result-1',
        date: testDate,
        winner: winner,
        location: location,
        teamMembers: teamMembers,
        createdAt: testCreatedAt,
      );

      final json = original.toJson();
      final restored = TreatResultModel.fromJson(json);

      expect(restored, original);
    });
  });
}
