// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_result_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sessionResultHash() => r'33583b788dd75c58f562c748763a3b9e9f20d428';

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

/// See also [sessionResult].
@ProviderFor(sessionResult)
const sessionResultProvider = SessionResultFamily();

/// See also [sessionResult].
class SessionResultFamily extends Family<AsyncValue<SessionResult>> {
  /// See also [sessionResult].
  const SessionResultFamily();

  /// See also [sessionResult].
  SessionResultProvider call(
    String id,
  ) {
    return SessionResultProvider(
      id,
    );
  }

  @override
  SessionResultProvider getProviderOverride(
    covariant SessionResultProvider provider,
  ) {
    return call(
      provider.id,
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
  String? get name => r'sessionResultProvider';
}

/// See also [sessionResult].
class SessionResultProvider extends AutoDisposeFutureProvider<SessionResult> {
  /// See also [sessionResult].
  SessionResultProvider(
    String id,
  ) : this._internal(
          (ref) => sessionResult(
            ref as SessionResultRef,
            id,
          ),
          from: sessionResultProvider,
          name: r'sessionResultProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$sessionResultHash,
          dependencies: SessionResultFamily._dependencies,
          allTransitiveDependencies:
              SessionResultFamily._allTransitiveDependencies,
          id: id,
        );

  SessionResultProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final String id;

  @override
  Override overrideWith(
    FutureOr<SessionResult> Function(SessionResultRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SessionResultProvider._internal(
        (ref) => create(ref as SessionResultRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<SessionResult> createElement() {
    return _SessionResultProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SessionResultProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SessionResultRef on AutoDisposeFutureProviderRef<SessionResult> {
  /// The parameter `id` of this provider.
  String get id;
}

class _SessionResultProviderElement
    extends AutoDisposeFutureProviderElement<SessionResult>
    with SessionResultRef {
  _SessionResultProviderElement(super.provider);

  @override
  String get id => (origin as SessionResultProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
