import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/locator.dart';
import 'widgets/main_navigation_bar.dart';
import 'feature/player/domain/bloc.dart';
import 'feature/favorites/domain/bloc.dart';
import 'feature/playlist/domain/bloc.dart';
import 'feature/search/domain/bloc.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await registerAppDependencies();

      runApp(const MyApp());
    },
    (Object error, StackTrace stack) async {},
    zoneSpecification: const ZoneSpecification(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PlayerBloc>(
          create: (context) => instanceOf(),
        ),
        BlocProvider<FavoritesBloc>(
          create: (context) => instanceOf(),
        ),
        BlocProvider<PlaylistBloc>(
          create: (context) => instanceOf(),
        ),
        BlocProvider<SearchBloc>(
          create: (context) => instanceOf(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 255, 255, 255)),
          scaffoldBackgroundColor: Colors.transparent,
        ),
        home: const MainNavigationScreen(),
      ),
    );
  }
}
