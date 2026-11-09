import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../data/datasources/property_remote_datasource.dart';
import '../../data/repositories/property_repository_impl.dart';
import '../../domain/entities/property_entity.dart';
import '../../domain/repositories/property_repository.dart';

final propertyRemoteDataSourceProvider =
    Provider<PropertyRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return PropertyRemoteDataSourceImpl(apiClient: apiClient);
});

final propertyRepositoryProvider = Provider<PropertyRepository>((ref) {
  final remote = ref.watch(propertyRemoteDataSourceProvider);
  return PropertyRepositoryImpl(remoteDataSource: remote);
});

// Filter state provider
final propertyFilterProvider =
    StateProvider<PropertyFilterCriteria>((ref) => const PropertyFilterCriteria());

// Properties listing provider
final propertiesListProvider =
    FutureProvider.autoDispose<List<PropertyEntity>>((ref) async {
  final repo = ref.watch(propertyRepositoryProvider);
  final filter = ref.watch(propertyFilterProvider);
  return await repo.getProperties(filter: filter);
});

// Single property detail provider
final propertyDetailProvider =
    FutureProvider.autoDispose.family<PropertyEntity, String>((ref, id) async {
  final repo = ref.watch(propertyRepositoryProvider);
  return await repo.getPropertyById(id);
});

// Selected corridor for search hero chip filter
final selectedCorridorProvider = StateProvider<String>((ref) => 'All');
