import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vakif_atlas_admin/core/a11y/a11y_announcer.dart';
import 'package:vakif_atlas_admin/core/error/failures.dart';
import 'package:vakif_atlas_admin/core/l10n/failure_messages.dart';
import 'package:vakif_atlas_admin/core/l10n/formatters.dart';
import 'package:vakif_atlas_admin/core/l10n/l10n.dart';
import 'package:vakif_atlas_admin/core/theme/theme_context.dart';
import 'package:vakif_atlas_admin/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas_admin/features/moderation/domain/entities/moderated_memory.dart';
import 'package:vakif_atlas_admin/features/moderation/presentation/cubit/moderation_cubits.dart';
import 'package:vakif_atlas_admin/features/moderation/presentation/widgets/moderation_labels.dart';
import 'package:vakif_atlas_admin/shared/paging/record_cubit.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/admin_dialogs.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/app_snack_bar.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/detail_section.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/inline_message.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/status_chip.dart';
import 'package:vakif_atlas_admin/shared/widgets/organisms/metric_widgets.dart';
import 'package:vakif_atlas_admin/shared/widgets/organisms/photo_strip.dart';
import 'package:vakif_atlas_admin/shared/widgets/templates/loading_status_view.dart';
import 'package:vakif_atlas_admin/shared/widgets/templates/status_message_view.dart';
import 'package:vakif_atlas_admin/shared/widgets/templates/master_detail_layout.dart';
import 'package:vakif_atlas_admin/core/theme/responsive.dart';

/// Anının içeriği, bildirimleri ve moderasyon kararı.
class MemoryDetailPanel extends StatelessWidget {
  const MemoryDetailPanel({
    required this.onClose,
    required this.onChanged,
    super.key,
  });

  final VoidCallback onClose;
  final ValueChanged<ModeratedMemory> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocConsumer<MemoryDetailCubit, RecordState<ModeratedMemory>>(
      listenWhen: (previous, current) =>
          previous.savedCount != current.savedCount ||
          (current.actionFailure != null &&
              previous.actionFailure != current.actionFailure),
      listener: (context, state) async {
        final cubit = context.read<MemoryDetailCubit>();
        if (state.actionFailure is StaleDataFailure) {
          final reload = await showStaleDataDialog(context);
          cubit.clearActionFailure();
          if (reload) {
            await cubit.load();
          }
          return;
        }
        final memory = state.value;
        if (state.actionFailure != null || memory == null || !context.mounted) {
          return;
        }
        onChanged(memory);
        final message = l10n.decisionSaved(memory.statusLabel(l10n));
        AppSnackBar.show(context, message: message);
        unawaited(context.read<A11yAnnouncer>().announce(message));
      },
      builder: (context, state) {
        final memory = state.value;
        if (state.loading && memory == null) {
          return LoadingStatusView(label: l10n.commonLoading);
        }
        if (memory == null) {
          return StatusMessageView(
            tone: StatusMessageTone.error,
            title: l10n.commonLoadError,
            message:
                state.loadFailure?.toUserMessage(l10n) ?? l10n.errorUnexpected,
            actionLabel: l10n.commonRetry,
            onAction: () => unawaited(context.read<MemoryDetailCubit>().load()),
          );
        }
        final reports = memory.reportsChip(l10n);
        return ListView(
          padding: EdgeInsets.all(context.pageGutter),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Semantics(
                        header: true,
                        child: Text(
                          memory.monumentName,
                          style: context.textStyles.headlineMedium,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Wrap(
                        spacing: AppSpacing.xs,
                        runSpacing: AppSpacing.xs,
                        children: [memory.statusChip(l10n), ?reports],
                      ),
                    ],
                  ),
                ),
                DetailCloseButton(onPressed: onClose),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            DetailSection(
              title: l10n.memorySectionContent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  KeyValueList(
                    entries: [
                      (l10n.memoryAuthor, memory.authorName),
                      (
                        l10n.memoryMonument,
                        '${memory.monumentName}, ${memory.monumentCity}',
                      ),
                      (l10n.memoryDate, memory.memoryDate),
                      (
                        l10n.memorySharedAt,
                        context.formatDateTime(memory.createdAt),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SelectableText(
                    memory.text,
                    style: context.textStyles.bodyLarge,
                  ),
                  if (memory.photos.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.md),
                    PhotoStrip(
                      photos: [
                        for (final (index, photo) in memory.photos.indexed)
                          StripPhoto(
                            url: photo.url,
                            thumbnailUrl: photo.thumbnailUrl,
                            caption: photo.description,
                            semanticsLabel:
                                photo.description ??
                                l10n.memoryPhotoSemantics(
                                  index + 1,
                                  memory.photos.length,
                                ),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            DetailSection(
              title: l10n.memorySectionAi,
              child: _AiAssessmentView(memory: memory),
            ),
            const SizedBox(height: AppSpacing.md),
            DetailSection(
              title: l10n.memorySectionReports,
              child: _Reports(memory: memory),
            ),
            const SizedBox(height: AppSpacing.md),
            DetailSection(
              title: l10n.memorySectionModeration,
              child: _DecisionForm(
                key: ValueKey('${memory.status}-${memory.moderation.at}'),
                memory: memory,
                saving: state.saving,
                failure: state.actionFailure is StaleDataFailure
                    ? null
                    : state.actionFailure,
              ),
            ),
          ],
        );
      },
    );
  }
}

/// YZ önerisi, skorlar ve neden (ADR 58). Karar personelindir; YZ'nin
/// kaldırdığı anı geri yüklenebilir.
class _AiAssessmentView extends StatelessWidget {
  const _AiAssessmentView({required this.memory});

  final ModeratedMemory memory;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final ai = memory.ai;
    if (ai == null) {
      return Text(l10n.aiNotAssessed, style: context.textStyles.bodyMedium);
    }
    final locale = Localizations.localeOf(context).toString();
    String format(double score) => formatAiScore(score, locale);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KeyValueList(
          entries: [
            (l10n.aiVerdictLabel, ai.verdict.label(l10n)),
            if (ai.score case final score?) (l10n.aiScoreLabel, format(score)),
            if (ai.topCategory case final category?
                when ai.verdict != AiVerdict.approve)
              (l10n.aiTopCategoryLabel, category.label(l10n)),
            if (ai.reviewCause case final cause?)
              (l10n.aiReviewCauseLabel, cause.label(l10n)),
            if (ai.score != null)
              (
                l10n.aiLexiconLabel,
                ai.lexiconMatched ? l10n.aiLexiconYes : l10n.aiLexiconNo,
              ),
            if (ai.relevance case final relevance?)
              (l10n.aiRelevanceLabel, format(relevance)),
            if (ai.spam case final spam?) (l10n.aiSpamLabel, format(spam)),
            if (ai.spamSignals.isNotEmpty)
              (l10n.aiSpamSignalsLabel, spamSignalsLabel(ai.spamSignals, l10n)),
            if (ai.nsfw case final nsfw?) (l10n.aiNsfwLabel, format(nsfw)),
            if (ai.similarity case final similarity?)
              (l10n.aiSimilarityLabel, format(similarity)),
            if (ai.modelVersion case final model?) (l10n.aiModelLabel, model),
            if (ai.visionVersion case final model?)
              (l10n.aiVisionModelLabel, model),
            if (ai.contextVersion case final model?)
              (l10n.aiContextModelLabel, model),
            if (ai.scoredAt case final at?)
              (l10n.aiScoredAtLabel, context.formatDateTime(at)),
          ],
        ),
        if (ai.scores.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          ScoreBreakdown(
            title: l10n.aiCategoryScores,
            formatScore: format,
            emphasisFrom: 0.5,
            entries: [
              for (final category in AiCategory.textValues)
                if (ai.scores[category] case final score?)
                  (category.label(l10n), score),
            ],
          ),
        ],
        if (ai.images.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            l10n.aiPhotoScores,
            style: context.textStyles.labelMedium.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          KeyValueList(
            entries: [
              for (final (index, image) in ai.images.indexed)
                (
                  l10n.aiPhotoLabel(index + 1),
                  !image.readable
                      ? l10n.aiPhotoUnreadable
                      : l10n.aiPhotoScoresValue(
                          image.nsfw == null ? '–' : format(image.nsfw!),
                          image.similarity == null
                              ? l10n.aiPhotoNoReference
                              : format(image.similarity!),
                        ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _Reports extends StatelessWidget {
  const _Reports({required this.memory});

  final ModeratedMemory memory;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final reports = memory.reports ?? const [];
    if (reports.isEmpty) {
      return Text(l10n.memoryNoReports, style: context.textStyles.bodyMedium);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final report in reports)
          MergeSemantics(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          report.reason.label(l10n),
                          style: context.textStyles.labelLarge,
                        ),
                        if (report.note case final note?)
                          Text(note, style: context.textStyles.bodyMedium),
                        Text(
                          context.formatDateTime(report.createdAt),
                          style: context.textStyles.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  switch (report.resolution) {
                    ReportResolution.open => StatusChip(
                      label: l10n.memoryReportResolutionOpen,
                      tone: StatusTone.warning,
                    ),
                    ReportResolution.upheld => StatusChip(
                      label: l10n.memoryReportResolutionUpheld,
                      tone: StatusTone.danger,
                    ),
                    ReportResolution.dismissed => StatusChip(
                      label: l10n.memoryReportResolutionDismissed,
                      tone: StatusTone.success,
                    ),
                  },
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _DecisionForm extends StatefulWidget {
  const _DecisionForm({
    required this.memory,
    required this.saving,
    required this.failure,
    super.key,
  });

  final ModeratedMemory memory;
  final bool saving;
  final Failure? failure;

  @override
  State<_DecisionForm> createState() => _DecisionFormState();
}

class _DecisionFormState extends State<_DecisionForm> {
  final _note = TextEditingController();
  ModerationReason? _reason;
  bool _reasonMissing = false;

  @override
  void initState() {
    super.initState();
    // En sık bildirilen neden önerilir.
    final reasons = widget.memory.reportReasons.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    _reason = reasons.isEmpty ? null : reasons.first.key;
  }

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _decide(ModerationDecision decision) async {
    final l10n = context.l10n;
    final cubit = context.read<MemoryDetailCubit>();
    if (decision == ModerationDecision.reject) {
      if (_reason == null) {
        setState(() => _reasonMissing = true);
        return;
      }
      final confirmed = await showConfirmDialog(
        context,
        title: l10n.decisionRejectConfirmTitle,
        message: l10n.decisionRejectConfirmBody,
        confirmLabel: l10n.decisionReject,
        destructive: true,
      );
      if (!confirmed) {
        return;
      }
    }
    await cubit.decide(
      decision,
      reason: decision == ModerationDecision.reject ? _reason : null,
      note: _note.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final memory = widget.memory;
    final moderation = memory.moderation;
    final canReject = memory.allowedDecisions.contains(
      ModerationDecision.reject,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (moderation.at != null) ...[
          Text(
            l10n.memoryLastDecision(
              memory.deciderName(l10n) ?? '—',
              context.formatDateTime(moderation.at!),
            ),
            style: context.textStyles.bodySmall,
          ),
          if (moderation.note case final note?)
            Text(note, style: context.textStyles.bodyMedium),
          const SizedBox(height: AppSpacing.sm),
        ],
        if (widget.failure != null) ...[
          InlineMessage(
            type: InlineMessageType.error,
            message: widget.failure!.toUserMessage(l10n),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        if (canReject) ...[
          DropdownMenu<ModerationReason>(
            label: Text(l10n.decisionReason),
            initialSelection: _reason,
            expandedInsets: EdgeInsets.zero,
            errorText: _reasonMissing ? l10n.decisionReasonRequired : null,
            onSelected: (reason) => setState(() {
              _reason = reason;
              _reasonMissing = false;
            }),
            dropdownMenuEntries: [
              for (final reason in ModerationReason.values)
                DropdownMenuEntry(value: reason, label: reason.label(l10n)),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        TextField(
          controller: _note,
          enabled: !widget.saving,
          minLines: 2,
          maxLines: 4,
          maxLength: 1000,
          decoration: InputDecoration(labelText: l10n.decisionNote),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          alignment: WrapAlignment.end,
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            for (final decision in memory.allowedDecisions)
              decision == ModerationDecision.reject
                  ? OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: context.colors.error,
                        side: BorderSide(color: context.colors.error),
                      ),
                      onPressed: widget.saving
                          ? null
                          : () => unawaited(_decide(decision)),
                      child: Text(memory.decisionLabel(decision, l10n)),
                    )
                  : FilledButton(
                      onPressed: widget.saving
                          ? null
                          : () => unawaited(_decide(decision)),
                      child: Text(memory.decisionLabel(decision, l10n)),
                    ),
          ],
        ),
      ],
    );
  }
}
