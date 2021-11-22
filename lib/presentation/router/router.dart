import 'package:auto_route/annotations.dart';
import 'package:try_ddd/presentation/note_overview/notes_overview_page.dart';
import 'package:try_ddd/presentation/sign_in/sign_in_page.dart';
import 'package:try_ddd/presentation/splash/splash_page.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    MaterialRoute(page: SplashPage, initial: true),
    MaterialRoute(page: SignInPage),
    MaterialRoute(page: NotesOverviewPage),
    // MaterialRoute(page: NoteFormPage, fullscreenDialog: true),
  ],
)
class $Router {}
