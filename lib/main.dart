import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'generated/l10n.dart';
import 'core/ui/ui_provider.dart';
import 'home/language/bloc/app_locale_bloc.dart';
import 'home/language/bloc/app_locale_state.dart';
import 'injection.dart';
import 'navigation/main_navigation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await configureDependencies();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase init error: $e');
  }
  runApp(
    ChangeNotifierProvider(create: (_) => UiProvider(), child: const MyApp()),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AppLocaleBloc _appBloc;

  @override
  void initState() {
    super.initState();
    _appBloc = getIt<AppLocaleBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppLocaleBloc, AppLocaleState>(
      bloc: _appBloc,
      builder: (context, localeState) {
        return MaterialApp(
          title: 'Crypto Assistant',
          debugShowCheckedModeBanner: false,
          locale: localeState.locale,
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          builder: (context, child) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) {
                context.read<UiProvider>().updateLayout(context);
              }
            });
            return child!;
          },
          home: const MainNavigationScreen(),
        );
      },
    );
  }
}
