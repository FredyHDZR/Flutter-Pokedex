import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/injection/injection_container.dart' as di;
import 'ui/routes/app_router.dart';
import 'ui/cubits/pokemon_list/pokemon_list_cubit.dart';
import 'ui/cubits/pokemon_detail/pokemon_detail_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<PokemonListCubit>(),
        ),
        BlocProvider(
          create: (_) => di.sl<PokemonDetailCubit>(),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: appRouter,
        title: 'Pokédex',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
      ),
    );
  }
}
