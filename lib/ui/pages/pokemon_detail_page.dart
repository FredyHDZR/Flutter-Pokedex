import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pokedex/core/theme/app_theme.dart';
import 'package:flutter_pokedex/domain/models/pokemon_detail.dart';
import 'package:flutter_pokedex/domain/models/pokemon_sprites.dart';
import 'package:flutter_pokedex/ui/cubits/pokemon_detail/pokemon_detail_cubit.dart';
import 'package:flutter_pokedex/ui/widgets/error_widget.dart' as app_error;
import 'package:flutter_pokedex/ui/widgets/loading_widget.dart';
import 'package:flutter_pokedex/ui/widgets/pokemon_stat_bar.dart';
import 'package:flutter_pokedex/ui/widgets/pokemon_type_chip.dart';

class PokemonDetailPage extends StatelessWidget {

  const PokemonDetailPage({
    required this.pokemonId,
    super.key,
  });
  
  final int pokemonId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<PokemonDetailCubit>()..loadPokemonDetail(pokemonId),
      child: Scaffold(
        body: BlocBuilder<PokemonDetailCubit, PokemonDetailState>(
          builder: (context, state) {
            if (state is PokemonDetailLoading) {
              return Container(
                decoration: const BoxDecoration(
                  gradient: AppTheme.backgroundGradient,
                ),
                child: const LoadingWidget(),
              );
            }

            if (state is PokemonDetailError) {
              return Container(
                decoration: const BoxDecoration(
                  gradient: AppTheme.backgroundGradient,
                ),
                child: app_error.ErrorWidget(
                  message: state.message,
                  onRetry: () => context
                      .read<PokemonDetailCubit>()
                      .loadPokemonDetail(pokemonId),
                ),
              );
            }

            if (state is PokemonDetailLoaded) {
              return _buildDetailContent(context, state.pokemon);
            }

            return Container(
              decoration: const BoxDecoration(
                gradient: AppTheme.backgroundGradient,
              ),
              child: const SizedBox.shrink(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDetailContent(BuildContext context, PokemonDetail pokemon) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppTheme.backgroundGradient,
      ),
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                final isCollapsed =
                    constraints.biggest.height <= kToolbarHeight;
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    FlexibleSpaceBar(
                      title: Text(
                        pokemon.name.toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          CachedNetworkImage(
                            imageUrl: pokemon.sprites.bestImage,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.3),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isCollapsed)
                      ClipRRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoSection(context, pokemon),
                  const SizedBox(height: 24),
                  _buildTypesSection(context, pokemon),
                  const SizedBox(height: 24),
                  _buildStatsSection(context, pokemon),
                  const SizedBox(height: 24),
                  _buildAbilitiesSection(context, pokemon),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, PokemonDetail pokemon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Información',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoItem(
                  context,
                  'Altura',
                  '${pokemon.heightInMeters.toStringAsFixed(1)} m',
                  Icons.height,
                ),
                _buildInfoItem(
                  context,
                  'Peso',
                  '${pokemon.weightInKilograms.toStringAsFixed(1)} kg',
                  Icons.monitor_weight,
                ),
                _buildInfoItem(
                  context,
                  'Experiencia',
                  pokemon.baseExperience.toString(),
                  Icons.star,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildTypesSection(BuildContext context, PokemonDetail pokemon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tipos',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: pokemon.types
                .map((type) => PokemonTypeChip(pokemonType: type))
                .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context, PokemonDetail pokemon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Estadísticas',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ...pokemon.stats.map((stat) => PokemonStatBar(stat: stat)),
          ],
        ),
      ),
    );
  }

  Widget _buildAbilitiesSection(BuildContext context, PokemonDetail pokemon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Habilidades',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ...pokemon.abilities.map(
              (ability) => ListTile(
                leading: Icon(
                  ability.isHidden ? Icons.visibility_off : Icons.visibility,
                ),
                title: Text(
                  ability.ability.name.toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle:
                    ability.isHidden ? const Text('Habilidad oculta') : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
