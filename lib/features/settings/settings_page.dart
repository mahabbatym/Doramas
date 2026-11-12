import 'package:dorama_nest/core/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:dorama_nest/core/theme/app_theme.dart';
import 'package:dorama_nest/core/widgets/nest_widgets.dart';
import 'package:dorama_nest/state/app_controller.dart';
import 'package:dorama_nest/core/locale_text.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    return Scaffold(
        appBar: NestBackBar(title: tx(context, 'Настройки')),
        body: ListView(padding: pagePadding, children: [
          const SizedBox(height: 17),
          NestPageTitle(
              title: tx(context, 'Под себя ✦'),
              subtitle: tx(context, 'Дорамы должны приносить только радость.')),
          const SizedBox(height: 30),
          Text(tx(context, 'Предпочтения'),
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 14),
          _SettingsToggle(
              icon: Icons.dark_mode_outlined,
              title: tx(context, 'Тёмная тема'),
              subtitle: tx(context, 'Уютная палитра для вечера'),
              value: app.darkMode,
              onChanged: app.setDarkMode),
          const SizedBox(height: 10),
          _SettingsToggle(
              icon: Icons.notifications_outlined,
              title: tx(context, 'Уведомления'),
              subtitle: tx(context, 'Настройка уведомлений'),
              value: app.notificationsOn,
              onChanged: app.setNotifications),
          const SizedBox(height: 10),
          _SettingsToggle(
              icon: Icons.visibility_off_outlined,
              title: tx(context, 'Показывать спойлеры'),
              subtitle: tx(context, 'Сюжетные секреты под защитой'),
              value: app.showSpoilers,
              onChanged: app.setShowSpoilers),
          const SizedBox(height: 30),
          Text(tx(context, 'О приложении'),
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 13),
          _SettingsInfo(
              icon: Icons.language_rounded,
              title: tx(context, 'Язык интерфейса'),
              subtitle: _languageName(app.language),
              onTap: () => showModalBottomSheet<void>(
                  context: context,
                  builder: (sheetContext) => SafeArea(
                          child:
                              Column(mainAxisSize: MainAxisSize.min, children: [
                        for (final entry in const [
                          ('kk', 'Қазақша'),
                          ('ru', 'Русский'),
                          ('en', 'English'),
                          ('ko', '한국어'),
                        ])
                          ListTile(
                              title: Text(entry.$2),
                              trailing: app.language == entry.$1
                                  ? const Icon(Icons.check,
                                      color: NestColors.blue)
                                  : null,
                              onTap: () {
                                app.setLanguage(entry.$1);
                                Navigator.pop(sheetContext);
                              }),
                      ])))),
          const SizedBox(height: 10),
          _SettingsInfo(
              icon: Icons.info_outline_rounded,
              title: tx(context, 'О DoramaNest'),
              subtitle: tx(context, 'Каталог корейских и китайских дорам'),
              onTap: () => showAboutDialog(
                  context: context,
                  applicationName: 'DoramaNest',
                  applicationVersion: '1.0.0',
                  applicationLegalese:
                      tx(context, 'Каталог корейских и китайских дорам'))),
          const SizedBox(height: 28),
          NestButton(
              label: tx(context, app.hasSession ? 'Выйти из аккаунта' : 'Вход'),
              secondary: true,
              onPressed: () async {
                if (!app.hasSession) { Navigator.pushNamed(context, '/login'); return; }
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    title: Text(tx(context, 'Выйти из аккаунта?')),
                    content: Text(AppLocalizations.of(context)!.logoutInfo),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(dialogContext, false),
                          child: Text(tx(context, 'Отмена'))),
                      TextButton(
                          onPressed: () => Navigator.pop(dialogContext, true),
                          child: Text(tx(context, 'Выйти'))),
                    ],
                  ),
                );
                if (confirm != true || !context.mounted) return;
                try {
                  await app.signOut();
                  if (context.mounted) Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
                } catch (error) {
                  if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(authErrorText(context, error))));
                }
              }),
          const SizedBox(height: 37),
        ]));
  }
}

String _languageName(String language) => switch (language) {
      'kk' => 'Қазақша',
      'en' => 'English',
      'ko' => '한국어',
      _ => 'Русский'
    };

class _SettingsToggle extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _SettingsToggle(
      {required this.icon,
      required this.title,
      required this.subtitle,
      required this.value,
      required this.onChanged});
  @override
  Widget build(BuildContext context) => Container(
      decoration: BoxDecoration(
          color: context.nestSurface, borderRadius: BorderRadius.circular(17)),
      child: SwitchListTile.adaptive(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
        secondary: Icon(icon, color: NestColors.blue),
        title: Text(title, style: Theme.of(context).textTheme.titleMedium),
        subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
        value: value,
        activeThumbColor: NestColors.blue,
        onChanged: onChanged,
      ));
}

class _SettingsInfo extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _SettingsInfo(
      {required this.icon,
      required this.title,
      required this.subtitle,
      required this.onTap});
  @override
  Widget build(BuildContext context) => Material(
      color: context.nestSurface,
      borderRadius: BorderRadius.circular(17),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
        leading: Icon(icon, color: NestColors.blue),
        title: Text(title, style: Theme.of(context).textTheme.titleMedium),
        subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
        trailing: const Icon(Icons.chevron_right, color: NestColors.blue),
      ));
}
