import 'package:vakif_atlas_admin/core/l10n/ai_formatters.dart';
import 'package:vakif_atlas_admin/core/l10n/l10n.dart';
import 'package:vakif_atlas_admin/features/moderation/domain/entities/moderated_memory.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/status_chip.dart';

export 'package:vakif_atlas_admin/core/l10n/ai_formatters.dart'
    show formatAiScore, spamSignalsLabel;

extension ModerationReasonLabel on ModerationReason {
  String label(AppLocalizations l10n) => switch (this) {
    ModerationReason.offensive => l10n.reasonOffensive,
    ModerationReason.inappropriate => l10n.reasonInappropriate,
    ModerationReason.spam => l10n.reasonSpam,
    ModerationReason.personalInfo => l10n.reasonPersonalInfo,
    ModerationReason.unrelated => l10n.reasonUnrelated,
    ModerationReason.other => l10n.reasonOther,
  };
}

extension AiVerdictLabel on AiVerdict {
  String label(AppLocalizations l10n) => switch (this) {
    AiVerdict.approve => l10n.aiVerdictApprove,
    AiVerdict.review => l10n.aiVerdictReview,
    AiVerdict.reject => l10n.aiVerdictReject,
    AiVerdict.unscored => l10n.aiVerdictUnscored,
  };

  StatusTone get tone => switch (this) {
    AiVerdict.approve => StatusTone.success,
    AiVerdict.review => StatusTone.warning,
    AiVerdict.reject => StatusTone.danger,
    AiVerdict.unscored => StatusTone.neutral,
  };
}

extension AiCategoryLabel on AiCategory {
  String label(AppLocalizations l10n) => switch (this) {
    AiCategory.toxicity => l10n.aiCategoryToxicity,
    AiCategory.severeToxicity => l10n.aiCategorySevereToxicity,
    AiCategory.obscene => l10n.aiCategoryObscene,
    AiCategory.identityAttack => l10n.aiCategoryIdentityAttack,
    AiCategory.insult => l10n.aiCategoryInsult,
    AiCategory.threat => l10n.aiCategoryThreat,
    AiCategory.sexualExplicit => l10n.aiCategorySexualExplicit,
    AiCategory.nsfw => l10n.aiCategoryNsfw,
    AiCategory.unrelated => l10n.aiCategoryUnrelated,
    AiCategory.spam => l10n.aiCategorySpam,
  };
}

extension AiReviewCauseLabel on AiReviewCause {
  String label(AppLocalizations l10n) => switch (this) {
    AiReviewCause.score => l10n.aiReviewCauseScore,
    AiReviewCause.nsfw => l10n.aiReviewCauseNsfw,
    AiReviewCause.spam => l10n.aiReviewCauseSpam,
    AiReviewCause.unrelated => l10n.aiReviewCauseUnrelated,
    AiReviewCause.context => l10n.aiReviewCauseContext,
    AiReviewCause.language => l10n.aiReviewCauseLanguage,
    AiReviewCause.photos => l10n.aiReviewCausePhotos,
    AiReviewCause.unscored => l10n.aiReviewCauseUnscored,
  };
}

extension ModeratedMemoryChips on ModeratedMemory {
  /// Durum: yayında ama bildirimlerle gizlenmişse ayrıca belirtilir.
  StatusChip statusChip(AppLocalizations l10n) => switch (status) {
    MemoryStatus.pending => StatusChip(
      label: l10n.memoryStatusPending,
      tone: StatusTone.info,
    ),
    MemoryStatus.rejected => StatusChip(
      label: l10n.memoryStatusRejected,
      tone: StatusTone.neutral,
    ),
    MemoryStatus.approved when !publiclyVisible => StatusChip(
      label: l10n.memoryHiddenByReports,
      tone: StatusTone.danger,
    ),
    MemoryStatus.approved => StatusChip(
      label: l10n.memoryStatusApproved,
      tone: StatusTone.success,
    ),
  };

  String statusLabel(AppLocalizations l10n) => statusChip(l10n).label;

  /// YZ önerisi: karar · skor · (onay dışında) belirgin kategori.
  StatusChip? aiChip(AppLocalizations l10n, String locale) {
    final assessment = ai;
    if (assessment == null) {
      return null;
    }
    final verdict = assessment.verdict.label(l10n);
    final score = assessment.score;
    final category = assessment.topCategory;
    return StatusChip(
      label: switch ((score, category)) {
        (null, _) => verdict,
        (final s?, final c?) when assessment.verdict != AiVerdict.approve =>
          l10n.aiChipWithCategory(
            verdict,
            formatAiScore(s, locale),
            c.label(l10n),
          ),
        (final s?, _) => l10n.aiChip(verdict, formatAiScore(s, locale)),
      },
      tone: assessment.verdict.tone,
    );
  }

  /// Son kararı verenin görünen adı (YZ yerelleştirilir).
  String? deciderName(AppLocalizations l10n) =>
      moderation.decidedBy == DecisionActor.ai
      ? l10n.aiActorName
      : moderation.byName;

  StatusChip? reportsChip(AppLocalizations l10n) => openReports == 0
      ? null
      : StatusChip(
          label: l10n.memoryOpenReports(openReports),
          tone: StatusTone.warning,
        );

  String decisionLabel(
    ModerationDecision decision,
    AppLocalizations l10n,
  ) => switch ((decision, status)) {
    (ModerationDecision.reject, _) => l10n.decisionReject,
    (ModerationDecision.approve, MemoryStatus.pending) => l10n.decisionApprove,
    (ModerationDecision.approve, MemoryStatus.rejected) =>
      removedByAi ? l10n.decisionRestoreAi : l10n.decisionRestore,
    (ModerationDecision.approve, MemoryStatus.approved) => l10n.decisionKeep,
  };
}
