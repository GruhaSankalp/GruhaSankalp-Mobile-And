import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/cadastral_trust_badge.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/sovereign_button.dart';
import '../providers/property_provider.dart';

class PropertyDetailScreen extends ConsumerStatefulWidget {
  final String propertyId;

  const PropertyDetailScreen({super.key, required this.propertyId});

  @override
  ConsumerState<PropertyDetailScreen> createState() =>
      _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends ConsumerState<PropertyDetailScreen> {
  int _activeImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final propertyAsync = ref.watch(propertyDetailProvider(widget.propertyId));

    return propertyAsync.when(
      data: (property) {
        final allImages = [property.coverImageUrl, ...property.galleryImages];

        return Scaffold(
          backgroundColor: AppColors.canvasLight,
          body: CustomScrollView(
            slivers: [
              // Media Header Sliver
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                backgroundColor: AppColors.navy950,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.share_outlined),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.favorite_border),
                    onPressed: () {},
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      PageView.builder(
                        itemCount: allImages.length,
                        onPageChanged: (idx) =>
                            setState(() => _activeImageIndex = idx),
                        itemBuilder: (context, index) {
                          return CachedNetworkImage(
                            imageUrl: allImages[index],
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Container(
                              color: AppColors.navy900,
                            ),
                          );
                        },
                      ),
                      // Carousel Indicator
                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${_activeImageIndex + 1}/${allImages.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Property Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Price and Trust Score Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                CurrencyFormatter.formatCompact(property.price),
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.navy950,
                                ),
                              ),
                              Text(
                                CurrencyFormatter.formatRatePerSqFt(
                                    property.pricePerSqFt),
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                          CadastralTrustBadge(
                            score: property.legalTrustScore,
                            showLabel: true,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Title & Corridor
                      Text(
                        property.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              size: 16, color: AppColors.gold600),
                          const SizedBox(width: 4),
                          Text(
                            '${property.locality}, ${property.city}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textMuted,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Specifications 4-column Grid
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.borderLight),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildSpecItem(
                                Icons.king_bed_outlined, '${property.bhk} BHK', 'Layout'),
                            _buildSpecItem(Icons.square_foot_outlined,
                                '${property.carpetArea} sq.ft', 'Carpet Area'),
                            _buildSpecItem(Icons.compass_calibration_outlined,
                                property.facing.split(' ').first, 'Facing'),
                            _buildSpecItem(Icons.schedule_outlined,
                                property.possessionStatus, 'Possession'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // CORE USP: Cadastral Legal Trust Report Card
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppColors.navy950,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.gold500, width: 1.2),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.navy950.withOpacity(0.1),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: const [
                                    Icon(Icons.gavel,
                                        color: AppColors.gold500, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      'Cadastral Legal Trust Audit',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppColors.emeraldBg,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    '100% CLEAR',
                                    style: TextStyle(
                                      color: AppColors.verifiedEmerald,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            _buildAuditRow(
                              Icons.history_edu,
                              '30-Year Encumbrance (EC)',
                              'Certified Zero Encumbrance & Mortgages',
                              isPass: true,
                            ),
                            const Divider(color: AppColors.navy800, height: 16),

                            _buildAuditRow(
                              Icons.verified,
                              'Telangana SRO Deed Number',
                              property.sroDeedNumber,
                              isPass: true,
                            ),
                            const Divider(color: AppColors.navy800, height: 16),

                            _buildAuditRow(
                              Icons.approval,
                              'RERA Registration ID',
                              property.reraNumber,
                              isPass: true,
                            ),
                            const Divider(color: AppColors.navy800, height: 16),

                            _buildAuditRow(
                              Icons.receipt_long,
                              'Municipal PTIN Assessment',
                              '${property.ptinNumber} (Taxes Paid)',
                              isPass: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Description
                      const Text(
                        'Property Description',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy950,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        property.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textDark,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Amenities Chips
                      const Text(
                        'Amenities & Infrastructure',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy950,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: property.amenities.map((amenity) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 7),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AppColors.borderLight),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.check_circle_outline,
                                    size: 14, color: AppColors.gold600),
                                const SizedBox(width: 6),
                                Text(
                                  amenity,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textDark,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 32),

                      // Direct Owner / Lister Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.borderLight),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: AppColors.navy950,
                              child: Text(
                                property.ownerName.isNotEmpty
                                    ? property.ownerName[0]
                                    : 'S',
                                style: const TextStyle(
                                  color: AppColors.gold500,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    property.ownerName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  const Text(
                                    'Verified Title Holder • Zero Brokerage',
                                    style: TextStyle(
                                      color: AppColors.verifiedEmerald,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Floating Bottom Booking Bar
          bottomNavigationBar: Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: const Border(top: BorderSide(color: AppColors.borderLight)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: SovereignButton(
                    text: 'Ask Gruha AI',
                    style: SovereignButtonStyle.outline,
                    icon: const Icon(Icons.smart_toy_outlined, size: 18),
                    onPressed: () {
                      context.push('/gruha-ai');
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: SovereignButton(
                    text: 'Schedule Visit & Pass',
                    style: SovereignButtonStyle.primaryNavy,
                    icon: const Icon(Icons.qr_code, size: 18, color: AppColors.gold500),
                    onPressed: () {
                      context.push('/book-visit/${property.id}');
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Scaffold(
        body: SovereignLoadingIndicator(message: 'Loading Cadastral Factsheet...'),
      ),
      error: (err, stack) => Scaffold(
        appBar: AppBar(title: const Text('Property Factsheet')),
        body: SovereignErrorView(
          onRetry: () =>
              ref.invalidate(propertyDetailProvider(widget.propertyId)),
        ),
      ),
    );
  }

  Widget _buildSpecItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 20, color: AppColors.navy800),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildAuditRow(
      IconData icon, String title, String subtitle, {required bool isPass}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.gold400),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        if (isPass)
          const Icon(Icons.check_circle, size: 16, color: AppColors.verifiedEmerald),
      ],
    );
  }
}
