import '../entities/treat_result.dart';
import '../repositories/treat_decider_repository.dart';

class GetHistoryUseCase {
  const GetHistoryUseCase({required this.repository});

  final TreatDeciderRepository repository;

  Future<List<TreatResult>> execute() async {
    return repository.getHistory();
  }
}
