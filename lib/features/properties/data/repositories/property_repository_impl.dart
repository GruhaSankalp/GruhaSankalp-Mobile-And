import '../../domain/entities/property_entity.dart';
import '../../domain/repositories/property_repository.dart';
import '../datasources/property_remote_datasource.dart';

class PropertyRepositoryImpl implements PropertyRepository {
  final PropertyRemoteDataSource _remoteDataSource;

  PropertyRepositoryImpl({required PropertyRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<List<PropertyEntity>> getProperties({
    PropertyFilterCriteria? filter,
  }) async {
    return await _remoteDataSource.getProperties(filter: filter);
  }

  @override
  Future<PropertyEntity> getPropertyById(String id) async {
    return await _remoteDataSource.getPropertyById(id);
  }

  @override
  Future<List<PropertyEntity>> getTrendingCorridorProperties(
      String corridor) async {
    return await _remoteDataSource.getProperties(
      filter: PropertyFilterCriteria(locality: corridor),
    );
  }
}

