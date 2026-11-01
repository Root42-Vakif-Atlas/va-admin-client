import 'package:flutter/material.dart';
import 'package:vakif_atlas_admin/core/theme/tokens/app_spacing.dart';

/// Ana gezinme hedefi.
@immutable
class AdaptiveDestination {
  const AdaptiveDestination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.key,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;

  /// Entegrasyon testleri için.
  final Key key;
}

/// Ekran genişliğine göre uyarlanan gezinme iskeleti (Design System §4).
///
/// - `Compact` (< 600 dp): alt `NavigationBar`
/// - `Medium` (600–839 dp): etiketli `NavigationRail`
/// - `Expanded` (≥ 840 dp): genişletilmiş `NavigationRail`
///
/// Genişlik `MediaQuery` yerine `LayoutBuilder` kısıtlarından okunur.
class AdaptiveAppScaffold extends StatelessWidget {
  const AdaptiveAppScaffold({
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.body,
    required this.navigationLabel,
    super.key,
  });

  final List<AdaptiveDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget body;

  /// Gezinme bölgesinin ekran okuyucu adı.
  final String navigationLabel;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < AppBreakpoints.medium) {
          return Scaffold(
            body: body,
            bottomNavigationBar: Semantics(
              container: true,
              label: navigationLabel,
              explicitChildNodes: true,
              child: NavigationBar(
                selectedIndex: selectedIndex,
                onDestinationSelected: onDestinationSelected,
                destinations: [
                  for (final destination in destinations)
                    NavigationDestination(
                      key: destination.key,
                      icon: Icon(destination.icon),
                      selectedIcon: Icon(destination.selectedIcon),
                      label: destination.label,
                    ),
                ],
              ),
            ),
          );
        }

        final extended = constraints.maxWidth >= AppBreakpoints.expanded;
        return Scaffold(
          body: Row(
            children: [
              Semantics(
                container: true,
                label: navigationLabel,
                explicitChildNodes: true,
                child: SafeArea(
                  right: false,
                  child: NavigationRail(
                    extended: extended,
                    labelType: extended
                        ? NavigationRailLabelType.none
                        : NavigationRailLabelType.all,
                    selectedIndex: selectedIndex,
                    onDestinationSelected: onDestinationSelected,
                    destinations: [
                      for (final destination in destinations)
                        NavigationRailDestination(
                          icon: Icon(destination.icon, key: destination.key),
                          selectedIcon: Icon(destination.selectedIcon),
                          label: Text(destination.label),
                        ),
                    ],
                  ),
                ),
              ),
              const VerticalDivider(width: AppSizes.borderThin),
              Expanded(child: body),
            ],
          ),
        );
      },
    );
  }
}
