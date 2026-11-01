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
import 'package:vakif_atlas_admin/features/feedback/domain/feedback_entry.dart';
import 'package:vakif_atlas_admin/features/feedback/presentation/feedback_cubits.dart';
import 'package:vakif_atlas_admin/features/feedback/presentation/feedback_labels.dart';
import 'package:vakif_atlas_admin/shared/paging/record_cubit.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/admin_dialogs.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/app_snack_bar.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/detail_section.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/inline_message.dart';
import 'package:vakif_atlas_admin/shared/widgets/templates/loading_status_view.dart';
import 'package:vakif_atlas_admin/shared/widgets/templates/status_message_view.dart';

class FeedbackDetailPanel extends StatelessWidget {
  const FeedbackDetailPanel({
    required this.onClose,
    required this.onChanged,
    super.key,
  });

  final VoidCallback onClose;
  final ValueChanged<FeedbackEntry> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocConsumer<FeedbackDetailCubit, RecordState<FeedbackEntry>>(
      listenWhen: (previous, current) =>
          previous.savedCount != current.savedCount ||
          (current.actionFailure != null &&
              previous.actionFailure != current.actionFailure),
      listener: (context, state) async {
        final cubit = context.read<FeedbackDetailCubit>();
        if (state.actionFailure is StaleDataFailure) {
          final reload = await showStaleDataDialog(context);
          cubit.clearActionFailure();
          if (reload) {
            await cubit.load();
          }
          return;
        }
        final entry = state.value;
        if (state.actionFailure != null || entry == null || !context.mounted) {
          return;
        }
        onChanged(entry);
        final message = l10n.feedbackTriaged(entry.status.label(l10n));
        AppSnackBar.show(context, message: message);
        unawaited(context.read<A11yAnnouncer>().announce(message));
      },
      builder: (context, state) {
        final entry = state.value;
        if (state.loading && entry == null) {
          return LoadingStatusView(label: l10n.commonLoading);
        }
        if (entry == null) {
          return StatusMessageView(
            tone: StatusMessageTone.error,
            title: l10n.commonLoadError,
            message:
                state.loadFailure?.toUserMessage(l10n) ?? l10n.errorUnexpected,
            actionLabel: l10n.commonRetry,
            onAction: () =>
                unawaited(context.read<FeedbackDetailCubit>().load()),
          );
        }
        return ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
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
                          entry.category.label(l10n),
                          style: context.textStyles.headlineMedium,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Wrap(
                        spacing: AppSpacing.sm,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          entry.status.chip(l10n),
                          if (entry.rating case final rating?)
                            RatingStars(rating: rating),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: l10n.commonClose,
                  onPressed: onClose,
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            DetailSection(
              title: l10n.feedbackSectionMessage,
              child: SelectableText(
                entry.message.isEmpty
                    ? l10n.feedbackEmptyMessage
                    : entry.message,
                style: context.textStyles.bodyLarge,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            DetailSection(
              title: l10n.feedbackSectionContext,
              child: KeyValueList(
                entries: [
                  (
                    l10n.feedbackReceivedAt,
                    context.formatDateTime(entry.createdAt),
                  ),
                  (
                    l10n.feedbackSender,
                    entry.fromAccount
                        ? l10n.feedbackFromAccount
                        : l10n.feedbackFromGuest,
                  ),
                  (
                    l10n.feedbackAppVersion,
                    entry.appVersion ?? l10n.commonNone,
                  ),
                  (l10n.feedbackPlatform, entry.platform ?? l10n.commonNone),
                  (l10n.feedbackLanguage, entry.language.toUpperCase()),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            DetailSection(
              title: l10n.feedbackSectionTriage,
              child: _TriageForm(
                key: ValueKey(entry.handledAt),
                entry: entry,
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

class _TriageForm extends StatefulWidget {
  const _TriageForm({
    required this.entry,
    required this.saving,
    required this.failure,
    super.key,
  });

  final FeedbackEntry entry;
  final bool saving;
  final Failure? failure;

  @override
  State<_TriageForm> createState() => _TriageFormState();
}

class _TriageFormState extends State<_TriageForm> {
  late FeedbackStatus _status = widget.entry.status;
  late final _note = TextEditingController(text: widget.entry.staffNote ?? '');

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final entry = widget.entry;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (entry.handledAt != null) ...[
          Text(
            l10n.feedbackHandledBy(
              entry.handledByName ?? '—',
              context.formatDateTime(entry.handledAt!),
            ),
            style: context.textStyles.bodySmall,
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        if (widget.failure != null) ...[
          InlineMessage(
            type: InlineMessageType.error,
            message: widget.failure!.toUserMessage(l10n),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        SegmentedButton<FeedbackStatus>(
          segments: [
            for (final status in FeedbackStatus.values)
              ButtonSegment(value: status, label: Text(status.label(l10n))),
          ],
          selected: {_status},
          onSelectionChanged: widget.saving
              ? null
              : (selection) => setState(() => _status = selection.first),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: _note,
          enabled: !widget.saving,
          minLines: 2,
          maxLines: 5,
          maxLength: 1000,
          decoration: InputDecoration(labelText: l10n.feedbackStaffNote),
        ),
        const SizedBox(height: AppSpacing.sm),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: FilledButton(
            onPressed: widget.saving
                ? null
                : () => unawaited(
                    context.read<FeedbackDetailCubit>().triage(
                      _status,
                      note: _note.text,
                    ),
                  ),
            child: Text(l10n.feedbackSaveTriage),
          ),
        ),
      ],
    );
  }
}
