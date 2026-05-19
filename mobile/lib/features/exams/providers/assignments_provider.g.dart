// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assignments_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$assignmentsHash() => r'9d50c0c2afc5b7e524418df109ebbd0a07c4ca86';

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

/// See also [assignments].
@ProviderFor(assignments)
const assignmentsProvider = AssignmentsFamily();

/// See also [assignments].
class AssignmentsFamily extends Family<AsyncValue<List<Assignment>>> {
  /// See also [assignments].
  const AssignmentsFamily();

  /// See also [assignments].
  AssignmentsProvider call({
    String? status,
  }) {
    return AssignmentsProvider(
      status: status,
    );
  }

  @override
  AssignmentsProvider getProviderOverride(
    covariant AssignmentsProvider provider,
  ) {
    return call(
      status: provider.status,
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
  String? get name => r'assignmentsProvider';
}

/// See also [assignments].
class AssignmentsProvider extends AutoDisposeFutureProvider<List<Assignment>> {
  /// See also [assignments].
  AssignmentsProvider({
    String? status,
  }) : this._internal(
          (ref) => assignments(
            ref as AssignmentsRef,
            status: status,
          ),
          from: assignmentsProvider,
          name: r'assignmentsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$assignmentsHash,
          dependencies: AssignmentsFamily._dependencies,
          allTransitiveDependencies:
              AssignmentsFamily._allTransitiveDependencies,
          status: status,
        );

  AssignmentsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.status,
  }) : super.internal();

  final String? status;

  @override
  Override overrideWith(
    FutureOr<List<Assignment>> Function(AssignmentsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AssignmentsProvider._internal(
        (ref) => create(ref as AssignmentsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        status: status,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Assignment>> createElement() {
    return _AssignmentsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AssignmentsProvider && other.status == status;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, status.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AssignmentsRef on AutoDisposeFutureProviderRef<List<Assignment>> {
  /// The parameter `status` of this provider.
  String? get status;
}

class _AssignmentsProviderElement
    extends AutoDisposeFutureProviderElement<List<Assignment>>
    with AssignmentsRef {
  _AssignmentsProviderElement(super.provider);

  @override
  String? get status => (origin as AssignmentsProvider).status;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
