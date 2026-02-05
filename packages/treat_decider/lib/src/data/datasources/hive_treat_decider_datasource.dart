import 'dart:convert';

import 'package:hive/hive.dart';

import '../models/treat_result_model.dart';
import 'treat_decider_datasource.dart';

class HiveTreatDeciderDataSource implements TreatDeciderDataSource {
  HiveTreatDeciderDataSource(this._box);

  final Box<dynamic> _box;

  static const String _historyKey = 'treat_history';

  @override
  Future<void> saveResult(TreatResultModel result) async {
    final history = await getHistory();
    history.insert(0, result);
    final jsonList = history.map((r) => r.toJson()).toList();
    await _box.put(_historyKey, jsonEncode(jsonList));
  }

  @override
  Future<List<TreatResultModel>> getHistory() async {
    final String? historyJson = _box.get(_historyKey) as String?;
    if (historyJson == null) return [];

    final List<dynamic> jsonList = jsonDecode(historyJson) as List<dynamic>;
    return jsonList
        .map((json) =>
            TreatResultModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> clearHistory() async {
    await _box.delete(_historyKey);
  }
}
