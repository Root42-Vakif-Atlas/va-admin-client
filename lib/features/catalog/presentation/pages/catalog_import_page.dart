import 'dart:async';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as p;
import 'package:vakif_atlas_admin/core/a11y/a11y_announcer.dart';
import 'package:vakif_atlas_admin/core/l10n/failure_messages.dart';
import 'package:vakif_atlas_admin/core/l10n/l10n.dart';
import 'package:vakif_atlas_admin/core/theme/theme_context.dart';
import 'package:vakif_atlas_admin/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas_admin/features/catalog/domain/catalog_import.dart';
import 'package:vakif_atlas_admin/features/catalog/presentation/catalog_import_cubit.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/detail_section.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/inline_message.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/status_chip.dart';
import 'package:vakif_atlas_admin/shared/widgets/templates/admin_page.dart';
import 'package:vakif_atlas_admin/core/theme/responsive.dart';

/// VGM verisinin içe aktarımı (ADR 59): klasör seçilir (veri dosyası +
/// `images/`), sunucu planı gösterilir, onayla görseller yüklenip kayıtlar
/// tek işlemde yazılır. Çalışırken çıkış onay ister (`onExit`).
class CatalogImportPage extends StatelessWidget {
  const CatalogImportPage({
    required this.onBack,
    required this.onOpenCatalog,
    super.key,
  });

  final VoidCallback onBack;

  /// Bitince konumu girilmemiş eserler listesine gider.
  final VoidCallback onOpenCatalog;

  Future<void> _pickFolder(BuildContext context) async {
    final cubit = context.read<CatalogImportCubit>();
    final folder = await getDirectoryPath(
      confirmButtonText: context.l10n.importPickFolder,
    );
    if (folder != null) {
      await cubit.selectFolder(folder);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocConsumer<CatalogImportCubit, CatalogImportState>(
      listenWhen: (previous, current) => previous.stage != current.stage,
      listener: (context, state) {
        final message = switch (state.stage) {
          ImportStage.planned when state.plan?.valid ?? false =>
            l10n.importPlanReady,
          ImportStage.planned => l10n.importPlanInvalid,
          ImportStage.done => l10n.importDone,
          _ => null,
        };
        if (message != null) {
          unawaited(context.read<A11yAnnouncer>().announce(message));
        }
      },
      builder: (context, state) {
        final cubit = context.read<CatalogImportCubit>();
        return AdminPage(
          title: l10n.importTitle,
          subtitle: l10n.importSubtitle,
          actions: [
            TextButton(
              onPressed: state.running ? null : onBack,
              child: Text(l10n.editorBack),
            ),
            if (state.stage == ImportStage.uploading)
              OutlinedButton(
                onPressed: state.cancelling ? null : cubit.cancel,
                child: Text(l10n.importCancel),
              ),
            if (state.stage == ImportStage.done)
              FilledButton(
                onPressed: onOpenCatalog,
                child: Text(l10n.importOpenMissingLocation),
              )
            else
              FilledButton(
                onPressed: state.canStart
                    ? () => unawaited(cubit.start())
                    : null,
                child: Text(
                  (state.plan?.missingImages.isEmpty ?? true)
                      ? l10n.importStart
                      : l10n.importStartWithImages(state.toUpload),
                ),
              ),
          ],
          child: SingleChildScrollView(
            padding: EdgeInsets.all(context.pageGutter),
            child: Align(
              alignment: AlignmentDirectional.topStart,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 960),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DetailSection(
                      title: l10n.importSourceTitle,
                      child: _SourceSection(
                        state: state,
                        onPickFolder: () => unawaited(_pickFolder(context)),
                      ),
                    ),
                    if (state.failure case final failure?) ...[
                      InlineMessage(
                        type: InlineMessageType.error,
                        message: failure.toUserMessage(l10n),
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],
                    if (state.stage == ImportStage.reading ||
                        state.stage == ImportStage.planning)
                      _Progress(
                        label: state.stage == ImportStage.reading
                            ? l10n.importReading
                            : l10n.importPlanning,
                      ),
                    if (state.plan case final plan?) ...[
                      _PlanSection(state: state, plan: plan),
                      if (state.stage == ImportStage.uploading ||
                          state.stage == ImportStage.committing ||
                          state.uploaded > 0 ||
                          state.uploadFailed > 0)
                        DetailSection(
                          title: l10n.importProgressTitle,
                          child: _UploadProgress(state: state),
                        ),
                      if (plan.result case final result?)
                        DetailSection(
                          title: l10n.importResultTitle,
                          child: KeyValueList(
                            entries: [
                              (l10n.importResultCreated, '${result.created}'),
                              (l10n.importResultUpdated, '${result.updated}'),
                              (
                                l10n.importResultComplexesCreated,
                                '${result.createdComplexes}',
                              ),
                              (
                                l10n.importResultComplexesUpdated,
                                '${result.updatedComplexes}',
                              ),
                              (l10n.importResultVersion, result.catalogVersion),
                            ],
                          ),
                        ),
                      if (plan.errors.isNotEmpty)
                        DetailSection(
                          title: l10n.importErrorsTitle(plan.errors.length),
                          child: _IssueList(issues: plan.errors),
                        ),
                      if (plan.warnings.isNotEmpty)
                        DetailSection(
                          title: l10n.importWarningsTitle(plan.warningCount),
                          child: _IssueList(issues: plan.warnings),
                        ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SourceSection extends StatelessWidget {
  const _SourceSection({required this.state, required this.onPickFolder});

  final CatalogImportState state;
  final VoidCallback onPickFolder;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<CatalogImportCubit>();
    final folder = state.folder;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.importSourceHelp, style: context.textStyles.bodyMedium),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: Text(
                folder ?? l10n.importNoFolder,
                style: context.textStyles.bodyLarge,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            OutlinedButton(
              onPressed: state.busy ? null : onPickFolder,
              child: Text(
                folder == null
                    ? l10n.importPickFolder
                    : l10n.importChangeFolder,
              ),
            ),
          ],
        ),
        if (folder != null && state.jsonFiles.isEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          InlineMessage(
            type: InlineMessageType.error,
            message: l10n.importNoJson,
          ),
        ],
        if (state.jsonFiles.length > 1) ...[
          const SizedBox(height: AppSpacing.md),
          DropdownMenu<String>(
            label: Text(l10n.importJsonFile),
            initialSelection: state.jsonPath,
            width: 480,
            enabled: !state.busy,
            onSelected: (path) {
              if (path != null) {
                unawaited(cubit.selectJson(path));
              }
            },
            dropdownMenuEntries: [
              for (final file in state.jsonFiles)
                DropdownMenuEntry(value: file, label: p.basename(file)),
            ],
          ),
        ],
        if (state.seed case final seed? when seed.issues.isEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            l10n.importLocalSummary(
              seed.files.length,
              (seed.totalBytes / (1024 * 1024)).toStringAsFixed(1),
            ),
            style: context.textStyles.bodySmall,
          ),
        ],
      ],
    );
  }
}

class _PlanSection extends StatelessWidget {
  const _PlanSection({required this.state, required this.plan});

  final CatalogImportState state;
  final ImportPlan plan;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final counts = plan.counts;
    return DetailSection(
      title: l10n.importPlanTitle,
      trailing: StatusChip(
        label: plan.committed
            ? l10n.importStatusCommitted
            : plan.valid
            ? l10n.importStatusValid
            : l10n.importStatusInvalid,
        tone: plan.committed
            ? StatusTone.success
            : plan.valid
            ? StatusTone.info
            : StatusTone.danger,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (counts != null)
            KeyValueList(
              entries: [
                (l10n.importCountComplexes, '${counts.complexes}'),
                (l10n.importCountWorks, '${counts.works}'),
                (l10n.importCountParts, '${counts.parts}'),
                (
                  l10n.importCountImages,
                  l10n.importCountImagesValue(
                    counts.images,
                    counts.uniqueImages,
                  ),
                ),
                (l10n.importCountNew, '${counts.created}'),
                (l10n.importCountExisting, '${counts.existing}'),
                (l10n.importCountMissingImages, '${plan.missingImages.length}'),
              ],
            ),
          if (plan.valid && !plan.committed) ...[
            const SizedBox(height: AppSpacing.sm),
            InlineMessage(message: l10n.importMergeNotice),
          ],
        ],
      ),
    );
  }
}

class _UploadProgress extends StatelessWidget {
  const _UploadProgress({required this.state});

  final CatalogImportState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final total = state.toUpload;
    final done = state.uploaded + state.uploadFailed;
    final committing = state.stage == ImportStage.committing;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          label: l10n.importProgressTitle,
          value: committing
              ? l10n.importCommitting
              : l10n.importUploadProgress(state.uploaded, total),
          child: LinearProgressIndicator(
            value: committing || total == 0 ? null : done / total,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          committing
              ? l10n.importCommitting
              : state.cancelling
              ? l10n.importCancelling
              : l10n.importUploadProgress(state.uploaded, total),
        ),
        if (state.uploadFailed > 0)
          Text(
            l10n.importUploadFailed(state.uploadFailed),
            style: context.textStyles.bodyMedium.copyWith(
              color: context.colors.error,
            ),
          ),
      ],
    );
  }
}

class _Progress extends StatelessWidget {
  const _Progress({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.md),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(label: label, child: const LinearProgressIndicator()),
        const SizedBox(height: AppSpacing.xs),
        Text(label),
      ],
    ),
  );
}

class _IssueList extends StatelessWidget {
  const _IssueList({required this.issues});

  final List<ImportIssue> issues;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final styles = context.textStyles;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final issue in issues.take(200))
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
            child: MergeSemantics(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(issueLabel(l10n, issue.code), style: styles.bodyMedium),
                  SelectableText(
                    issue.detail == null
                        ? issue.path
                        : '${issue.path} · ${issue.detail}',
                    style: styles.bodySmall.copyWith(
                      color: context.colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (issues.length > 200)
          Text(
            l10n.importMoreIssues(issues.length - 200),
            style: styles.bodySmall,
          ),
      ],
    );
  }
}

/// Sabit bulgu kodunun açıklaması; bilinmeyen kod olduğu gibi gösterilir.
String issueLabel(AppLocalizations l10n, String code) => switch (code) {
  'invalid_json' => l10n.importIssueInvalidJson,
  'missing_file' => l10n.importIssueMissingFile,
  'file_too_large' => l10n.importIssueFileTooLarge,
  'missing_image_hash' => l10n.importIssueMissingFile,
  'unsupported_format_version' => l10n.importIssueFormatVersion,
  'required' => l10n.importIssueRequired,
  'too_long' => l10n.importIssueTooLong,
  'invalid_key' || 'key_too_long' => l10n.importIssueInvalidKey,
  'duplicate_key' => l10n.importIssueDuplicateKey,
  'key_collision' => l10n.importIssueDuplicateKey,
  'invalid_slug' || 'duplicate_slug' => l10n.importIssueSlug,
  'unknown_city' => l10n.importIssueUnknownCity,
  'invalid_src' => l10n.importIssueInvalidSrc,
  'too_many_images' => l10n.importIssueTooManyImages,
  'unknown_member' => l10n.importIssueUnknownMember,
  'member_in_two_complexes' => l10n.importIssueMemberTwice,
  'member_city_mismatch' => l10n.importIssueMemberCity,
  'duplicate_member' => l10n.importIssueDuplicateMember,
  'key_collision_renamed' => l10n.importWarningRenamed,
  'category_other' => l10n.importWarningCategory,
  'duplicate_title' => l10n.importWarningDuplicateTitle,
  'no_district' => l10n.importWarningNoDistrict,
  'no_images' => l10n.importWarningNoImages,
  _ => code,
};
