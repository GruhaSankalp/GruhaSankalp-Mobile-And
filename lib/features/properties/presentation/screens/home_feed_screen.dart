import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../domain/repositories/property_repository.dart';
import '../providers/property_provider.dart';
import '../widgets/property_card.dart';
import 'filter_modal.dart';

class HomeFeedScreen extends ConsumerWidget {
  const HomeFeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final propertiesAsync = ref.watch(propertiesListProvider);
    final selectedCorridor = ref.watch(selectedCorridorProvider);

    final corridors = [
      'All',
      'Kokapet',
      'Financial District',
      'Tellapur',
      'Gachibowli',
      'Jubilee Hills',
    ];

    return Scaffold(
      backgroundColor: AppColors.canvasLight,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.gold500,
          backgroundColor: AppColors.navy950,
          onRefresh: () async {
            ref.invalidate(propertiesListProvider);
          },
          child: CustomScrollView(
            slivers: [
              // Sticky Sovereign Top App Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.navy950,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.location_on,
                                size: 18, color: AppColors.gold500),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Hyderabad Corridors',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textMuted,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Kokapet Golden Mile',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.navy950,
                                    ),
                                  ),
                                  Icon(Icons.keyboard_arrow_down, size: 18),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.compare_arrows_outlined,
                                color: AppColors.navy950),
                            tooltip: 'Comparison Matrix',
                            onPressed: () => context.push('/compare'),
                          ),
                          IconButton(
                            icon: const Icon(Icons.notifications_none,
                                color: AppColors.navy950),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Search & Filter Hero Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (_) => const FilterModal(),
                            );
                          },
                          child: Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.borderLight),
                            ),
                            child: Row(
                              children: const [
                                Icon(Icons.search,
                                    color: AppColors.textMuted, size: 20),
                                SizedBox(width: 10),
                                Text(
                                  'Search by corridor, project, or RERA ID...',
                                  style: TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => const FilterModal(),
                          );
                        },
                        child: Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                            color: AppColors.navy950,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.tune,
                              color: AppColors.gold500, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Gruha AI Sovereign Prompt Launcher Banner
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: GestureDetector(
                    onTap: () => context.push('/gruha-ai'),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.navy950, AppColors.navy900],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        border:
                            Border.all(color: AppColors.gold500.withOpacity(0.5)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.navy800,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.smart_toy,
                                color: AppColors.gold500, size: 22),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Ask Gruha AI Sovereign Advisor',
                                  style: TextStyle(
                                    color: AppColors.gold400,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Find 95+ score flats under ₹2 Cr with clean 30-yr EC',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios,
                              size: 14, color: AppColors.gold500),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Quick Corridor Horizontal Scroll Chips
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SizedBox(
                    height: 38,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: corridors.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final corridor = corridors[index];
                        final isSelected = selectedCorridor == corridor;

                        return GestureDetector(
                          onTap: () {
                            ref.read(selectedCorridorProvider.notifier).state =
                                corridor;
                            ref.read(propertyFilterProvider.notifier).state =
                                PropertyFilterCriteria(
                              locality: corridor == 'All' ? null : corridor,
                            );
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.navy950
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.gold500
                                    : AppColors.borderLight,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                corridor,
                                style: TextStyle(
                                  color: isSelected
                                      ? AppColors.gold500
                                      : AppColors.textDark,
                                  fontSize: 12,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              // Section Header: Sovereign Verified Feed
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Sovereign Verified Listings',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy950,
                        ),
                      ),
                      Text(
                        'Audited Titles',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.verifiedEmerald,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Property Feed List
              propertiesAsync.when(
                data: (properties) {
                  if (properties.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Center(
                          child: Column(
                            children: const [
                              Icon(Icons.search_off,
                                  size: 48, color: AppColors.textMuted),
                              SizedBox(height: 12),
                              Text(
                                'No verified properties match your filters.',
                                style: TextStyle(
                                  color: AppColors.textDark,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Try clearing your corridor or budget filters.',
                                style: TextStyle(
                                    color: AppColors.textMuted, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final property = properties[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: PropertyCard(
                              property: property,
                              onTap: () {
                                context.push('/properties/${property.id}');
                              },
                            ),
                          );
                        },
                        childCount: properties.length,
                      ),
                    ),
                  );
                },
                loading: () => const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: SovereignLoadingIndicator(
                      message: 'Verifying Cadastral Title Feeds...',
                    ),
                  ),
                ),
                error: (err, stack) => SliverToBoxAdapter(
                  child: SovereignErrorView(
                    onRetry: () => ref.invalidate(propertiesListProvider),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
