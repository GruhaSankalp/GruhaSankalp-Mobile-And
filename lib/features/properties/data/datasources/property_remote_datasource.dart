import '../../../../core/network/api_client.dart';
import '../../domain/repositories/property_repository.dart';
import '../models/property_model.dart';

abstract class PropertyRemoteDataSource {
  Future<List<PropertyModel>> getProperties({PropertyFilterCriteria? filter});
  Future<PropertyModel> getPropertyById(String id);
}

class PropertyRemoteDataSourceImpl implements PropertyRemoteDataSource {
  final ApiClient _apiClient;

  PropertyRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<List<PropertyModel>> getProperties({
    PropertyFilterCriteria? filter,
  }) async {
    try {
      final response = await _apiClient.get(
        '/properties',
        queryParameters: {
          if (filter?.locality != null) 'locality': filter!.locality,
          if (filter?.minBhk != null) 'bhk': filter!.minBhk,
          if (filter?.minPrice != null) 'minPrice': filter!.minPrice,
          if (filter?.maxPrice != null) 'maxPrice': filter!.maxPrice,
          if (filter?.minCadastralScore != null)
            'minScore': filter!.minCadastralScore,
        },
      );

      final dataList = (response.data is List)
          ? response.data as List
          : (response.data['data'] as List? ?? []);
      return dataList.map((e) => PropertyModel.fromJson(e)).toList();
    } catch (_) {
      // Offline fallback mock data representing sovereign audited real estate
      return _mockProperties.where((p) {
        if (filter?.locality != null &&
            filter!.locality!.isNotEmpty &&
            !p.locality.toLowerCase().contains(filter.locality!.toLowerCase())) {
          return false;
        }
        if (filter?.minBhk != null && p.bhk < filter!.minBhk!) {
          return false;
        }
        if (filter?.minCadastralScore != null &&
            p.legalTrustScore < filter!.minCadastralScore!) {
          return false;
        }
        return true;
      }).toList();
    }
  }

  @override
  Future<PropertyModel> getPropertyById(String id) async {
    try {
      final response = await _apiClient.get('/properties/$id');
      final data = response.data['data'] ?? response.data;
      return PropertyModel.fromJson(data);
    } catch (_) {
      return _mockProperties.firstWhere(
        (p) => p.id == id,
        orElse: () => _mockProperties.first,
      );
    }
  }

  static final List<PropertyModel> _mockProperties = [
    const PropertyModel(
      id: 'prop-sov-101',
      title: '3 BHK Sky Villa at Kokapet Golden Mile',
      slug: '3-bhk-sky-villa-kokapet',
      price: 21500000,
      pricePerSqFt: 9600,
      carpetArea: 2240,
      superBuiltUpArea: 2800,
      bhk: 3,
      propertyType: 'Flat',
      facing: 'East (100% Vastu)',
      locality: 'Kokapet',
      city: 'Hyderabad',
      legalTrustScore: 98,
      verificationState: 'Verified',
      reraNumber: 'P02400004591',
      sroDeedNumber: 'SRO-GANDIPET-7812/2022',
      ptinNumber: 'PTIN-88910243',
      possessionStatus: 'Ready to Move',
      coverImageUrl:
          'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?auto=format&fit=crop&w=800&q=80',
      galleryImages: [
        'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1600566753376-12c8ab7fb75b?auto=format&fit=crop&w=800&q=80',
      ],
      amenities: [
        'Infinity Pool',
        'Clubhouse (40k sqft)',
        'EV Fast Charging',
        '24/7 Security & CCTV',
        'Vastu Compliant',
      ],
      ownerName: 'Suresh Reddy (Direct Owner)',
      isDirectOwner: true,
      description:
          'Institutional grade luxury residence overlooking the Osmansagar reservoir. Complete 30-year title lineage verified with clean Encumbrance Certificate and RERA clearance.',
      thirtyYearEcStatus: 100,
    ),
    const PropertyModel(
      id: 'prop-sov-102',
      title: '4 BHK Grand Sovereign Penthouse',
      slug: '4-bhk-grand-sovereign-penthouse',
      price: 38500000,
      pricePerSqFt: 11200,
      carpetArea: 3450,
      superBuiltUpArea: 4200,
      bhk: 4,
      propertyType: 'Penthouse',
      facing: 'North-East',
      locality: 'Financial District',
      city: 'Hyderabad',
      legalTrustScore: 96,
      verificationState: 'Verified',
      reraNumber: 'P02400008812',
      sroDeedNumber: 'SRO-SERILINGAMPALLY-9921/2023',
      ptinNumber: 'PTIN-90124871',
      possessionStatus: 'Immediate',
      coverImageUrl:
          'https://images.unsplash.com/photo-1600607687920-4e2a09cf159d?auto=format&fit=crop&w=800&q=80',
      galleryImages: [
        'https://images.unsplash.com/photo-1600566753190-17f0baa2a6c3?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1600585154526-990dced4db0d?auto=format&fit=crop&w=800&q=80',
      ],
      amenities: [
        'Private Elevator',
        'Terrace Garden',
        'Double-height Living',
        'Concierge',
      ],
      ownerName: 'Prestige Sovereign Towers',
      isDirectOwner: false,
      description:
          'Ultra-exclusive duplex penthouse located in Hyderabad high-growth corridor. Triple verified legal standing with zero encumbrance.',
      thirtyYearEcStatus: 100,
    ),
    const PropertyModel(
      id: 'prop-sov-103',
      title: 'Gated Luxury Villa at Tellapur Neo-City',
      slug: 'gated-luxury-villa-tellapur',
      price: 29500000,
      pricePerSqFt: 8200,
      carpetArea: 3600,
      superBuiltUpArea: 4100,
      bhk: 4,
      propertyType: 'Villa',
      facing: 'East',
      locality: 'Tellapur',
      city: 'Hyderabad',
      legalTrustScore: 94,
      verificationState: 'Verified',
      reraNumber: 'P02400006711',
      sroDeedNumber: 'SRO-SANGAREDDY-3312/2021',
      ptinNumber: 'PTIN-66219082',
      possessionStatus: 'Ready to Move',
      coverImageUrl:
          'https://images.unsplash.com/photo-1613490493576-7fde63acd811?auto=format&fit=crop&w=800&q=80',
      galleryImages: [
        'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=800&q=80',
      ],
      amenities: [
        'Private Lawn',
        '2 Car Parking',
        'Solar Roof',
        'Gated Enclave',
      ],
      ownerName: 'Anand Kumar (Direct Owner)',
      isDirectOwner: true,
      description:
          'Spacious contemporary villa with private landscaped garden in Tellapur neo-city corridor. Zero brokerage direct owner listing.',
      thirtyYearEcStatus: 100,
    ),
  ];
}

