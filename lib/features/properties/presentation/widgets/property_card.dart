import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/cadastral_trust_badge.dart';
import '../../domain/entities/property_entity.dart';

class PropertyCard extends StatelessWidget {
  final PropertyEntity property;
  final VoidCallback onTap;
  final VoidCallback? onBookVisit;

  const PropertyCard({
    super.key,
    required this.property,
    required this.onTap,
    this.onBookVisit,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderLight, width: 1),
          boxShadow: [
            BoxShadow(
              color: AppColors.navy950.withOpacity(0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with Cadastral Badge Overlay
            Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: property.coverImageUrl,
                  height: 190,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    height: 190,
                    color: AppColors.canvasLight,
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(AppColors.gold500),
                      ),
                    ),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    height: 190,
                    color: AppColors.navy900,
                    child: const Icon(Icons.apartment, color: AppColors.gold500, size: 48),
                  ),
                ),

                // Top Floating Badges
                Positioned(
                  top: 12,
                  left: 12,
                  child: CadastralTrustBadge(
                    score: property.legalTrustScore,
                    compact: false,
                  ),
                ),

                if (property.isDirectOwner)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.navy950.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: AppColors.gold500, width: 0.8),
                      ),
                      child: const Text(
                        'Direct Owner • 0% Fee',
                        style: TextStyle(
                          color: AppColors.gold500,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // Card Body
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price and Rate
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        CurrencyFormatter.formatCompact(property.price),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.navy950,
                          letterSpacing: -0.2,
                        ),
                      ),
                      Text(
                        CurrencyFormatter.formatRatePerSqFt(property.pricePerSqFt),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Title
                  Text(
                    property.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Corridor & City
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 14, color: AppColors.gold600),
                      const SizedBox(width: 4),
                      Text(
                        '${property.locality}, ${property.city}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  const Divider(color: AppColors.borderLight, height: 1),
                  const SizedBox(height: 12),

                  // Quick Attributes Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildAttribute(Icons.bed_outlined, '${property.bhk} BHK'),
                      _buildAttribute(
                          Icons.square_foot_outlined, '${property.carpetArea} sq.ft'),
                      _buildAttribute(Icons.explore_outlined, property.facing.split(' ').first),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttribute(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: AppColors.navy800),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }
}
