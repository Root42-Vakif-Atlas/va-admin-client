import 'package:vakif_atlas_admin/core/l10n/ai_formatters.dart';
import 'package:vakif_atlas_admin/core/l10n/l10n.dart';
import 'package:vakif_atlas_admin/features/civil_protection/domain/entities/damage_report.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/status_chip.dart';

extension ReportStatusLabel on ReportStatus {
  String label(AppLocalizations l10n) => switch (this) {
    ReportStatus.received => l10n.reportStatusReceived,
    ReportStatus.inReview => l10n.reportStatusInReview,
    ReportStatus.forwarded => l10n.reportStatusForwarded,
    ReportStatus.resolved => l10n.reportStatusResolved,
    ReportStatus.closed => l10n.reportStatusClosed,
  };

  StatusTone get tone => switch (this) {
    ReportStatus.received => StatusTone.info,
    ReportStatus.inReview => StatusTone.accent,
    ReportStatus.forwarded => StatusTone.neutral,
    ReportStatus.resolved => StatusTone.success,
    ReportStatus.closed => StatusTone.neutral,
  };

  StatusChip chip(AppLocalizations l10n) =>
      StatusChip(label: label(l10n), tone: tone);
}

extension ReportUrgencyLabel on ReportUrgency {
  String label(AppLocalizations l10n) => switch (this) {
    ReportUrgency.critical => l10n.urgencyCritical,
    ReportUrgency.high => l10n.urgencyHigh,
    ReportUrgency.medium => l10n.urgencyMedium,
    ReportUrgency.low => l10n.urgencyLow,
  };

  StatusChip chip(AppLocalizations l10n) => StatusChip(
    label: label(l10n),
    semanticsLabel: l10n.urgencyLabel(label(l10n)),
    tone: switch (this) {
      ReportUrgency.critical => StatusTone.danger,
      ReportUrgency.high => StatusTone.warning,
      ReportUrgency.medium => StatusTone.neutral,
      ReportUrgency.low => StatusTone.neutral,
    },
  );
}

extension ReportCategoryLabel on ReportCategory {
  String label(AppLocalizations l10n) => switch (this) {
    ReportCategory.structuralDamage => l10n.categoryStructuralDamage,
    ReportCategory.collapseRisk => l10n.categoryCollapseRisk,
    ReportCategory.vandalism => l10n.categoryVandalism,
    ReportCategory.theft => l10n.categoryTheft,
    ReportCategory.fireOrWater => l10n.categoryFireOrWater,
    ReportCategory.unauthorizedWork => l10n.categoryUnauthorizedWork,
    ReportCategory.other => l10n.categoryOther,
  };
}

extension DamageReportLabels on DamageReport {
  String verificationLabel(AppLocalizations l10n) => switch (verification) {
    LocationVerification.notProvided => l10n.verificationNotProvided,
    LocationVerification.onSite => l10n.verificationOnSite(distanceMeters ?? 0),
    LocationVerification.distant => l10n.verificationDistant(
      distanceMeters ?? 0,
    ),
  };
}

extension EvidenceLevelLabel on EvidenceLevel {
  String label(AppLocalizations l10n) => switch (this) {
    EvidenceLevel.strong => l10n.evidenceLevelStrong,
    EvidenceLevel.unverified => l10n.evidenceLevelUnverified,
    EvidenceLevel.suspicious => l10n.evidenceLevelSuspicious,
    EvidenceLevel.pending => l10n.evidenceLevelPending,
  };

  /// Etiketin moderatöre anlamı.
  String help(AppLocalizations l10n) => switch (this) {
    EvidenceLevel.strong => l10n.evidenceHelpStrong,
    EvidenceLevel.unverified => l10n.evidenceHelpUnverified,
    EvidenceLevel.suspicious => l10n.evidenceHelpSuspicious,
    EvidenceLevel.pending => l10n.evidenceHelpPending,
  };

  StatusTone get tone => switch (this) {
    EvidenceLevel.strong => StatusTone.success,
    EvidenceLevel.unverified => StatusTone.neutral,
    EvidenceLevel.suspicious => StatusTone.danger,
    EvidenceLevel.pending => StatusTone.info,
  };

  /// "YZ: Şüpheli" — anı moderasyonundaki YZ çipiyle aynı dil.
  StatusChip chip(AppLocalizations l10n) => StatusChip(
    label: l10n.evidenceChip(label(l10n)),
    semanticsLabel: l10n.evidenceChipSemantics(label(l10n)),
    tone: tone,
  );
}

extension EvidenceEffectLabel on EvidenceEffect {
  String label(AppLocalizations l10n) => switch (this) {
    EvidenceEffect.supports => l10n.evidenceSupports,
    EvidenceEffect.undermines => l10n.evidenceUndermines,
    EvidenceEffect.neutral => l10n.evidenceNeutral,
  };
}

extension EvidenceReasonLabel on EvidenceReason {
  /// Gerekçe cümlesi; değer koda göre skor (0–1), mesafe (m) veya sayıdır.
  String label(AppLocalizations l10n, String locale) {
    final score = value == null ? '–' : formatAiScore(value!, locale);
    final count = value?.round() ?? 0;
    String signals() => spamSignalsLabel((detail ?? '').split(','), l10n);
    return switch (code) {
      EvidenceReasonCode.locationOnSite => l10n.evidenceLocationOnSite(count),
      EvidenceReasonCode.locationDistant => l10n.evidenceLocationDistant(count),
      EvidenceReasonCode.locationNotProvided =>
        l10n.evidenceLocationNotProvided,
      EvidenceReasonCode.corroborated => l10n.evidenceCorroborated(count),
      EvidenceReasonCode.photoMatchesMonument => l10n.evidencePhotoMatches(
        score,
      ),
      EvidenceReasonCode.photoLowSimilarity => l10n.evidencePhotoLowSimilarity(
        score,
      ),
      EvidenceReasonCode.photoNone => l10n.evidencePhotoNone,
      EvidenceReasonCode.photoUnreadable => l10n.evidencePhotoUnreadable(count),
      EvidenceReasonCode.photoCatalogCopy => l10n.evidencePhotoCatalogCopy(
        score,
      ),
      EvidenceReasonCode.photoNsfw => l10n.evidencePhotoNsfw(score),
      EvidenceReasonCode.textDescribesDamage =>
        l10n.evidenceTextDescribesDamage(score),
      EvidenceReasonCode.textWeakDamage => l10n.evidenceTextWeakDamage(score),
      EvidenceReasonCode.textNotDamage => l10n.evidenceTextNotDamage(score),
      EvidenceReasonCode.textAbusive => l10n.evidenceTextAbusive(score),
      EvidenceReasonCode.textSpam => l10n.evidenceTextSpam(signals()),
      EvidenceReasonCode.textContact => l10n.evidenceTextContact(signals()),
      EvidenceReasonCode.categorySuggested => l10n.evidenceCategorySuggested(
        ReportCategory.fromWire(detail ?? '').label(l10n),
      ),
      EvidenceReasonCode.urgencyUnsupported => l10n.evidenceUrgencyUnsupported(
        ReportUrgency.fromWire(detail ?? '').label(l10n),
      ),
      EvidenceReasonCode.unknown => l10n.evidenceUnknown(rawCode),
    };
  }
}
