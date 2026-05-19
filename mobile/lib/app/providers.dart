import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/network/dio_client.dart';
import '../core/storage/isar_db.dart';
import '../core/storage/secure_token_store.dart';
import '../features/auth/data/auth_api.dart';
import '../features/auth/providers/auth_notifier.dart';
import '../features/exams/data/exam_api.dart';
import '../features/profile/data/profile_api.dart';
import '../features/results/data/analytics_api.dart';

part 'providers.g.dart';

@Riverpod(keepAlive: true)
SecureTokenStore secureTokenStore(SecureTokenStoreRef ref) {
  const FlutterSecureStorage storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  return SecureTokenStore(storage);
}

@Riverpod(keepAlive: true)
Dio dio(DioRef ref) {
  final SecureTokenStore tokens = ref.watch(secureTokenStoreProvider);
  return DioClient.create(
    tokens: tokens,
    onLogout: () async {
      await ref.read(authNotifierProvider.notifier).forceLogout();
    },
  );
}

@Riverpod(keepAlive: true)
AuthApi authApi(AuthApiRef ref) => AuthApi(ref.watch(dioProvider));

@Riverpod(keepAlive: true)
ExamApi examApi(ExamApiRef ref) => ExamApi(ref.watch(dioProvider));

@Riverpod(keepAlive: true)
AnalyticsApi analyticsApi(AnalyticsApiRef ref) =>
    AnalyticsApi(ref.watch(dioProvider));

@Riverpod(keepAlive: true)
ProfileApi profileApi(ProfileApiRef ref) =>
    ProfileApi(ref.watch(dioProvider));

@Riverpod(keepAlive: true)
Future<IsarDb> isarDb(IsarDbRef ref) => IsarDb.open();
