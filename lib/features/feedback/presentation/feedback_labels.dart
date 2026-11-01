import 'package:flutter/material.dart';
import 'package:vakif_atlas_admin/core/l10n/l10n.dart';
import 'package:vakif_atlas_admin/core/theme/theme_context.dart';
import 'package:vakif_atlas_admin/core/theme/tokens/app_typography.dart';
import 'package:vakif_atlas_admin/features/feedback/domain/feedback_entry.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/status_chip.dart';

extension FeedbackStatusLabel on FeedbackStatus {
  String label(AppLocalizations l10n) => switch (this) {
    FeedbackStatus.newEntry => l10n.feedbackStatusNew,
    FeedbackStatus.inProgress => l10n.feedbackStatusInProgress,
    FeedbackStatus.done => l10n.feedbackStatusDone,
    FeedbackStatus.dismissed => l10n.feedbackStatusDismissed,
  };

  StatusChip chip(AppLocalizations l10n) => StatusChip(
    label: label(l10n),
    tone: switch (this) {
      FeedbackStatus.newEntry => StatusTone.info,
      FeedbackStatus.inProgress => StatusTone.accent,
      FeedbackStatus.done => StatusTone.success,
      FeedbackStatus.dismissed => StatusTone.neutral,
    },
  );
}

extension FeedbackCategoryLabel on FeedbackCategory {
  String label(AppLocalizations l10n) => switch (this) {
    FeedbackCategory.suggestion => l10n.feedbackCategorySuggestion,
    FeedbackCategory.bug => l10n.feedbackCategoryBug,
    FeedbackCategory.accessibility => l10n.feedbackCategoryAccessibility,
    FeedbackCategory.content => l10n.feedbackCategoryContent,
    FeedbackCategory.other => l10n.feedbackCategoryOther,
  };
}

/// Puan: "4/5" (metin; ekran okuyucu "4 / 5 yıldız" okur).
class RatingStars extends StatelessWidget {
  const RatingStars({required this.rating, super.key});

  final int rating;

  @override
  Widget build(BuildContext context) => Text(
    '$rating/5',
    semanticsLabel: context.l10n.feedbackRatingValue(rating),
    style: context.textStyles.labelMedium.copyWith(
      color: context.colors.onSurfaceVariant,
      fontFeatures: AppTypography.tabularFigures,
    ),
  );
}
