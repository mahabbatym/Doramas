import 'package:flutter/material.dart';
import 'package:dorama_nest/core/theme/app_theme.dart';
import 'package:dorama_nest/core/widgets/nest_widgets.dart';
import 'package:dorama_nest/core/locale_text.dart';
import 'package:dorama_nest/state/app_controller.dart';
import 'package:dorama_nest/data/services/catalog_query.dart';

class CatalogPage extends StatefulWidget {
  final String initialFilter;
  final VoidCallback onSearch;
  const CatalogPage(
      {super.key, required this.initialFilter, required this.onSearch});
  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  late String filter;
  String sort = 'title';
  String countryFilter = 'all';
  String statusFilter = 'all';
  int yearFilter = 0;
  @override
  void initState() {
    super.initState();
    filter = widget.initialFilter;
  }

  @override
  void didUpdateWidget(CatalogPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialFilter != widget.initialFilter)
      filter = widget.initialFilter;
  }

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final dropdownWidth = ((MediaQuery.sizeOf(context).width - 62) / 3)
        .clamp(82.0, 145.0)
        .toDouble();
    final years = app.dramas.map((drama) => drama.year).toSet().toList()
      ..sort((a, b) => b.compareTo(a));
    final results = CatalogQuery(
      country: countryFilter == 'all'
          ? (filter == 'Корея' || filter == 'Китай' ? filter : null)
          : countryFilter,
      genre: filter != 'Все' && filter != 'Корея' && filter != 'Китай'
          ? filter
          : null,
      year: yearFilter == 0 ? null : yearFilter,
      status: statusFilter == 'all' ? null : statusFilter,
      locale: app.language,
      sort: switch (sort) {
        'year' => CatalogSort.releaseYear,
        'score' => CatalogSort.rating,
        _ => CatalogSort.title,
      },
      descending: sort != 'title',
    ).apply(app.dramas);
    const filters = [
      'Все',
      'Корея',
      'Китай',
      'Романтика',
      'Комедия',
      'Фэнтези',
      'Музыка',
      'Драма',
    ];
    return Column(children: [
      Padding(
          padding: const EdgeInsets.fromLTRB(23, 16, 23, 15),
          child: Row(children: [
            Text(tx(context, 'Каталог'),
                style: Theme.of(context).textTheme.titleLarge),
            const Spacer(),
            IconButton(
                onPressed: widget.onSearch,
                icon: const Icon(Icons.search_rounded, color: NestColors.blue)),
          ])),
      Expanded(
          child: ListView(padding: pagePadding, children: [
        const SizedBox(height: 12),
        NestPageTitle(
            title: tx(context, 'Выбирай по\nнастроению ✧'),
            subtitle: tx(context, 'Все истории ждут своего зрителя.')),
        const SizedBox(height: 20),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            SizedBox(
              width: dropdownWidth,
              child: DropdownButton<String>(
                isExpanded: true,
                isDense: true,
                iconSize: 18,
                style: const TextStyle(fontSize: 12),
                value: countryFilter,
                items: [
                  DropdownMenuItem(
                      value: 'all',
                      child: _filterLabel(context, 'Барлық елдер')),
                  DropdownMenuItem(
                      value: 'Корея', child: _filterLabel(context, 'Корея')),
                  DropdownMenuItem(
                      value: 'Китай', child: _filterLabel(context, 'Китай')),
                ],
                onChanged: (value) =>
                    setState(() => countryFilter = value ?? 'all'),
              ),
            ),
            SizedBox(
              width: dropdownWidth,
              child: DropdownButton<int>(
                isExpanded: true,
                isDense: true,
                iconSize: 18,
                style: const TextStyle(fontSize: 12),
                value: yearFilter,
                items: [
                  DropdownMenuItem(
                      value: 0, child: _filterLabel(context, 'Все годы')),
                  ...years.map((year) => DropdownMenuItem(
                      value: year, child: _filterLabel(context, '$year'))),
                ],
                onChanged: (value) => setState(() => yearFilter = value ?? 0),
              ),
            ),
            SizedBox(
              width: dropdownWidth,
              child: DropdownButton<String>(
                isExpanded: true,
                isDense: true,
                iconSize: 18,
                style: const TextStyle(fontSize: 12),
                value: statusFilter,
                items: [
                  DropdownMenuItem(
                      value: 'all',
                      child: _filterLabel(context, 'Все статусы')),
                  ...const [
                    'announced',
                    'ongoing',
                    'completed',
                    'released',
                    'hiatus',
                  ].map((status) => DropdownMenuItem(
                      value: status,
                      child: _filterLabel(
                          context, dramaStatusLabel(context, status),
                          localize: false))),
                ],
                onChanged: (value) =>
                    setState(() => statusFilter = value ?? 'all'),
              ),
            ),
          ],
        ),
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                children: filters
                    .map((f) => Padding(
                        padding: const EdgeInsets.only(right: 7),
                        child: GenreChip(
                            label: tx(context, f),
                            selected: filter == f,
                            onTap: () => setState(() => filter = f))))
                    .toList())),
        const SizedBox(height: 23),
        Text('${tx(context, 'Найдено:')} ${results.length}',
            style: Theme.of(context).textTheme.bodySmall),
        Align(
          alignment: Alignment.centerRight,
          child: DropdownButton<String>(
            value: sort,
            underline: const SizedBox.shrink(),
            items: [
              DropdownMenuItem(
                  value: 'title', child: Text(tx(context, 'По названию'))),
              DropdownMenuItem(
                  value: 'year', child: Text(tx(context, 'Сначала новые'))),
              DropdownMenuItem(
                  value: 'score', child: Text(tx(context, 'По рейтингу'))),
            ],
            onChanged: (value) {
              if (value == null) return;
              setState(() => sort = value);
            },
          ),
        ),
        if (app.canManageCatalog)
          OutlinedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/dramaForm'),
            icon: const Icon(Icons.add_rounded),
            label: Text(tx(context, 'Добавить дораму')),
          ),
        const SizedBox(height: 10),
        if (results.isEmpty)
          NestEmptyState(
              icon: Icons.auto_stories_outlined,
              title: tx(context, 'Историй пока нет'),
              message: tx(context, 'Попробуй выбрать другую категорию.')),
        ...results.map((d) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: DramaListTile(
                drama: d,
                onTap: () =>
                    Navigator.pushNamed(context, '/detail', arguments: d.id)))),
        const SizedBox(height: 10),
        Center(
            child: Text(tx(context, 'Ещё больше историй ↘'),
                style: TextStyle(
                    color: context.nestMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w600))),
        const SizedBox(height: 24),
      ])),
    ]);
  }
}

Widget _filterLabel(BuildContext context, String label,
        {bool localize = true}) =>
    Text(
      localize ? tx(context, label) : label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      softWrap: false,
      style: const TextStyle(fontSize: 12),
    );
