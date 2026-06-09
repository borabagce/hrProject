import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../app/providers.dart';
import '../../../core/network/error_mapper.dart';
import '../domain/analytics.dart';
import 'analytics_api.dart';

part 'analytics_repository.g.dart';

class AnalyticsRepository {
  AnalyticsRepository(this._api);

  final AnalyticsApi _api;

  Future<MyAnalytics> fetchMyAnalytics() async {
    try {
      final Map<String, dynamic> resp = await _api.myAnalytics();
      final Map<String, dynamic> data =
          resp['data'] as Map<String, dynamic>;

      final List<dynamic> rawHistory =
          (data['sessionHistory'] as List<dynamic>?) ?? <dynamic>[];
      final List<Map<String, dynamic>> enrichedHistory =
          rawHistory.map((dynamic item) {
        if (item is! Map<String, dynamic>) return <String, dynamic>{};
        String? title = item['testTitle'] as String?;
        if (title == null || title.isEmpty) {
          final Object? nested = item['testId'];
          if (nested is Map<String, dynamic>) {
            title = nested['title'] as String?;
          }
        }
        if (title == null || title.isEmpty) {
          final Object? nested = item['test'];
          if (nested is Map<String, dynamic>) {
            title = nested['title'] as String?;
          }
        }
        return <String, dynamic>{...item, 'testTitle': title};
      }).toList();

      return MyAnalytics.fromJson(<String, dynamic>{
        'sessionHistory': enrichedHistory,
        'wrongByCategory': data['wrongByCategory'] ?? <dynamic>[],
        'weeklyTrend': data['weeklyTrend'] ?? <dynamic>[],
      });
    } catch (e, st) {
      throw mapDioError(e, st);
    }
  }
}

@Riverpod(keepAlive: true)
AnalyticsRepository analyticsRepository(AnalyticsRepositoryRef ref) {
  return AnalyticsRepository(ref.watch(analyticsApiProvider));
}
