import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/analytics_repository.dart';
import '../domain/analytics.dart';

part 'analytics_provider.g.dart';

@riverpod
Future<MyAnalytics> myAnalytics(MyAnalyticsRef ref) {
  return ref.watch(analyticsRepositoryProvider).fetchMyAnalytics();
}
