import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../cubits/pokemon_list/pokemon_list_cubit.dart';
import '../widgets/pokemon_card.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart' as app_error;

class PokemonListPage extends StatefulWidget {
  const PokemonListPage({super.key});

  @override
  State<PokemonListPage> createState() => _PokemonListPageState();
}

class _PokemonListPageState extends State<PokemonListPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
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
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => context.read<PokemonListCubit>()..loadPokemons(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pokédex'),
        ),
        body: BlocBuilder<PokemonListCubit, PokemonListState>(
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

            return GridView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.75,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: state.pokemons.length + (state.isLoadingMore ? 1 : 0),
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
          }

          return const SizedBox.shrink();
        },
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

