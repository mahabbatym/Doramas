# Production upgrade plan

Baseline: existing Flutter/ChangeNotifier app, SQLite v6, PostgREST catalog,
four ARB locales, iOS runner using Swift Package Manager. Preserve architecture,
palette, local data and the user's existing analyzer/Xcode/Android changes.

1. Audit configuration, actual public Supabase endpoints, schema and SDK APIs.
2. Replace simulated login with email/password Auth, confirmation, recovery,
   persistent sessions and linked profiles. Remove automatic anonymous signup.
3. Add additive SQL migrations for progress, preferences, community reviews,
   RLS, indexes, Realtime and atomic catalog writes. Never apply unverified DDL
   against an unknown live schema.
4. Isolate cached account data and offline mutations by user ID. Reconcile on
   reconnect, foreground and subscription rejoin; clean up all listeners.
5. Add DORAMA DNA using genre metadata, explicit preferences, favorites,
   ratings and watching/completed/dropped history. Document the score formula.
6. Localize new and previously incomplete UI in kk/ru/en/ko. Preserve kk default.
7. Replace onboarding placeholders with original bundled artwork, improve
   poster error states without substituting unrelated images.
8. Fix navigation, search, progress and responsive layout issues. Validate
   authentication, account isolation, synchronization, recommendations and UI.
9. Rewrite README, backend setup, media provenance and final verification report.
10. Run dependency resolution, formatting, analyzer, tests and iOS build;
    explicitly record external blockers and unverified device/backend behavior.

Initial findings: login/register only set local flags; automatic anonymous
Auth is disabled in the configured project; account cache/outbox keys are
global; progress and reviews are local; no Realtime; translated genre labels
break filtering; missing Korean error translations; catalog CRUD spans
multiple non-atomic requests; clearing search can leave a spinner running;
detail routes silently substitute an unrelated drama when an ID is absent.
