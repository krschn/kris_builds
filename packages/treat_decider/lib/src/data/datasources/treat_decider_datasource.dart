import '../models/treat_result_model.dart';

abstract class TreatDeciderDataSource {
  Future<void> saveResult(TreatResultModel result);
  Future<List<TreatResultModel>> getHistory();
  Future<void> clearHistory();
}
