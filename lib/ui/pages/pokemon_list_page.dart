import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/breakpoints.dart';
import '../../core/theme/app_theme.dart';
import '../cubits/pokemon_list/pokemon_list_cubit.dart';
import '../widgets/pokemon_card.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart' as app_error;
import '../widgets/blur_app_bar.dart';

class PokemonListPage extends StatefulWidget {
  const PokemonListPage({super.key});

  @override
  State<PokemonListPage> createState() => _PokemonListPageState();
}

class _PokemonListPageState extends State<PokemonListPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // Detectar scroll para paginación
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      final cubit = context.read<PokemonListCubit>();
      final state = cubit.state;

      if (state is PokemonListLoaded &&
          state.hasMore &&
          !state.isLoadingMore) {
        cubit.loadMorePokemons();
      }
    }

    // Detectar scroll para blur del AppBar
    final newIsScrolled = _scrollController.position.pixels > 0;
    if (newIsScrolled != _isScrolled) {
      setState(() {
        _isScrolled = newIsScrolled;
      });
    }
  }

  int _calculateCrossAxisCount(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (kIsWeb) {
      // En web: 5 columnas para pantallas grandes, 3 para pequeñas
      return screenWidth >= Breakpoints.tablet ? 5 : 3;
    }

    // En móvil: siempre 3 columnas
    return 3;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => context.read<PokemonListCubit>()..loadPokemons(),
      child: Scaffold(
        appBar: BlurAppBar(
          title: 'Pokédex',
          isScrolled: _isScrolled,
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.backgroundGradient,
          ),
          child: BlocBuilder<PokemonListCubit, PokemonListState>(
        builder: (context, state) {
          if (state is PokemonListLoading) {
            return const LoadingWidget();
          }

          if (state is PokemonListError) {
            return app_error.ErrorWidget(
              message: state.message,
              onRetry: () => context.read<PokemonListCubit>().loadPokemons(),
            );
          }

          if (state is PokemonListLoaded) {
            if (state.pokemons.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.inbox, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      'No hay Pokémon disponibles',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              );
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = _calculateCrossAxisCount(context);

                return GridView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount:
                      state.pokemons.length + (state.isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= state.pokemons.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    return PokemonCard(
                      pokemon: state.pokemons[index],
                      onTap: () {
                        context.push('/pokemon/${state.pokemons[index].id}');
                      },
                    );
                  },
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

