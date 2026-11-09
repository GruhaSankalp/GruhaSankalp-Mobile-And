import '../../domain/entities/property_entity.dart';

class PropertyModel extends PropertyEntity {
  const PropertyModel({
    required super.id,
    required super.title,
    required super.slug,
    required super.price,
    required super.pricePerSqFt,
    required super.carpetArea,
    required super.superBuiltUpArea,
    required super.bhk,
    required super.propertyType,
    required super.facing,
    required super.locality,
    required super.city,
    required super.legalTrustScore,
    required super.verificationState,
    required super.reraNumber,
    required super.sroDeedNumber,
    required super.ptinNumber,
    required super.possessionStatus,
    required super.coverImageUrl,
    required super.galleryImages,
    required super.amenities,
    required super.ownerName,
    super.isDirectOwner,
    required super.description,
    super.thirtyYearEcStatus,
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? 'Luxury Sovereign Villa',
      slug: json['slug'] ?? 'luxury-sovereign-villa',
      price: json['price'] as num? ?? 18500000,
      pricePerSqFt: json['pricePerSqFt'] as num? ?? 8500,
      carpetArea: json['carpetArea'] as num? ?? 1850,
      superBuiltUpArea: json['superBuiltUpArea'] as num? ?? 2200,
      bhk: json['bhk'] as int? ?? 3,
      propertyType: json['propertyType'] ?? 'Flat',
      facing: json['facing'] ?? 'East',
      locality: json['locality'] ?? 'Financial District',
      city: json['city'] ?? 'Hyderabad',
      legalTrustScore: json['legalTrustScore'] as int? ?? 98,
      verificationState: json['verificationState'] ?? 'Verified',
      reraNumber: json['reraNumber'] ?? 'P02400001234',
      sroDeedNumber: json['sroDeedNumber'] ?? 'SRO-HYD-4019/2021',
      ptinNumber: json['ptinNumber'] ?? 'PTIN-10928374',
      possessionStatus: json['possessionStatus'] ?? 'Ready to Move',
      coverImageUrl: json['coverImageUrl'] ??
          'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?auto=format&fit=crop&w=800&q=80',
      galleryImages: (json['galleryImages'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [
            'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=800&q=80',
            'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?auto=format&fit=crop&w=800&q=80',
          ],
      amenities: (json['amenities'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          ['Clubhouse', 'Swimming Pool', 'EV Charging', '24/7 Security'],
      ownerName: json['ownerName'] ?? 'Rajesh Varma (Direct Owner)',
      isDirectOwner: json['isDirectOwner'] as bool? ?? true,
      description: json['description'] ??
          'Super-luxury sovereign clearinghouse certified 3 BHK apartment with unobstructed corridor views and 100% verified 30-year title lineage.',
      thirtyYearEcStatus: json['thirtyYearEcStatus'] as int? ?? 100,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'slug': slug,
      'price': price,
      'pricePerSqFt': pricePerSqFt,
      'carpetArea': carpetArea,
      'superBuiltUpArea': superBuiltUpArea,
      'bhk': bhk,
      'propertyType': propertyType,
      'facing': facing,
      'locality': locality,
      'city': city,
      'legalTrustScore': legalTrustScore,
      'verificationState': verificationState,
      'reraNumber': reraNumber,
      'sroDeedNumber': sroDeedNumber,
      'ptinNumber': ptinNumber,
      'possessionStatus': possessionStatus,
      'coverImageUrl': coverImageUrl,
      'galleryImages': galleryImages,
      'amenities': amenities,
      'ownerName': ownerName,
      'isDirectOwner': isDirectOwner,
      'description': description,
      'thirtyYearEcStatus': thirtyYearEcStatus,
    };
  }
}

