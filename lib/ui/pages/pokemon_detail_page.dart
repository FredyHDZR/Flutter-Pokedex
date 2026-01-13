import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/models/pokemon_detail.dart';
import '../../domain/models/pokemon_sprites.dart';
import '../cubits/pokemon_detail/pokemon_detail_cubit.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart' as app_error;
import '../widgets/pokemon_type_chip.dart';
import '../widgets/pokemon_stat_bar.dart';

class PokemonDetailPage extends StatelessWidget {
  final int pokemonId;

  const PokemonDetailPage({
    required this.pokemonId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<PokemonDetailCubit>()..loadPokemonDetail(pokemonId),
      child: Scaffold(
        body: BlocBuilder<PokemonDetailCubit, PokemonDetailState>(
          builder: (context, state) {
            if (state is PokemonDetailLoading) {
              return const LoadingWidget();
            }

            if (state is PokemonDetailError) {
              return app_error.ErrorWidget(
                message: state.message,
                onRetry: () => context
                    .read<PokemonDetailCubit>()
                    .loadPokemonDetail(pokemonId),
              );
            }

            if (state is PokemonDetailLoaded) {
              return _buildDetailContent(context, state.pokemon);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildDetailContent(BuildContext context, PokemonDetail pokemon) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 200,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              pokemon.name.toUpperCase(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            background: CachedNetworkImage(
              imageUrl: pokemon.sprites.bestImage,
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
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
                subtitle: ability.isHidden
                    ? const Text('Habilidad oculta')
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

