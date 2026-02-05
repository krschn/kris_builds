import 'dart:math';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:treat_decider/src/domain/entities/location.dart';
import 'package:treat_decider/src/domain/entities/team_member.dart';
import 'package:treat_decider/src/domain/entities/treat_result.dart';
import 'package:treat_decider/src/domain/repositories/treat_decider_repository.dart';
import 'package:treat_decider/src/domain/usecases/decide_winner_usecase.dart';
import 'package:treat_decider/src/domain/usecases/get_history_usecase.dart';
import 'package:treat_decider/src/domain/usecases/save_result_usecase.dart';
import 'package:treat_decider/src/presentation/bloc/treat_decider_bloc.dart';

class MockTreatDeciderRepository extends Mock
    implements TreatDeciderRepository {}

void main() {
  late MockTreatDeciderRepository mockRepository;
  late DecideWinnerUseCase decideWinnerUseCase;
  late SaveResultUseCase saveResultUseCase;
  late GetHistoryUseCase getHistoryUseCase;

  setUp(() {
    mockRepository = MockTreatDeciderRepository();
    decideWinnerUseCase = DecideWinnerUseCase(random: Random(42));
    saveResultUseCase = SaveResultUseCase(repository: mockRepository);
    getHistoryUseCase = GetHistoryUseCase(repository: mockRepository);
  });

  setUpAll(() {
    registerFallbackValue(TreatResult(
      id: 'fallback',
      date: DateTime.now(),
      winner: const TeamMember(id: '1', name: 'Test'),
      location: const Location(id: '1', name: 'Test'),
      teamMembers: const [TeamMember(id: '1', name: 'Test')],
      createdAt: DateTime.now(),
    ));
  });

  TreatDeciderBloc createBloc() => TreatDeciderBloc(
        decideWinnerUseCase: decideWinnerUseCase,
        saveResultUseCase: saveResultUseCase,
        getHistoryUseCase: getHistoryUseCase,
      );

  group('TreatDeciderBloc', () {
    test('initial state is TreatDeciderInitial', () {
      final bloc = createBloc();
      expect(bloc.state, isA<TreatDeciderInitial>());
      bloc.close();
    });

    group('AddTeamMember', () {
      blocTest<TreatDeciderBloc, TreatDeciderState>(
        'emits TreatDeciderInput with new team member',
        build: createBloc,
        act: (bloc) => bloc.add(const AddTeamMember('John')),
        expect: () => [
          isA<TreatDeciderInput>()
              .having((s) => s.teamMembers.length, 'teamMembers.length', 1)
              .having((s) => s.teamMembers.first.name, 'first member name', 'John'),
        ],
      );

      blocTest<TreatDeciderBloc, TreatDeciderState>(
        'does not add duplicate team member names',
        build: createBloc,
        act: (bloc) {
          bloc.add(const AddTeamMember('John'));
          bloc.add(const AddTeamMember('John'));
        },
        expect: () => [
          isA<TreatDeciderInput>()
              .having((s) => s.teamMembers.length, 'teamMembers.length', 1),
        ],
      );
    });

    group('RemoveTeamMember', () {
      blocTest<TreatDeciderBloc, TreatDeciderState>(
        'emits TreatDeciderInput without removed team member',
        build: createBloc,
        seed: () => TreatDeciderInput(
          teamMembers: const [
            TeamMember(id: '1', name: 'John'),
            TeamMember(id: '2', name: 'Jane'),
          ],
          locations: const [],
          date: DateTime(2024, 3, 15),
        ),
        act: (bloc) => bloc.add(const RemoveTeamMember('1')),
        expect: () => [
          isA<TreatDeciderInput>()
              .having((s) => s.teamMembers.length, 'teamMembers.length', 1)
              .having((s) => s.teamMembers.first.name, 'remaining member name', 'Jane'),
        ],
      );
    });

    group('AddLocation', () {
      blocTest<TreatDeciderBloc, TreatDeciderState>(
        'emits TreatDeciderInput with new location',
        build: createBloc,
        act: (bloc) => bloc.add(const AddLocation('Pizza Place')),
        expect: () => [
          isA<TreatDeciderInput>()
              .having((s) => s.locations.length, 'locations.length', 1)
              .having((s) => s.locations.first.name, 'first location name', 'Pizza Place'),
        ],
      );

      blocTest<TreatDeciderBloc, TreatDeciderState>(
        'does not add duplicate location names',
        build: createBloc,
        act: (bloc) {
          bloc.add(const AddLocation('Pizza Place'));
          bloc.add(const AddLocation('Pizza Place'));
        },
        expect: () => [
          isA<TreatDeciderInput>()
              .having((s) => s.locations.length, 'locations.length', 1),
        ],
      );
    });

    group('RemoveLocation', () {
      blocTest<TreatDeciderBloc, TreatDeciderState>(
        'emits TreatDeciderInput without removed location',
        build: createBloc,
        seed: () => TreatDeciderInput(
          teamMembers: const [],
          locations: const [
            Location(id: '1', name: 'Pizza Place'),
            Location(id: '2', name: 'Burger Joint'),
          ],
          date: DateTime(2024, 3, 15),
        ),
        act: (bloc) => bloc.add(const RemoveLocation('1')),
        expect: () => [
          isA<TreatDeciderInput>()
              .having((s) => s.locations.length, 'locations.length', 1)
              .having((s) => s.locations.first.name, 'remaining location name', 'Burger Joint'),
        ],
      );
    });

    group('SetDate', () {
      blocTest<TreatDeciderBloc, TreatDeciderState>(
        'emits TreatDeciderInput with new date',
        build: createBloc,
        act: (bloc) => bloc.add(SetDate(DateTime(2024, 6, 20))),
        expect: () => [
          isA<TreatDeciderInput>()
              .having((s) => s.date, 'date', DateTime(2024, 6, 20)),
        ],
      );
    });

    group('DecideWinner', () {
      blocTest<TreatDeciderBloc, TreatDeciderState>(
        'emits selecting and result states when inputs are valid',
        build: createBloc,
        seed: () => TreatDeciderInput(
          teamMembers: const [
            TeamMember(id: '1', name: 'John'),
            TeamMember(id: '2', name: 'Jane'),
          ],
          locations: const [
            Location(id: '1', name: 'Pizza Place'),
          ],
          date: DateTime(2024, 3, 15),
        ),
        setUp: () {
          when(() => mockRepository.saveResult(any()))
              .thenAnswer((_) async {});
          when(() => mockRepository.getHistory())
              .thenAnswer((_) async => []);
        },
        act: (bloc) => bloc.add(const DecideWinner()),
        wait: const Duration(milliseconds: 4000),
        expect: () => [
          isA<TreatDeciderSelecting>()
              .having((s) => s.selectedMember, 'selectedMember', isNotNull)
              .having((s) => s.selectedLocation, 'selectedLocation', isNotNull),
          isA<TreatDeciderResult>()
              .having((s) => s.result, 'result', isNotNull),
        ],
        verify: (_) {
          verify(() => mockRepository.saveResult(any())).called(1);
        },
      );

      blocTest<TreatDeciderBloc, TreatDeciderState>(
        'emits error when team members is empty',
        build: createBloc,
        seed: () => TreatDeciderInput(
          teamMembers: const [],
          locations: const [Location(id: '1', name: 'Pizza Place')],
          date: DateTime(2024, 3, 15),
        ),
        act: (bloc) => bloc.add(const DecideWinner()),
        expect: () => [
          isA<TreatDeciderError>()
              .having((s) => s.message, 'message', contains('team member')),
        ],
      );

      blocTest<TreatDeciderBloc, TreatDeciderState>(
        'emits error when locations is empty',
        build: createBloc,
        seed: () => TreatDeciderInput(
          teamMembers: const [TeamMember(id: '1', name: 'John')],
          locations: const [],
          date: DateTime(2024, 3, 15),
        ),
        act: (bloc) => bloc.add(const DecideWinner()),
        expect: () => [
          isA<TreatDeciderError>()
              .having((s) => s.message, 'message', contains('location')),
        ],
      );
    });

    group('LoadHistory', () {
      blocTest<TreatDeciderBloc, TreatDeciderState>(
        'loads history from repository',
        build: createBloc,
        setUp: () {
          when(() => mockRepository.getHistory()).thenAnswer((_) async => [
                TreatResult(
                  id: 'result-1',
                  date: DateTime(2024, 3, 15),
                  winner: const TeamMember(id: '1', name: 'John'),
                  location: const Location(id: '1', name: 'Pizza Place'),
                  teamMembers: const [TeamMember(id: '1', name: 'John')],
                  createdAt: DateTime(2024, 3, 10),
                ),
              ]);
        },
        act: (bloc) => bloc.add(const LoadHistory()),
        expect: () => [
          isA<TreatDeciderHistoryLoaded>()
              .having((s) => s.history.length, 'history.length', 1),
        ],
      );
    });

    group('ClearHistory', () {
      blocTest<TreatDeciderBloc, TreatDeciderState>(
        'clears history and loads empty list',
        build: createBloc,
        setUp: () {
          when(() => mockRepository.clearHistory()).thenAnswer((_) async {});
          when(() => mockRepository.getHistory()).thenAnswer((_) async => []);
        },
        act: (bloc) => bloc.add(const ClearHistory()),
        expect: () => [
          isA<TreatDeciderHistoryLoaded>()
              .having((s) => s.history, 'history', isEmpty),
        ],
        verify: (_) {
          verify(() => mockRepository.clearHistory()).called(1);
        },
      );
    });

    group('ResetForm', () {
      blocTest<TreatDeciderBloc, TreatDeciderState>(
        'resets to initial input state',
        build: createBloc,
        seed: () => TreatDeciderResult(
          result: TreatResult(
            id: 'result-1',
            date: DateTime(2024, 3, 15),
            winner: const TeamMember(id: '1', name: 'John'),
            location: const Location(id: '1', name: 'Pizza Place'),
            teamMembers: const [TeamMember(id: '1', name: 'John')],
            createdAt: DateTime(2024, 3, 10),
          ),
          history: const [],
        ),
        act: (bloc) => bloc.add(const ResetForm()),
        expect: () => [
          isA<TreatDeciderInput>()
              .having((s) => s.teamMembers, 'teamMembers', isEmpty)
              .having((s) => s.locations, 'locations', isEmpty),
        ],
      );
    });
  });
}
