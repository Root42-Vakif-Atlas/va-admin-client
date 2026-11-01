import 'package:flutter/material.dart';
import 'package:vakif_atlas_admin/core/theme/theme_context.dart';
import 'package:vakif_atlas_admin/core/theme/tokens/app_spacing.dart';
import 'package:vakif_atlas_admin/core/utils/turkish_text.dart';

/// Kullanıcının baş harfleri veya misafir ikonu (daire).
///
/// Görseldir; anlamı çağıranın etiketi taşır (ör. [AccountAvatarButton]).
class AccountAvatar extends StatelessWidget {
  const AccountAvatar({
    required this.displayName,
    this.size = AppSizes.minTouchTarget,
    super.key,
  });

  /// `null` → misafir.
  final String? displayName;
  final double size;

  /// Bu boyutun altında baş harfler küçük yazı stiliyle çizilir.
  static const double _mediumSize = 40;

  /// "ayşe nur yılmaz" → "AY": ilk ve son kelimenin baş harfi.
  static String initialsOf(String displayName) {
    final words = displayName
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();
    if (words.isEmpty) {
      return '';
    }
    String first(String word) => String.fromCharCode(word.runes.first);
    final initials = words.length == 1
        ? first(words.single)
        : first(words.first) + first(words.last);
    return TurkishText.toUpperCase(initials);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final name = displayName;
    final initials = name == null ? '' : initialsOf(name);
    final guest = initials.isEmpty;
    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: guest ? colors.surfaceElevated : colors.primaryContainer,
          border: guest || colors.isHighContrast
              ? Border.all(color: colors.outline)
              : null,
        ),
        child: guest
            ? Icon(
                Icons.person_outline,
                color: colors.onSurface,
                size: size / 2,
              )
            : Text(
                initials,
                // Baş harfler daireye sığacak sabit boyuttadır; ad ekran
                // okuyucuya ve hesap menüsünde tam metin olarak sunulur.
                textScaler: TextScaler.noScaling,
                style: switch (size) {
                  >= AppSizes.avatarLarge => context.textStyles.headlineMedium,
                  >= _mediumSize => context.textStyles.titleMedium,
                  // Liste içi küçük avatar (ör. 32 dp): iki harf daireye sığar.
                  _ => context.textStyles.labelMedium,
                }.copyWith(color: colors.onPrimaryContainer),
              ),
      ),
    );
  }
}

/// Hesap menüsünü açan profil görseli (48×48 dp dokunma alanı).
class AccountAvatarButton extends StatelessWidget {
  const AccountAvatarButton({
    required this.displayName,
    required this.semanticsLabel,
    required this.onPressed,
    super.key,
  });

  final String? displayName;
  final String semanticsLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticsLabel,
      excludeSemantics: true,
      onTap: onPressed,
      child: Tooltip(
        message: semanticsLabel,
        excludeFromSemantics: true,
        child: Material(
          type: MaterialType.transparency,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onPressed,
            customBorder: const CircleBorder(),
            child: AccountAvatar(displayName: displayName),
          ),
        ),
      ),
    );
  }
}
