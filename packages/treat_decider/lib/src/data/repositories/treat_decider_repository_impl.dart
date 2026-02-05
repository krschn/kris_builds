import '../../domain/entities/treat_result.dart';
import '../../domain/repositories/treat_decider_repository.dart';
import '../datasources/treat_decider_datasource.dart';
import '../models/treat_result_model.dart';

class TreatDeciderRepositoryImpl implements TreatDeciderRepository {
  const TreatDeciderRepositoryImpl({required this.dataSource});

  final TreatDeciderDataSource dataSource;

  @override
  Future<void> saveResult(TreatResult result) async {
    final model = TreatResultModel.fromEntity(result);
    await dataSource.saveResult(model);
  }

  @override
  Future<List<TreatResult>> getHistory() async {
    return dataSource.getHistory();
  }

  @override
  Future<void> clearHistory() async {
    await dataSource.clearHistory();
  }
}
