import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../core/constants/app_endpoints.dart';

part 'auth_api.g.dart';

@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio) = _AuthApi;

  @POST(AppEndpoints.login)
  Future<Map<String, dynamic>> login(@Body() Map<String, dynamic> body);

  @GET(AppEndpoints.me)
  Future<Map<String, dynamic>> me();
}
