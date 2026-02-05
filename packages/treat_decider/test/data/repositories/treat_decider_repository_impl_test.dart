import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:treat_decider/src/data/datasources/treat_decider_datasource.dart';
import 'package:treat_decider/src/data/models/treat_result_model.dart';
import 'package:treat_decider/src/data/repositories/treat_decider_repository_impl.dart';
import 'package:treat_decider/src/domain/entities/location.dart';
import 'package:treat_decider/src/domain/entities/team_member.dart';
import 'package:treat_decider/src/domain/entities/treat_result.dart';

class MockTreatDeciderDataSource extends Mock
    implements TreatDeciderDataSource {}

void main() {
  late MockTreatDeciderDataSource mockDataSource;
  late TreatDeciderRepositoryImpl repository;

  setUp(() {
    mockDataSource = MockTreatDeciderDataSource();
    repository = TreatDeciderRepositoryImpl(dataSource: mockDataSource);
  });

  setUpAll(() {
    registerFallbackValue(TreatResultModel(
      id: 'fallback',
      date: DateTime.now(),
      winner: const TeamMember(id: '1', name: 'Test'),
      location: const Location(id: '1', name: 'Test'),
      teamMembers: const [TeamMember(id: '1', name: 'Test')],
      createdAt: DateTime.now(),
    ));
  });

  group('TreatDeciderRepositoryImpl', () {
    final testDate = DateTime(2024, 3, 15);
    final testCreatedAt = DateTime(2024, 3, 10);
    const winner = TeamMember(id: '1', name: 'John');
    const location = Location(id: '1', name: 'Pizza Place');
    const teamMembers = [
      TeamMember(id: '1', name: 'John'),
      TeamMember(id: '2', name: 'Jane'),
    ];

    final testResult = TreatResult(
      id: 'result-1',
      date: testDate,
      winner: winner,
      location: location,
      teamMembers: teamMembers,
      createdAt: testCreatedAt,
    );

    group('saveResult', () {
      test('should save result to data source', () async {
        when(() => mockDataSource.saveResult(any())).thenAnswer((_) async {});

        await repository.saveResult(testResult);

        verify(() => mockDataSource.saveResult(any())).called(1);
      });
    });

    group('getHistory', () {
      test('should return empty list when no history exists', () async {
        when(() => mockDataSource.getHistory()).thenAnswer((_) async => []);

        final result = await repository.getHistory();

        expect(result, isEmpty);
        verify(() => mockDataSource.getHistory()).called(1);
      });

      test('should return history from data source', () async {
        final models = [
          TreatResultModel(
            id: 'result-1',
            date: testDate,
            winner: winner,
            location: location,
            teamMembers: teamMembers,
            createdAt: testCreatedAt,
          ),
        ];

        when(() => mockDataSource.getHistory())
            .thenAnswer((_) async => models);

        final result = await repository.getHistory();

        expect(result.length, 1);
        expect(result.first.id, 'result-1');
        verify(() => mockDataSource.getHistory()).called(1);
      });
    });

    group('clearHistory', () {
      test('should clear history in data source', () async {
        when(() => mockDataSource.clearHistory()).thenAnswer((_) async {});

        await repository.clearHistory();

        verify(() => mockDataSource.clearHistory()).called(1);
      });
    });
  });
}
