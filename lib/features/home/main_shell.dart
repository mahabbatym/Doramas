import 'package:dorama_nest/core/widgets/library_sync_status.dart';
import 'package:flutter/material.dart';
import 'package:dorama_nest/core/theme/app_theme.dart';
import 'package:dorama_nest/features/home/home_page.dart';
import 'package:dorama_nest/features/catalog/catalog_page.dart';
import 'package:dorama_nest/features/search/search_page.dart';
import 'package:dorama_nest/features/favorites/favorites_page.dart';
import 'package:dorama_nest/features/profile/profile_page.dart';
import 'package:dorama_nest/core/locale_text.dart';
import 'package:dorama_nest/data/api/api_exception.dart';
import 'package:dorama_nest/state/app_controller.dart';

class MainShell extends StatefulWidget {
  final int initialIndex;
  const MainShell({super.key, this.initialIndex = 0});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int selected;
  String filter = 'Все';
  @override
  void initState() {
    super.initState();
    selected = widget.initialIndex.clamp(0, 4).toInt();
  }

  void select(int index, {String category = 'Все'}) => setState(() {
        selected = index;
        if (index == 1) filter = category;
      });

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final tabs = [
      HomePage(onTab: (i, category) => select(i, category: category)),
      CatalogPage(initialFilter: filter, onSearch: () => select(2)),
      const SearchPage(),
      FavoritesPage(onCatalog: () => select(1)),
      ProfilePage(onTab: select),
    ];
    const icons = [
      Icons.home_outlined,
      Icons.grid_view_rounded,
      Icons.search_rounded,
      Icons.favorite_border_rounded,
      Icons.account_circle_outlined
    ];
    const filled = [
      Icons.home_rounded,
      Icons.grid_view_rounded,
      Icons.search_rounded,
      Icons.favorite_rounded,
      Icons.account_circle_rounded
    ];
    final labels = ['Главная', 'Каталог', 'Поиск', 'Избранное', 'Профиль']
        .map((s) => tx(context, s))
        .toList();
    return Scaffold(
      body: SafeArea(
          bottom: false,
          child: Column(children: [
            if (app.cloudConfigured) const LibrarySyncStatus(),
            if (app.apiFailure != null)
              MaterialBanner(
                content: Text(apiStatusText(context, app.apiFailure,
                    showingSavedData: app.showingSavedData)),
                leading: Icon(app.apiFailure == ApiFailureKind.configuration
                    ? Icons.cloud_off_rounded
                    : Icons.wifi_off_rounded),
                actions: [
                  TextButton(
                    onPressed: app.catalogLoading ? null : app.retryCloud,
                    child: Text(tx(context, 'Қайталау')),
                  ),
                ],
              ),
            if (app.storageError != null)
              MaterialBanner(
                content: Text(tx(context, app.storageError!)),
                leading: const Icon(Icons.storage_rounded),
                actions: [
                  TextButton(
                    onPressed: app.dismissStorageError,
                    child: Text(tx(context, 'Закрыть')),
                  ),
                ],
              ),
            if (app.catalogLoading) const LinearProgressIndicator(minHeight: 2),
            Expanded(child: IndexedStack(index: selected, children: tabs)),
          ])),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            color: context.nestSurface,
            border:
                Border(top: BorderSide(color: Theme.of(context).dividerColor))),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.only(top: 9, bottom: 6),
            child: Row(
                children: List.generate(5, (index) {
              return Expanded(
                child: Semantics(
                  button: true,
                  selected: selected == index,
                  label: labels[index],
                  child: InkWell(
                    onTap: () => select(index),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Icon(selected == index ? filled[index] : icons[index],
                            size: 25,
                            color: selected == index
                                ? NestColors.blue
                                : const Color(0xFF95A8BA)),
                        const SizedBox(height: 5),
                        Text(labels[index],
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: selected == index
                                    ? FontWeight.w800
                                    : FontWeight.w500,
                                color: selected == index
                                    ? NestColors.blue
                                    : const Color(0xFF95A8BA))),
                      ]),
                    ),
                  ),
                ),
              );
            })),
          ),
        ),
      ),
    );
  }
}
