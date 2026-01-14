import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pokedex/core/injection/injection_container.dart' as di;
import 'package:flutter_pokedex/core/theme/app_theme.dart';
import 'package:flutter_pokedex/ui/cubits/pokemon_detail/pokemon_detail_cubit.dart';
import 'package:flutter_pokedex/ui/cubits/pokemon_list/pokemon_list_cubit.dart';
import 'package:flutter_pokedex/ui/routes/app_router.dart';

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
        theme: AppTheme.theme,
      ),
    );
  }
}
