import 'data/datasources/treat_decider_datasource.dart';
import 'data/repositories/treat_decider_repository_impl.dart';
import 'domain/repositories/treat_decider_repository.dart';
import 'domain/usecases/decide_winner_usecase.dart';
import 'domain/usecases/get_history_usecase.dart';
import 'domain/usecases/save_result_usecase.dart';
import 'presentation/bloc/treat_decider_bloc.dart';

class TreatDeciderModule {
  TreatDeciderModule({required TreatDeciderDataSource dataSource})
      : _dataSource = dataSource {
    _repository = TreatDeciderRepositoryImpl(dataSource: _dataSource);
    _decideWinnerUseCase = DecideWinnerUseCase();
    _saveResultUseCase = SaveResultUseCase(repository: _repository);
    _getHistoryUseCase = GetHistoryUseCase(repository: _repository);
  }

  final TreatDeciderDataSource _dataSource;
  late final TreatDeciderRepository _repository;
  late final DecideWinnerUseCase _decideWinnerUseCase;
  late final SaveResultUseCase _saveResultUseCase;
  late final GetHistoryUseCase _getHistoryUseCase;

  TreatDeciderRepository get repository => _repository;

  DecideWinnerUseCase get decideWinnerUseCase => _decideWinnerUseCase;

  SaveResultUseCase get saveResultUseCase => _saveResultUseCase;

  GetHistoryUseCase get getHistoryUseCase => _getHistoryUseCase;

  TreatDeciderBloc createTreatDeciderBloc() => TreatDeciderBloc(
        decideWinnerUseCase: _decideWinnerUseCase,
        saveResultUseCase: _saveResultUseCase,
        getHistoryUseCase: _getHistoryUseCase,
      );
}
