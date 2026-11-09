import '../entities/property_entity.dart';
import '../repositories/property_repository.dart';

class GetPropertiesUseCase {
  final PropertyRepository _repository;
  GetPropertiesUseCase(this._repository);

  Future<List<PropertyEntity>> execute({PropertyFilterCriteria? filter}) {
    return _repository.getProperties(filter: filter);
  }
}

class GetPropertyDetailUseCase {
  final PropertyRepository _repository;
  GetPropertyDetailUseCase(this._repository);

  Future<PropertyEntity> execute(String id) {
    return _repository.getPropertyById(id);
  }
}
