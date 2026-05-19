import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../core/constants/app_endpoints.dart';

part 'profile_api.g.dart';

@RestApi()
abstract class ProfileApi {
  factory ProfileApi(Dio dio) = _ProfileApi;

  @PUT(AppEndpoints.myProfile)
  Future<Map<String, dynamic>> updateMyProfile(
    @Body() Map<String, dynamic> body,
  );

  @PUT(AppEndpoints.changePassword)
  Future<Map<String, dynamic>> changePassword(
    @Body() Map<String, dynamic> body,
  );
}
