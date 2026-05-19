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
      return MyAnalytics.fromJson(<String, dynamic>{
        'sessionHistory': data['sessionHistory'] ?? <dynamic>[],
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
