import 'package:intl/intl.dart';
import 'package:vakif_atlas_admin/core/l10n/l10n.dart';

/// YZ skoru iki ondalıkla, yerel ayırıcıyla ("0,62"). Anı moderasyonu ve
/// Sivil Koruma kanıt etiketi ortak kullanır.
String formatAiScore(double score, String locale) =>
    NumberFormat('0.00', locale).format(score);

/// Moderasyon servisinin spam kural türleri (`contact` · `promotion` ·
/// `scam`); bilinmeyen tür olduğu gibi gösterilir.
String spamSignalLabel(String signal, AppLocalizations l10n) =>
    switch (signal) {
      'contact' => l10n.aiSpamSignalContact,
      'promotion' => l10n.aiSpamSignalPromotion,
      'scam' => l10n.aiSpamSignalScam,
      _ => signal,
    };

/// Virgülle ayrılmış (`contact,promotion`) veya liste halindeki sinyaller.
String spamSignalsLabel(Iterable<String> signals, AppLocalizations l10n) =>
    signals
        .map((signal) => signal.trim())
        .where((signal) => signal.isNotEmpty)
        .map((signal) => spamSignalLabel(signal, l10n))
        .join(', ');
