import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../core/constants/app_endpoints.dart';

part 'exam_api.g.dart';

@RestApi()
abstract class ExamApi {
  factory ExamApi(Dio dio) = _ExamApi;

  @GET(AppEndpoints.myAssignments)
  Future<Map<String, dynamic>> myAssignments(
    @Query('status') String? status,
  );

  @PATCH('/assignments/{id}/start')
  Future<Map<String, dynamic>> startAssignment(@Path('id') String id);

  @PATCH('/assignments/{id}/complete')
  Future<Map<String, dynamic>> completeAssignment(@Path('id') String id);

  @GET('/sessions/{id}/questions')
  Future<Map<String, dynamic>> sessionQuestions(@Path('id') String id);

  @POST('/sessions/{id}/answer')
  Future<Map<String, dynamic>> submitAnswer(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );

  @GET('/sessions/{id}/result')
  Future<Map<String, dynamic>> sessionResult(@Path('id') String id);

  @GET(AppEndpoints.mySessions)
  Future<Map<String, dynamic>> mySessions(
    @Queries() Map<String, dynamic> queries,
  );
}
