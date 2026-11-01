import 'package:vakif_atlas_admin/core/l10n/l10n.dart';
import 'package:vakif_atlas_admin/features/catalog/domain/catalog_entities.dart';
import 'package:vakif_atlas_admin/shared/widgets/molecules/status_chip.dart';

extension MonumentCategoryLabel on MonumentCategory {
  String label(AppLocalizations l10n) => switch (this) {
    MonumentCategory.mosque => l10n.categoryMosque,
    MonumentCategory.complex => l10n.categoryComplex,
    MonumentCategory.madrasa => l10n.categoryMadrasa,
    MonumentCategory.inn => l10n.categoryInn,
    MonumentCategory.caravanserai => l10n.categoryCaravanserai,
    MonumentCategory.bath => l10n.categoryBath,
    MonumentCategory.fountain => l10n.categoryFountain,
    MonumentCategory.tomb => l10n.categoryTomb,
    MonumentCategory.hospital => l10n.categoryHospital,
    MonumentCategory.imaret => l10n.categoryImaret,
    MonumentCategory.other => l10n.categoryMonumentOther,
  };
}

extension MonumentPeriodLabel on MonumentPeriod {
  String label(AppLocalizations l10n) => switch (this) {
    MonumentPeriod.seljuk => l10n.periodSeljuk,
    MonumentPeriod.beylik => l10n.periodBeylik,
    MonumentPeriod.ottoman => l10n.periodOttoman,
    MonumentPeriod.other => l10n.periodOther,
  };
}

extension PublicationLabel on Publication {
  String label(AppLocalizations l10n) => switch (this) {
    Publication.published => l10n.publicationPublished,
    Publication.archived => l10n.publicationArchived,
  };

  StatusChip chip(AppLocalizations l10n) => StatusChip(
    label: label(l10n),
    tone: this == Publication.published
        ? StatusTone.success
        : StatusTone.neutral,
  );
}
