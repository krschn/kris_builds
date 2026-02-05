import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:treat_decider/src/domain/entities/location.dart';
import 'package:treat_decider/src/domain/entities/team_member.dart';
import 'package:treat_decider/src/domain/entities/treat_result.dart';
import 'package:treat_decider/src/domain/repositories/treat_decider_repository.dart';
import 'package:treat_decider/src/domain/usecases/get_history_usecase.dart';

class MockTreatDeciderRepository extends Mock
    implements TreatDeciderRepository {}

void main() {
  late MockTreatDeciderRepository mockRepository;
  late GetHistoryUseCase useCase;

  setUp(() {
    mockRepository = MockTreatDeciderRepository();
    useCase = GetHistoryUseCase(repository: mockRepository);
  });

  group('GetHistoryUseCase', () {
    test('should return empty list when no history exists', () async {
      when(() => mockRepository.getHistory()).thenAnswer((_) async => []);

      final result = await useCase.execute();

      expect(result, isEmpty);
      verify(() => mockRepository.getHistory()).called(1);
    });

    test('should return history from repository', () async {
      final history = [
        TreatResult(
          id: 'result-1',
          date: DateTime(2024, 3, 15),
          winner: const TeamMember(id: '1', name: 'John'),
          location: const Location(id: '1', name: 'Pizza Place'),
          teamMembers: const [TeamMember(id: '1', name: 'John')],
          createdAt: DateTime(2024, 3, 10),
        ),
        TreatResult(
          id: 'result-2',
          date: DateTime(2024, 3, 20),
          winner: const TeamMember(id: '2', name: 'Jane'),
          location: const Location(id: '2', name: 'Burger Joint'),
          teamMembers: const [TeamMember(id: '2', name: 'Jane')],
          createdAt: DateTime(2024, 3, 15),
        ),
      ];

      when(() => mockRepository.getHistory()).thenAnswer((_) async => history);

      final result = await useCase.execute();

      expect(result, history);
      expect(result.length, 2);
    });

    test('should propagate repository errors', () async {
      when(() => mockRepository.getHistory())
          .thenThrow(Exception('Storage error'));

      expect(
        () => useCase.execute(),
        throwsException,
      );
    });
  });
}
