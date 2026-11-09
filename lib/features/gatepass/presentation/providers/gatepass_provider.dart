import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/gatepass_entity.dart';

final activeGatePassesProvider =
    StateNotifierProvider<GatePassNotifier, List<GatePassEntity>>((ref) {
  return GatePassNotifier();
});

class GatePassNotifier extends StateNotifier<List<GatePassEntity>> {
  GatePassNotifier()
      : super([
          GatePassEntity(
            id: 'gp-1001',
            passCode: 'GS-7842',
            propertyTitle: '3 BHK Sky Villa at Kokapet Golden Mile',
            propertyAddress: 'Tower 4, Unit 1402, Kokapet Neo-City',
            visitorName: 'Sovereign Investor',
            visitorPhone: '+91 98765 43210',
            vehicleNumber: 'TS 09 AB 1234',
            scheduledDate: DateTime.now().add(const Duration(hours: 3)),
            timeSlot: 'Sunset Golden Hour (5:00 PM - 6:30 PM)',
            status: 'Active',
            hostName: 'Suresh Reddy (Owner)',
          ),
        ]);

  void createPass({
    required String propertyTitle,
    required String propertyAddress,
    required String visitorName,
    required String visitorPhone,
    required String vehicleNumber,
    required DateTime date,
    required String timeSlot,
    required String hostName,
  }) {
    final randomDigits = (1000 + DateTime.now().millisecond % 9000);
    final newPass = GatePassEntity(
      id: 'gp-${DateTime.now().millisecondsSinceEpoch}',
      passCode: 'GS-$randomDigits',
      propertyTitle: propertyTitle,
      propertyAddress: propertyAddress,
      visitorName: visitorName,
      visitorPhone: visitorPhone,
      vehicleNumber: vehicleNumber,
      scheduledDate: date,
      timeSlot: timeSlot,
      status: 'Active',
      hostName: hostName,
    );
    state = [newPass, ...state];
  }
}

