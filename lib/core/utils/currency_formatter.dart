import 'package:intl/intl.dart';

abstract class CurrencyFormatter {
  static final NumberFormat _inrFormat = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  /// Format as Indian Rupees (e.g. ₹1,85,00,000)
  static String formatFull(num amount) {
    return _inrFormat.format(amount);
  }

  /// Compact property pricing (e.g. ₹1.85 Cr, ₹85 L)
  static String formatCompact(num amount) {
    if (amount >= 10000000) {
      final double cr = amount / 10000000;
      return '₹${cr.toStringAsFixed(cr.truncateToDouble() == cr ? 0 : 2)} Cr';
    } else if (amount >= 100000) {
      final double l = amount / 100000;
      return '₹${l.toStringAsFixed(l.truncateToDouble() == l ? 0 : 2)} L';
    } else if (amount >= 1000) {
      final double k = amount / 1000;
      return '₹${k.toStringAsFixed(k.truncateToDouble() == k ? 0 : 1)} K';
    }
    return '₹$amount';
  }

  /// Format rate per square foot (e.g. ₹8,500/sq.ft)
  static String formatRatePerSqFt(num rate) {
    return '${_inrFormat.format(rate)}/sq.ft';
  }
}

