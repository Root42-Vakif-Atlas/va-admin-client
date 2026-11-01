import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

/// Tarih ve sayıların arayüz dilinde biçimlenmesi. Zamanlar cihazın yerel
/// saatine çevrilir (sunucu UTC döner).
extension AppFormatters on BuildContext {
  String get _locale => Localizations.localeOf(this).toLanguageTag();

  String formatDate(DateTime value) =>
      DateFormat.yMMMd(_locale).format(value.toLocal());

  String formatDateTime(DateTime value) =>
      DateFormat.yMMMd(_locale).add_Hm().format(value.toLocal());

  String formatNumber(num value) =>
      NumberFormat.decimalPattern(_locale).format(value);

  /// Tek ondalık basamak (ör. ortalama puan "4,6").
  String formatDecimal(num value) => NumberFormat('0.0', _locale).format(value);
}
