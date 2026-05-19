import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_envelope.freezed.dart';
part 'api_envelope.g.dart';

@Freezed(genericArgumentFactories: true)
class ApiEnvelope<T> with _$ApiEnvelope<T> {
  const factory ApiEnvelope({
    required bool success,
    T? data,
    String? message,
  }) = _ApiEnvelope<T>;

  factory ApiEnvelope.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$ApiEnvelopeFromJson<T>(json, fromJsonT);
}
