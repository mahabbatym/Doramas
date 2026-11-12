import 'package:flutter/material.dart';
import 'package:dorama_nest/core/l10n/generated/app_localizations.dart';
import 'package:dorama_nest/core/locale_text.dart';
import 'package:dorama_nest/core/theme/app_theme.dart';
import 'package:dorama_nest/data/api/api_exception.dart';
import 'package:dorama_nest/state/app_controller.dart';

class LibrarySyncStatus extends StatelessWidget {
  const LibrarySyncStatus({super.key});
  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final l = AppLocalizations.of(context)!;
    final failure = app.accountFailure;
    final text = !app.hasSession ? l.guestLibrary : failure != null
      ? failure == ApiFailureKind.notFound ? l.cloudSetupNeeded : apiStatusText(context, failure, showingSavedData: true)
      : app.pendingCount > 0 ? l.syncPending : app.synchronizing ? l.syncBusy
      : app.realtimeConnected ? l.syncLive : l.syncConnecting;
    return Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: context.nestSoftBlue, child: Row(children: [
        Icon(app.hasSession ? Icons.sync_rounded : Icons.phone_iphone_rounded, size: 18, color: NestColors.blue),
        const SizedBox(width: 9),
        Expanded(child: Text(text, style: Theme.of(context).textTheme.bodySmall, maxLines: 3, overflow: TextOverflow.ellipsis)),
        if (!app.hasSession || failure == ApiFailureKind.unauthorized)
          TextButton(onPressed: () => Navigator.pushNamed(context, '/login'), child: Text(tx(context, 'Вход')))
        else if (failure != null || app.pendingCount > 0 || !app.realtimeConnected)
          IconButton(tooltip: tx(context, 'Қайталау'), onPressed: app.synchronizing ? null : app.retryCloud,
            icon: const Icon(Icons.refresh_rounded, size: 20)),
      ]));
  }
}
