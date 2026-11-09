import '../entities/property_entity.dart';

class PropertyFilterCriteria {
  final String? locality;
  final String? propertyType;
  final int? minBhk;
  final num? minPrice;
  final num? maxPrice;
  final int? minCadastralScore;
  final bool? reraOnly;
  final bool? directOwnerOnly;

  const PropertyFilterCriteria({
    this.locality,
    this.propertyType,
    this.minBhk,
    this.minPrice,
    this.maxPrice,
    this.minCadastralScore,
    this.reraOnly,
    this.directOwnerOnly,
  });
}

abstract class PropertyRepository {
  Future<List<PropertyEntity>> getProperties({PropertyFilterCriteria? filter});
  Future<PropertyEntity> getPropertyById(String id);
  Future<List<PropertyEntity>> getTrendingCorridorProperties(String corridor);
}
