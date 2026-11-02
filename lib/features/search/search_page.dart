import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dorama_nest/core/widgets/nest_widgets.dart';
import 'package:dorama_nest/core/theme/app_theme.dart';
import 'package:dorama_nest/core/locale_text.dart';
import 'package:dorama_nest/state/app_controller.dart';
import 'package:dorama_nest/data/models/drama.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final search = TextEditingController();
  List<Drama> matches = [];
  bool searching = false;
  Timer? _debounce;
  @override
  void dispose() {
    _debounce?.cancel();
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    if (matches.isEmpty && !searching && search.text.isEmpty)
      matches = app.dramas;
    return ListView(padding: pagePadding, children: [
      const SizedBox(height: 23),
      NestPageTitle(
          title: tx(context, 'Найди свою\nисторию ⌕'),
          subtitle:
              tx(context, 'Самая любимая дорама — всего в одном поиске.')),
      const SizedBox(height: 24),
      TextField(
          controller: search,
          autofocus: false,
          onChanged: (value) {
            _debounce?.cancel();
            setState(() => searching = true);
            _debounce = Timer(const Duration(milliseconds: 300), () async {
              try {
                final result = await app.searchDramas(value);
                if (mounted && search.text == value) {
                  setState(() {
                    matches = result;
                    searching = false;
                  });
                }
              } catch (error) {
                if (mounted && search.text == value) {
                  setState(() => searching = false);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:
                          Text(tx(context, 'Не удалось выполнить поиск'))));
                }
              }
            });
          },
          decoration: InputDecoration(
              prefixIcon:
                  const Icon(Icons.search_rounded, color: NestColors.blue),
              hintText: tx(context, 'Название или жанр...'),
              suffixIcon: search.text.isEmpty
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () {
                        search.clear();
                        setState(() => matches = app.dramas);
                      }))),
      const SizedBox(height: 24),
      Row(children: [
        Text(tx(context, 'Результаты'),
            style: Theme.of(context).textTheme.titleLarge),
        const Spacer(),
        Text(resultsCount(context, matches.length),
            style: Theme.of(context).textTheme.bodySmall)
      ]),
      const SizedBox(height: 15),
      if (searching)
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Center(child: CircularProgressIndicator()),
        )
      else if (matches.isEmpty)
        NestEmptyState(
            icon: Icons.search_off_rounded,
            title: tx(context, 'Ничего не найдено'),
            message: tx(context, 'Попробуй другое название, страну или жанр.'),
            action: tx(context, 'Очистить поиск'),
            onAction: () {
              search.clear();
              setState(() {});
            }),
      ...matches.map((d) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: DramaListTile(
              drama: d,
              onTap: () =>
                  Navigator.pushNamed(context, '/detail', arguments: d.id)))),
      const SizedBox(height: 30),
    ]);
  }
}
