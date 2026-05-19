// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_session_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$examSessionNotifierHash() =>
    r'5368ef2e27bfa34d7c107f524668d83079287f60';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$ExamSessionNotifier
    extends BuildlessAutoDisposeAsyncNotifier<ExamSessionState> {
  late final String sessionId;

  FutureOr<ExamSessionState> build(
    String sessionId,
  );
}

/// See also [ExamSessionNotifier].
@ProviderFor(ExamSessionNotifier)
const examSessionNotifierProvider = ExamSessionNotifierFamily();

/// See also [ExamSessionNotifier].
class ExamSessionNotifierFamily extends Family<AsyncValue<ExamSessionState>> {
  /// See also [ExamSessionNotifier].
  const ExamSessionNotifierFamily();

  /// See also [ExamSessionNotifier].
  ExamSessionNotifierProvider call(
    String sessionId,
  ) {
    return ExamSessionNotifierProvider(
      sessionId,
    );
  }

  @override
  ExamSessionNotifierProvider getProviderOverride(
    covariant ExamSessionNotifierProvider provider,
  ) {
    return call(
      provider.sessionId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'examSessionNotifierProvider';
}

/// See also [ExamSessionNotifier].
class ExamSessionNotifierProvider extends AutoDisposeAsyncNotifierProviderImpl<
    ExamSessionNotifier, ExamSessionState> {
  /// See also [ExamSessionNotifier].
  ExamSessionNotifierProvider(
    String sessionId,
  ) : this._internal(
          () => ExamSessionNotifier()..sessionId = sessionId,
          from: examSessionNotifierProvider,
          name: r'examSessionNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$examSessionNotifierHash,
          dependencies: ExamSessionNotifierFamily._dependencies,
          allTransitiveDependencies:
              ExamSessionNotifierFamily._allTransitiveDependencies,
          sessionId: sessionId,
        );

  ExamSessionNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.sessionId,
  }) : super.internal();

  final String sessionId;

  @override
  FutureOr<ExamSessionState> runNotifierBuild(
    covariant ExamSessionNotifier notifier,
  ) {
    return notifier.build(
      sessionId,
    );
  }

  @override
  Override overrideWith(ExamSessionNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: ExamSessionNotifierProvider._internal(
        () => create()..sessionId = sessionId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        sessionId: sessionId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<ExamSessionNotifier, ExamSessionState>
      createElement() {
    return _ExamSessionNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ExamSessionNotifierProvider && other.sessionId == sessionId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, sessionId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ExamSessionNotifierRef
    on AutoDisposeAsyncNotifierProviderRef<ExamSessionState> {
  /// The parameter `sessionId` of this provider.
  String get sessionId;
}

class _ExamSessionNotifierProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<ExamSessionNotifier,
        ExamSessionState> with ExamSessionNotifierRef {
  _ExamSessionNotifierProviderElement(super.provider);

  @override
  String get sessionId => (origin as ExamSessionNotifierProvider).sessionId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
