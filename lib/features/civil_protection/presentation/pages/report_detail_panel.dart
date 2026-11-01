import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vakif_atlas_admin/core/a11y/a11y_announcer.dart';
import 'package:vakif_atlas_admin/core/error/failures.dart';
import 'package:vakif_atlas_admin/core/l10n/failure_messages.dart';
import 'package:vakif_atlas_admin/core/l10n/formatters.dart';
import 'package:vakif_atlas_admin/core/l10n/l10n.dart';
import 'package:vakif_atlas_admin/core/theme/theme_context.dart';
import 'package:vakif_atlas_admin/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas_admin/features/civil_protection/domain/entities/damage_report.dart';
import 'package:vakif_atlas_admin/features/civil_protection/presentation/cubit/reports_cubits.dart';
import 'package:vakif_atlas_admin/features/civil_protection/presentation/widgets/report_labels.dart';
import 'package:vakif_atlas_admin/shared/paging/record_cubit.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/admin_dialogs.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/app_snack_bar.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/detail_section.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/inline_message.dart';
import 'package:vakif_atlas_admin/shared/widgets/organisms/photo_strip.dart';
import 'package:vakif_atlas_admin/shared/widgets/templates/loading_status_view.dart';
import 'package:vakif_atlas_admin/shared/widgets/templates/status_message_view.dart';

/// Seçili raporun ayrıntısı ve durum güncelleme formu. Kaydedilen rapor
/// kuyrukta yerinde güncellenir ([onChanged]).
class ReportDetailPanel extends StatelessWidget {
  const ReportDetailPanel({
    required this.onClose,
    required this.onChanged,
    super.key,
  });

  final VoidCallback onClose;
  final ValueChanged<DamageReport> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocConsumer<ReportDetailCubit, RecordState<DamageReport>>(
      listenWhen: (previous, current) =>
          previous.savedCount != current.savedCount ||
          (current.actionFailure != null &&
              previous.actionFailure != current.actionFailure),
      listener: (context, state) async {
        final cubit = context.read<ReportDetailCubit>();
        final failure = state.actionFailure;
        if (failure is StaleDataFailure) {
          final reload = await showStaleDataDialog(context);
          cubit.clearActionFailure();
          if (reload) {
            await cubit.load();
          }
          return;
        }
        if (failure != null || state.value == null || !context.mounted) {
          return;
        }
        final report = state.value!;
        onChanged(report);
        final message = l10n.reportUpdated(report.status.label(l10n));
        AppSnackBar.show(context, message: message);
        unawaited(context.read<A11yAnnouncer>().announce(message));
      },
      builder: (context, state) {
        final report = state.value;
        if (state.loading && report == null) {
          return LoadingStatusView(label: l10n.commonLoading);
        }
        if (report == null) {
          return StatusMessageView(
            tone: StatusMessageTone.error,
            title: l10n.commonLoadError,
            message:
                state.loadFailure?.toUserMessage(l10n) ?? l10n.errorUnexpected,
            actionLabel: l10n.commonRetry,
            onAction: () => unawaited(context.read<ReportDetailCubit>().load()),
          );
        }
        return _ReportDetail(report: report, state: state, onClose: onClose);
      },
    );
  }
}

class _ReportDetail extends StatelessWidget {
  const _ReportDetail({
    required this.report,
    required this.state,
    required this.onClose,
  });

  final DamageReport report;
  final RecordState<DamageReport> state;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final location = report.location;
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
                    child: SelectableText(
                      report.referenceCode,
                      style: context.textStyles.headlineMedium,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    report.monument.name,
                    style: context.textStyles.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Wrap(
                    spacing: AppSpacing.xs,
                    runSpacing: AppSpacing.xs,
                    children: [
                      report.status.chip(l10n),
                      report.urgency.chip(l10n),
                      report.evidenceLevel.chip(l10n),
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
        if (report.anonymized) ...[
          const SizedBox(height: AppSpacing.md),
          InlineMessage(message: l10n.reportAnonymized),
        ],
        const SizedBox(height: AppSpacing.lg),
        DetailSection(
          title: l10n.reportSectionSummary,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KeyValueList(
                entries: [
                  (l10n.reportReference, report.referenceCode),
                  (l10n.reportMonument, report.monument.name),
                  (
                    l10n.reportPlace,
                    '${report.monument.district}, ${report.monument.city}',
                  ),
                  (l10n.reportCategory, report.category.label(l10n)),
                  (
                    l10n.reportCreatedAt,
                    context.formatDateTime(report.createdAt),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              SelectableText(
                report.description,
                style: context.textStyles.bodyLarge,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        DetailSection(
          title: l10n.reportSectionEvidence,
          child: _EvidenceView(report: report),
        ),
        const SizedBox(height: AppSpacing.md),
        DetailSection(
          title: l10n.reportSectionPhotos,
          child: report.photos.isEmpty
              ? Text(l10n.reportNoPhotos, style: context.textStyles.bodyMedium)
              : PhotoStrip(
                  photos: [
                    for (final (index, photo) in report.photos.indexed)
                      StripPhoto(
                        url: photo.url,
                        thumbnailUrl: photo.thumbnailUrl,
                        caption: photo.description,
                        semanticsLabel:
                            photo.description ??
                            l10n.reportPhotoSemantics(
                              index + 1,
                              report.photos.length,
                            ),
                      ),
                  ],
                ),
        ),
        const SizedBox(height: AppSpacing.md),
        DetailSection(
          title: l10n.reportSectionLocation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                report.verificationLabel(l10n),
                style: context.textStyles.bodyLarge,
              ),
              if (location != null) ...[
                const SizedBox(height: AppSpacing.xs),
                _Coordinates(location: location),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  l10n.reportLocationRetention,
                  style: context.textStyles.bodySmall,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        DetailSection(
          title: l10n.reportSectionHistory,
          child: _Timeline(history: report.history),
        ),
        const SizedBox(height: AppSpacing.md),
        DetailSection(
          title: l10n.reportSectionAction,
          child: report.allowedTransitions.isEmpty
              ? Text(
                  l10n.reportFinalStatus,
                  style: context.textStyles.bodyMedium,
                )
              : _StatusForm(
                  key: ValueKey(report.status),
                  report: report,
                  saving: state.saving,
                  failure: state.actionFailure is StaleDataFailure
                      ? null
                      : state.actionFailure,
                ),
        ),
      ],
    );
  }
}

/// YZ kanıt etiketi ve gerekçeleri (kök ADR 35). Yalnızca yardımcıdır:
/// durumu değiştirmez; karar personelindir.
class _EvidenceView extends StatelessWidget {
  const _EvidenceView({required this.report});

  final DamageReport report;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final locale = Localizations.localeOf(context).toString();
    final evidence = report.evidence;
    final level = report.evidenceLevel;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KeyValueList(
          entries: [
            (l10n.evidenceLevelLabel, level.label(l10n)),
            if (evidence?.version case final version?)
              (l10n.aiModelLabel, version),
            if (evidence?.scoredAt case final at?)
              (l10n.aiScoredAtLabel, context.formatDateTime(at)),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(level.help(l10n), style: context.textStyles.bodyMedium),
        if (evidence != null)
          for (final effect in EvidenceEffect.values)
            if (evidence.withEffect(effect).toList() case final reasons
                when reasons.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              Text(
                effect.label(l10n),
                style: context.textStyles.labelMedium.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xxs),
              for (final reason in reasons)
                Semantics(
                  container: true,
                  label: l10n.evidenceReasonSemantics(
                    effect.label(l10n),
                    reason.label(l10n, locale),
                  ),
                  excludeSemantics: true,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.xxs,
                    ),
                    child: Text(
                      reason.label(l10n, locale),
                      style: context.textStyles.bodyMedium.copyWith(
                        color: effect == EvidenceEffect.undermines
                            ? colors.error
                            : null,
                      ),
                    ),
                  ),
                ),
            ],
        const SizedBox(height: AppSpacing.md),
        Text(
          l10n.evidenceDisclaimer,
          style: context.textStyles.bodySmall.copyWith(
            color: colors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _Coordinates extends StatelessWidget {
  const _Coordinates({required this.location});

  final ReportLocation location;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final latitude = location.latitude.toStringAsFixed(6);
    final longitude = location.longitude.toStringAsFixed(6);
    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SelectableText(
          l10n.reportCoordinates(
            latitude,
            longitude,
            location.accuracyMeters.round(),
          ),
          style: context.textStyles.bodyMedium.copyWith(
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        TextButton(
          onPressed: () async {
            await Clipboard.setData(
              ClipboardData(text: '$latitude, $longitude'),
            );
            if (context.mounted) {
              AppSnackBar.show(context, message: l10n.commonCopied);
            }
          },
          child: Text(l10n.reportCopyCoordinates),
        ),
        TextButton(
          onPressed: () => unawaited(
            launchUrl(
              Uri.https('www.openstreetmap.org', '/', {
                'mlat': latitude,
                'mlon': longitude,
              }).replace(fragment: 'map=18/$latitude/$longitude'),
              mode: LaunchMode.externalApplication,
            ),
          ),
          child: Text(l10n.reportOpenMap),
        ),
      ],
    );
  }
}

class _Timeline extends StatelessWidget {
  const _Timeline({required this.history});

  final List<ReportHistoryEntry> history;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final entry in history.reversed)
          MergeSemantics(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.xs - 2),
                    child: SizedBox.square(
                      dimension: AppSpacing.xs,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.status.label(l10n),
                          style: context.textStyles.labelLarge,
                        ),
                        Text(
                          [
                            context.formatDateTime(entry.at),
                            if (entry.actor case final actor?)
                              l10n.reportHistoryBy(
                                actor.displayName ?? actor.id,
                              ),
                          ].join(' · '),
                          style: context.textStyles.bodySmall,
                        ),
                        if (entry.note case final note?)
                          Text(
                            l10n.reportHistoryNoteCitizen(note),
                            style: context.textStyles.bodyMedium,
                          ),
                        if (entry.internalNote case final note?)
                          Text(
                            l10n.reportHistoryNoteInternal(note),
                            style: context.textStyles.bodyMedium.copyWith(
                              color: colors.onSurfaceVariant,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _StatusForm extends StatefulWidget {
  const _StatusForm({
    required this.report,
    required this.saving,
    required this.failure,
    super.key,
  });

  final DamageReport report;
  final bool saving;
  final Failure? failure;

  @override
  State<_StatusForm> createState() => _StatusFormState();
}

class _StatusFormState extends State<_StatusForm> {
  static const int _maxNote = 1000;

  late ReportStatus _next = widget.report.allowedTransitions.first;
  final _note = TextEditingController();
  final _internal = TextEditingController();
  bool _tooLong = false;

  @override
  void dispose() {
    _note.dispose();
    _internal.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = context.l10n;
    setState(
      () => _tooLong =
          _note.text.length > _maxNote || _internal.text.length > _maxNote,
    );
    if (_tooLong) {
      return;
    }
    if (!_next.isOpen) {
      final confirmed = await showConfirmDialog(
        context,
        title: l10n.reportConfirmFinalTitle,
        message: l10n.reportConfirmFinalBody(_next.label(l10n)),
        confirmLabel: _next.label(l10n),
      );
      if (!confirmed || !mounted) {
        return;
      }
    }
    await context.read<ReportDetailCubit>().changeStatus(
      _next,
      note: _note.text,
      internalNote: _internal.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.failure != null) ...[
          InlineMessage(
            type: InlineMessageType.error,
            message: widget.failure!.toUserMessage(l10n),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        Text(l10n.reportNextStatus, style: context.textStyles.labelLarge),
        const SizedBox(height: AppSpacing.xs),
        RadioGroup<ReportStatus>(
          groupValue: _next,
          onChanged: (value) {
            if (value != null && !widget.saving) {
              setState(() => _next = value);
            }
          },
          child: Column(
            children: [
              for (final status in widget.report.allowedTransitions)
                RadioListTile<ReportStatus>(
                  value: status,
                  title: Text(status.label(l10n)),
                  contentPadding: EdgeInsets.zero,
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextField(
          controller: _note,
          enabled: !widget.saving,
          minLines: 2,
          maxLines: 5,
          maxLength: _maxNote,
          decoration: InputDecoration(
            labelText: l10n.reportNoteCitizen,
            helperText: l10n.reportNoteCitizenHelp,
            errorText: _tooLong ? l10n.reportNoteTooLong : null,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextField(
          controller: _internal,
          enabled: !widget.saving,
          minLines: 2,
          maxLines: 5,
          maxLength: _maxNote,
          decoration: InputDecoration(labelText: l10n.reportNoteInternal),
        ),
        const SizedBox(height: AppSpacing.md),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: FilledButton(
            onPressed: widget.saving ? null : () => unawaited(_submit()),
            child: Text(l10n.reportUpdate),
          ),
        ),
      ],
    );
  }
}
