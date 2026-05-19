import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../app/providers.dart';
import '../../../core/network/error_mapper.dart';
import '../../auth/domain/auth_user.dart';
import 'profile_api.dart';

part 'profile_repository.g.dart';

class ProfileRepository {
  ProfileRepository(this._api);

  final ProfileApi _api;

  Future<AuthUser> updateFullName(String fullName) async {
    try {
      final Map<String, dynamic> resp = await _api.updateMyProfile(
        <String, dynamic>{'fullName': fullName},
      );
      return AuthUser.fromJson(resp['data'] as Map<String, dynamic>);
    } catch (e, st) {
      throw mapDioError(e, st);
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _api.changePassword(<String, dynamic>{
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      });
    } catch (e, st) {
      throw mapDioError(e, st);
    }
  }
}

@Riverpod(keepAlive: true)
ProfileRepository profileRepository(ProfileRepositoryRef ref) {
  return ProfileRepository(ref.watch(profileApiProvider));
}
