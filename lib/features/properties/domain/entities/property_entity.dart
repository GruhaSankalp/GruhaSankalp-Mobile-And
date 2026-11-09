import 'package:equatable/equatable.dart';

class PropertyEntity extends Equatable {
  final String id;
  final String title;
  final String slug;
  final num price;
  final num pricePerSqFt;
  final num carpetArea;
  final num superBuiltUpArea;
  final int bhk;
  final String propertyType; // Flat, Villa, Plot, Commercial
  final String facing;
  final String locality;
  final String city;
  final int legalTrustScore; // 0-100
  final String verificationState; // Verified, In Review, Flagged
  final String reraNumber;
  final String sroDeedNumber;
  final String ptinNumber;
  final String possessionStatus;
  final String coverImageUrl;
  final List<String> galleryImages;
  final List<String> amenities;
  final String ownerName;
  final bool isDirectOwner;
  final String description;
  final int thirtyYearEcStatus; // 100 for clean

  const PropertyEntity({
    required this.id,
    required this.title,
    required this.slug,
    required this.price,
    required this.pricePerSqFt,
    required this.carpetArea,
    required this.superBuiltUpArea,
    required this.bhk,
    required this.propertyType,
    required this.facing,
    required this.locality,
    required this.city,
    required this.legalTrustScore,
    required this.verificationState,
    required this.reraNumber,
    required this.sroDeedNumber,
    required this.ptinNumber,
    required this.possessionStatus,
    required this.coverImageUrl,
    required this.galleryImages,
    required this.amenities,
    required this.ownerName,
    this.isDirectOwner = true,
    required this.description,
    this.thirtyYearEcStatus = 100,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        slug,
        price,
        carpetArea,
        bhk,
        locality,
        legalTrustScore,
        verificationState,
      ];
}
