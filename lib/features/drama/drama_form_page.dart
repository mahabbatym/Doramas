import 'package:dorama_nest/core/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:dorama_nest/core/locale_text.dart';
import 'package:dorama_nest/core/validators.dart';
import 'package:dorama_nest/core/widgets/nest_widgets.dart';
import 'package:dorama_nest/data/models/drama.dart';
import 'package:dorama_nest/state/app_controller.dart';
import 'package:dorama_nest/data/api/api_exception.dart';

class DramaFormPage extends StatefulWidget {
  final String? dramaId;
  const DramaFormPage({super.key, this.dramaId});

  @override
  State<DramaFormPage> createState() => _DramaFormPageState();
}

class _DramaFormPageState extends State<DramaFormPage> {
  final _form = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _original = TextEditingController();
  final _year = TextEditingController();
  final _episodes = TextEditingController();
  final _rating = TextEditingController();
  final _description = TextEditingController();
  final _posterUrl = TextEditingController();
  final _backdropUrl = TextEditingController();
  final _localizedTitles = {
    'kk': TextEditingController(),
    'ru': TextEditingController(),
    'en': TextEditingController(),
    'ko': TextEditingController(),
  };
  final _localizedDescriptions = {
    'kk': TextEditingController(),
    'ru': TextEditingController(),
    'en': TextEditingController(),
    'ko': TextEditingController(),
  };
  String _country = 'Корея';
  String _genre = 'Романтика';
  String _status = 'released';
  bool _busy = false;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _rating.text = '0.0';
  }

  String? _validateImageUrl(BuildContext context, String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final uri = Uri.tryParse(value.trim());
    return uri == null || uri.scheme != 'https' || uri.host.isEmpty
        ? tx(context, 'Суреттің HTTPS сілтемесін енгізіңіз')
        : null;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loaded) return;
    _loaded = true;
    final app = AppScope.of(context);
    final drama = app.dramas.where((d) => d.id == widget.dramaId).firstOrNull;
    if (drama != null) {
      _title.text = drama.title;
      _original.text = drama.originalTitle;
      _year.text = '${drama.year}';
      _episodes.text = '${drama.episodes}';
      _rating.text = drama.score.toStringAsFixed(1);
      _description.text = drama.description;
      _posterUrl.text = drama.posterUrl ?? '';
      _backdropUrl.text = drama.backdropUrl ?? '';
      _country = drama.country;
      _genre = switch (drama.genreKeys.first) {
        'romance' => 'Романтика', 'comedy' => 'Комедия', 'fantasy' => 'Фэнтези',
        'music' => 'Музыка', 'mystery' => 'Детектив', _ => 'Драма',
      };
      _status = drama.status;
      for (final locale in const ['kk', 'ru', 'en', 'ko']) {
        final translation = drama.translations[locale];
        _localizedTitles[locale]!.text = translation?['title'] ?? '';
        _localizedDescriptions[locale]!.text = translation?['description'] ?? '';
      }
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _original.dispose();
    _year.dispose();
    _episodes.dispose();
    _rating.dispose();
    _description.dispose();
    _posterUrl.dispose();
    _backdropUrl.dispose();
    for (final controller in _localizedTitles.values) {
      controller.dispose();
    }
    for (final controller in _localizedDescriptions.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    final app = AppScope.of(context);
    final year = int.parse(_year.text);
    final episodes = int.parse(_episodes.text);
    final rating = double.tryParse(_rating.text) ?? 0;
    if (episodes < 1 || episodes > 500) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(tx(context, 'Укажи от 1 до 500 серий.'))));
      return;
    }
    final old = AppScope.of(context)
        .dramas
        .where((d) => d.id == widget.dramaId)
        .firstOrNull;
    final id = old?.id ?? 'local-${DateTime.now().microsecondsSinceEpoch}';
    final colors = old ??
        Drama(
            id: id,
            title: '',
            originalTitle: '',
            country: _country,
            year: year,
            genre: _genre,
        genreSlugs: old != null && genreKey(old.genre) == genreKey(_genre) ? old.genreSlugs : [genreKey(_genre)],
            episodes: episodes,
            score: 0,
            description: '',
            symbol: '✿',
            start: const Color(0xFFEDAAB1),
            end: const Color(0xFF925A8A));
    final translations = app.cloudConfigured
        ? {
            for (final locale in const ['kk', 'ru', 'en', 'ko'])
              if (_localizedTitles[locale]!.text.trim().isNotEmpty) locale: {
                'title': _localizedTitles[locale]!.text.trim(),
                'description': _localizedDescriptions[locale]!.text.trim(),
              },
          }
        : {
            app.language: {
              'title': _title.text.trim(),
              'description': _description.text.trim(),
            },
          };
    if (translations.isEmpty) return;
    final activeTranslation = translations[app.language] ?? translations['en'] ?? translations.values.first;
    setState(() => _busy = true);
    try {
      await app.saveDrama(Drama(
        id: id,
        title: app.cloudConfigured
            ? activeTranslation['title']!
            : _title.text.trim(),
        originalTitle: _original.text.trim().isEmpty
            ? (app.cloudConfigured
                ? activeTranslation['title']!
                : _title.text.trim())
            : _original.text.trim(),
        country: _country,
        year: year,
        genre: _genre,
        genreSlugs: old != null && genreKey(old.genre) == genreKey(_genre) ? old.genreSlugs : [genreKey(_genre)],
        episodes: episodes,
        status: _status,
        score: rating,
        description: app.cloudConfigured
            ? activeTranslation['description']!
            : _description.text.trim(),
        posterUrl:
            _posterUrl.text.trim().isEmpty ? null : _posterUrl.text.trim(),
        backdropUrl:
            _backdropUrl.text.trim().isEmpty ? null : _backdropUrl.text.trim(),
        translations: translations,
        symbol: colors.symbol,
        start: colors.start,
        end: colors.end,
        isCustom: true,
      ));
      if (mounted) Navigator.pop(context);
    } catch (error) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(error is ApiException
                ? apiStatusText(context, error.kind,
                    showingSavedData: AppScope.of(context).showingSavedData)
                : tx(context, 'Не удалось сохранить'))));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!AppScope.of(context).canManageCatalog) {
      return Scaffold(
        appBar: NestBackBar(title: tx(context, 'Добавить дораму')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(apiStatusText(context, ApiFailureKind.forbidden,
                showingSavedData: false)),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: NestBackBar(
          title: tx(context,
              widget.dramaId == null ? 'Новая дорама' : 'Изменить дораму')),
      body: Form(
          key: _form,
          child: ListView(
              padding: const EdgeInsets.fromLTRB(23, 20, 23, 32),
              children: [
                NestPageTitle(
                    title: tx(context, widget.dramaId == null ? 'Добавь историю ✧' : 'Обнови детали ✎'),
                    subtitle: AppScope.of(context).cloudConfigured ? AppLocalizations.of(context)!.catalogSavedCloud : tx(context, 'Запись будет сохранена на этом устройстве.')),
                const SizedBox(height: 22),
                if (!AppScope.of(context).cloudConfigured)
                  NestField(
                      label: tx(context, 'Название'),
                      hint: tx(context, 'Например, My Lovely Runner'),
                      controller: _title,
                      validator: (v) {
                        final error =
                            NestValidators.requiredText(v, name: 'Название');
                        return error == null ? null : tx(context, error);
                      }),
                const SizedBox(height: 15),
                NestField(
                    label: tx(context, 'Оригинальное название'),
                    hint: tx(context, 'Необязательно'),
                    controller: _original),
                const SizedBox(height: 15),
                if (AppScope.of(context).cloudConfigured) ...[
                  for (final locale in const ['kk', 'ru', 'en', 'ko']) ...[
                    NestField(
                      label: localizedDramaFieldLabel(context,
                          locale: locale, description: false),
                      hint: tx(context, 'Например, My Lovely Runner'),
                      controller: _localizedTitles[locale]!,
                      validator: (value) =>
                          locale == 'en' && (value == null || value.trim().isEmpty)
                              ? tx(context, 'Это поле обязательно')
                              : null,
                    ),
                    const SizedBox(height: 12),
                    NestField(
                      label: localizedDramaFieldLabel(context,
                          locale: locale, description: true),
                      hint: tx(context, 'О чём эта история?'),
                      controller: _localizedDescriptions[locale]!,
                      maxLines: 3,
                      validator: (value) =>
                          locale == 'en' && (value == null || value.trim().isEmpty)
                              ? tx(context, 'Это поле обязательно')
                              : null,
                    ),
                    const SizedBox(height: 15),
                  ],
                ],
                Row(children: [
                  Expanded(
                      child: DropdownButtonFormField<String>(
                          initialValue: _country,
                          decoration:
                              InputDecoration(labelText: tx(context, 'Страна')),
                          items: [
                            DropdownMenuItem(
                                value: 'Корея',
                                child: Text(tx(context, 'Корея'))),
                            DropdownMenuItem(
                                value: 'Китай',
                                child: Text(tx(context, 'Китай')))
                          ],
                          onChanged: (v) =>
                              setState(() => _country = v ?? _country))),
                  const SizedBox(width: 12),
                  Expanded(
                      child: DropdownButtonFormField<String>(
                          initialValue: _genre,
                          decoration:
                              InputDecoration(labelText: tx(context, 'Жанр')),
                          items: [
                            'Романтика',
                            'Комедия',
                            'Фэнтези',
                            'Музыка',
                            'Драма',
                            'Детектив'
                          ]
                              .map((v) => DropdownMenuItem(
                                  value: v, child: Text(tx(context, v))))
                              .toList(),
                          onChanged: (v) =>
                              setState(() => _genre = v ?? _genre))),
                ]),
                const SizedBox(height: 15),
                Row(children: [
                  Expanded(
                      child: NestField(
                          label: tx(context, 'Год'),
                          hint: '${DateTime.now().year}',
                          controller: _year,
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            final n = int.tryParse(v ?? '');
                            return n == null ||
                                    n < 1900 ||
                                    n > DateTime.now().year + 2
                                ? tx(context, 'Укажи корректный год')
                                : null;
                          })),
                  const SizedBox(width: 12),
                  Expanded(
                      child: NestField(
                          label: tx(context, 'Серий'),
                          hint: '16',
                          controller: _episodes,
                          keyboardType: TextInputType.number,
                          validator: (v) => int.tryParse(v ?? '') == null
                              ? tx(context, 'Нужно число')
                              : null)),
                ]),
                const SizedBox(height: 15),
                Row(children: [
                  Expanded(
                    child: NestField(
                      label: tx(context, 'Рейтинг'),
                      hint: '0–10',
                      controller: _rating,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        final number = double.tryParse(value ?? '');
                        return number == null || !number.isFinite || number < 0 || number > 10
                            ? tx(context, 'Укажи рейтинг от 0 до 10')
                            : null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _status,
                      decoration:
                          InputDecoration(labelText: tx(context, 'Статус')),
                      items: const [
                        'announced',
                        'ongoing',
                        'completed',
                        'released',
                        'hiatus',
                      ]
                          .map((status) => DropdownMenuItem(
                                value: status,
                                child: Text(dramaStatusLabel(context, status)),
                              ))
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _status = value ?? _status),
                    ),
                  ),
                ]),
                const SizedBox(height: 15),
                if (!AppScope.of(context).cloudConfigured)
                  NestField(
                      label: tx(context, 'Краткое описание'),
                      hint: tx(context, 'О чём эта история?'),
                      controller: _description,
                      maxLines: 4,
                      validator: (v) {
                        final error =
                            NestValidators.requiredText(v, name: 'Описание');
                        return error == null ? null : tx(context, error);
                      }),
                if (AppScope.of(context).cloudConfigured) ...[
                  NestField(
                    label: tx(context, 'URL постера'),
                    hint: 'https://…',
                    controller: _posterUrl,
                    keyboardType: TextInputType.url,
                    validator: (value) => _validateImageUrl(context, value),
                  ),
                  const SizedBox(height: 12),
                  NestField(
                    label: tx(context, 'URL обложки'),
                    hint: 'https://…',
                    controller: _backdropUrl,
                    keyboardType: TextInputType.url,
                    validator: (value) => _validateImageUrl(context, value),
                  ),
                ],
                const SizedBox(height: 24),
                NestButton(
                    label: tx(context,
                        _busy ? 'Сохраняем…' : 'Сохранить в библиотеку →'),
                    onPressed: _busy ? null : _save),
              ])),
    );
  }
}
