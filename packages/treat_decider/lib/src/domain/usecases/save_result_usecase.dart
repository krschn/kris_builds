import '../entities/treat_result.dart';
import '../repositories/treat_decider_repository.dart';

class SaveResultUseCase {
  const SaveResultUseCase({required this.repository});

  final TreatDeciderRepository repository;

  Future<void> execute(TreatResult result) async {
    await repository.saveResult(result);
  }
}
