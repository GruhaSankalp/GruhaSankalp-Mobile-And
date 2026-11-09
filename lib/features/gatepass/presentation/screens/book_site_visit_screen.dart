import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/sovereign_button.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../properties/presentation/providers/property_provider.dart';
import '../providers/gatepass_provider.dart';

class BookSiteVisitScreen extends ConsumerStatefulWidget {
  final String propertyId;

  const BookSiteVisitScreen({super.key, required this.propertyId});

  @override
  ConsumerState<BookSiteVisitScreen> createState() =>
      _BookSiteVisitScreenState();
}

class _BookSiteVisitScreenState extends ConsumerState<BookSiteVisitScreen> {
  int _selectedDayOffset = 0;
  String _selectedSlot = 'Sunset Golden Hour (5:00 PM - 6:30 PM)';
  final _vehicleController = TextEditingController(text: 'TS 09 AB 1234');
  final _visitorNameController =
      TextEditingController(text: 'Sovereign Investor');

  final List<String> _slots = [
    'Morning (10:00 AM - 12:00 PM)',
    'Afternoon (2:00 PM - 4:00 PM)',
    'Sunset Golden Hour (5:00 PM - 6:30 PM)',
  ];

  @override
  void dispose() {
    _vehicleController.dispose();
    _visitorNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final propertyAsync = ref.watch(propertyDetailProvider(widget.propertyId));

    return Scaffold(
      backgroundColor: AppColors.canvasLight,
      appBar: AppBar(
        title: const Text('Schedule Site Inspection'),
        backgroundColor: AppColors.navy950,
      ),
      body: propertyAsync.when(
        data: (property) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Property Summary Bar
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(
                            property.coverImageUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                property.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${property.locality}, ${property.city}',
                                style: const TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Calendar Date Picker
                  const Text(
                    'Select Visit Date',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy950,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 72,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: 7,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final date =
                            DateTime.now().add(Duration(days: index));
                        final isSelected = _selectedDayOffset == index;
                        final dayName = [
                          'Sun',
                          'Mon',
                          'Tue',
                          'Wed',
                          'Thu',
                          'Fri',
                          'Sat'
                        ][date.weekday % 7];

                        return GestureDetector(
                          onTap: () =>
                              setState(() => _selectedDayOffset = index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 58,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.navy950
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.gold500
                                    : AppColors.borderLight,
                                width: isSelected ? 1.5 : 1.0,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  dayName,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isSelected
                                        ? AppColors.gold400
                                        : AppColors.textMuted,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${date.day}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: isSelected
                                        ? Colors.white
                                        : AppColors.textDark,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Time Slots
                  const Text(
                    'Available Time Slots',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy950,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ..._slots.map((slot) {
                    final isSelected = _selectedSlot == slot;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor:
                              isSelected ? AppColors.gold50 : Colors.white,
                          side: BorderSide(
                            color: isSelected
                                ? AppColors.gold500
                                : AppColors.borderLight,
                            width: isSelected ? 1.5 : 1.0,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                        ),
                        onPressed: () => setState(() => _selectedSlot = slot),
                        child: Row(
                          children: [
                            Icon(
                              isSelected
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_off,
                              color: isSelected
                                  ? AppColors.gold600
                                  : AppColors.textMuted,
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              slot,
                              style: TextStyle(
                                color: isSelected
                                    ? AppColors.navy950
                                    : AppColors.textDark,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),

                  const SizedBox(height: 20),

                  // Visitor Details
                  const Text(
                    'Vehicle Clearance',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy950,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _vehicleController,
                    decoration: const InputDecoration(
                      labelText: 'Vehicle Registration No (for Security Gate)',
                      hintText: 'e.g. TS 09 AB 1234',
                      prefixIcon: Icon(Icons.directions_car_outlined),
                    ),
                  ),

                  const SizedBox(height: 28),

                  SovereignButton(
                    text: 'Confirm & Issue Sovereign Gate Pass',
                    style: SovereignButtonStyle.primaryNavy,
                    onPressed: () {
                      final selectedDate = DateTime.now()
                          .add(Duration(days: _selectedDayOffset));
                      ref.read(activeGatePassesProvider.notifier).createPass(
                            propertyTitle: property.title,
                            propertyAddress:
                                '${property.locality}, ${property.city}',
                            visitorName: _visitorNameController.text.trim(),
                            visitorPhone: '+91 98765 43210',
                            vehicleNumber: _vehicleController.text.trim(),
                            date: selectedDate,
                            timeSlot: _selectedSlot,
                            hostName: property.ownerName,
                          );

                      context.showSnackBar(
                          'Sovereign Gatepass Generated Successfully');
                      context.go('/gatepass');
                    },
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const SovereignLoadingIndicator(),
        error: (_, __) => const Center(child: Text('Error')),
      ),
    );
  }
}

