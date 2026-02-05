import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:treat_decider/src/domain/entities/location.dart';
import 'package:treat_decider/src/domain/entities/team_member.dart';
import 'package:treat_decider/src/domain/entities/treat_result.dart';
import 'package:treat_decider/src/domain/repositories/treat_decider_repository.dart';
import 'package:treat_decider/src/domain/usecases/save_result_usecase.dart';

class MockTreatDeciderRepository extends Mock
    implements TreatDeciderRepository {}

void main() {
  late MockTreatDeciderRepository mockRepository;
  late SaveResultUseCase useCase;

  setUp(() {
    mockRepository = MockTreatDeciderRepository();
    useCase = SaveResultUseCase(repository: mockRepository);
  });

  group('SaveResultUseCase', () {
    final testResult = TreatResult(
      id: 'result-1',
      date: DateTime(2024, 3, 15),
      winner: const TeamMember(id: '1', name: 'John'),
      location: const Location(id: '1', name: 'Pizza Place'),
      teamMembers: const [
        TeamMember(id: '1', name: 'John'),
        TeamMember(id: '2', name: 'Jane'),
      ],
      createdAt: DateTime(2024, 3, 10),
    );

    test('should save result to repository', () async {
      when(() => mockRepository.saveResult(testResult))
          .thenAnswer((_) async {});

      await useCase.execute(testResult);

      verify(() => mockRepository.saveResult(testResult)).called(1);
    });

    test('should propagate repository errors', () async {
      when(() => mockRepository.saveResult(testResult))
          .thenThrow(Exception('Storage error'));

      expect(
        () => useCase.execute(testResult),
        throwsException,
      );
    });
  });
}
