import '../entities/treat_result.dart';

abstract class TreatDeciderRepository {
  Future<void> saveResult(TreatResult result);
  Future<List<TreatResult>> getHistory();
  Future<void> clearHistory();
}
