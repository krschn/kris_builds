import 'package:calculator/src/domain/entities/calculation.dart';
import 'package:calculator/src/domain/repositories/calculator_repository.dart';
import 'package:calculator/src/domain/usecases/append_number_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCalculatorRepository extends Mock implements CalculatorRepository {}

void main() {
  late AppendNumberUseCase useCase;
  late MockCalculatorRepository mockRepository;

  setUp(() {
    mockRepository = MockCalculatorRepository();
    useCase = AppendNumberUseCase(mockRepository);
  });

  group('AppendNumberUseCase', () {
    test('should call repository.appendNumber with correct number', () {
      // Arrange
      const Calculation expectedCalculation = Calculation(currentNumber: '5');
      when(() => mockRepository.appendNumber('5'))
          .thenReturn(expectedCalculation);

      // Act
      final Calculation result = useCase('5');

      // Assert
      expect(result, expectedCalculation);
      verify(() => mockRepository.appendNumber('5')).called(1);
    });

    test('should handle multiple digits', () {
      // Arrange
      const Calculation expectedCalculation = Calculation(currentNumber: '123');
      when(() => mockRepository.appendNumber('3'))
          .thenReturn(expectedCalculation);

      // Act
      final Calculation result = useCase('3');

      // Assert
      expect(result, expectedCalculation);
      verify(() => mockRepository.appendNumber('3')).called(1);
    });
  });
}
