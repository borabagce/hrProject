import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../core/constants/app_endpoints.dart';

part 'analytics_api.g.dart';

@RestApi()
abstract class AnalyticsApi {
  factory AnalyticsApi(Dio dio) = _AnalyticsApi;

  @GET(AppEndpoints.myAnalytics)
  Future<Map<String, dynamic>> myAnalytics();
}
