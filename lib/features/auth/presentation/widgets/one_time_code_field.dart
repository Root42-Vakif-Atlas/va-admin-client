import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vakif_atlas_admin/core/theme/theme_context.dart';

/// 6 haneli Authenticator kodu veya `XXXX-XXXX` kurtarma kodu alanı.
/// Yapıştırma desteklenir (boşluk/tire temizlenir); sistem tek kullanımlık
/// kod otomatik doldurmasını önerir.
class OneTimeCodeField extends StatelessWidget {
  const OneTimeCodeField({
    required this.controller,
    required this.label,
    required this.onSubmitted,
    this.recovery = false,
    this.hint,
    this.errorText,
    this.enabled = true,
    this.autofocus = false,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final String? errorText;
  final bool recovery;
  final bool enabled;
  final bool autofocus;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: enabled,
      autofocus: autofocus,
      autofillHints: recovery ? null : const [AutofillHints.oneTimeCode],
      keyboardType: recovery ? TextInputType.text : TextInputType.number,
      textInputAction: TextInputAction.done,
      textCapitalization: recovery
          ? TextCapitalization.characters
          : TextCapitalization.none,
      inputFormatters: recovery
          ? [
              FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9- ]')),
              LengthLimitingTextInputFormatter(11),
            ]
          : [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
      style: context.textStyles.headlineMedium.copyWith(
        letterSpacing: recovery ? 2 : 8,
        fontFeatures: const [FontFeature.tabularFigures()],
      ),
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        errorText: errorText,
      ),
    );
  }
}

/// Alan değeri gönderilebilir mi (6 hane / 8 karakterlik kurtarma kodu).
bool isCompleteCode(String value, {required bool recovery}) {
  final clean = value.replaceAll(RegExp('[^A-Za-z0-9]'), '');
  return recovery ? clean.length == 8 : RegExp(r'^\d{6}$').hasMatch(clean);
}
