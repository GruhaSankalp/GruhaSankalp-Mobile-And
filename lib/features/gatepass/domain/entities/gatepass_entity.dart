import 'package:equatable/equatable.dart';

class GatePassEntity extends Equatable {
  final String id;
  final String passCode; // e.g. GS-7842
  final String propertyTitle;
  final String propertyAddress;
  final String visitorName;
  final String visitorPhone;
  final String vehicleNumber;
  final DateTime scheduledDate;
  final String timeSlot;
  final String status; // Active, CheckedIn, Expired
  final String hostName;

  const GatePassEntity({
    required this.id,
    required this.passCode,
    required this.propertyTitle,
    required this.propertyAddress,
    required this.visitorName,
    required this.visitorPhone,
    required this.vehicleNumber,
    required this.scheduledDate,
    required this.timeSlot,
    required this.status,
    required this.hostName,
  });

  @override
  List<Object?> get props => [id, passCode, visitorName, scheduledDate, status];
}

