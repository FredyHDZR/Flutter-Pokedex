import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/error/exceptions.dart';
import '../../domain/models/pokemon.dart';
import '../../domain/models/pokemon_detail.dart';
import '../models/cache_metadata.dart';

abstract class PokemonLocalDataSource {
  Future<List<Pokemon>> getCachedPokemonList({
    required int limit,
    required int offset,
  });

  Future<void> cachePokemonList(List<Pokemon> pokemons);

  Future<PokemonDetail?> getCachedPokemonDetail(int id);

  Future<void> cachePokemonDetail(PokemonDetail detail);

  Future<void> clearCache();

  Future<bool> hasCachedData();
}

class PokemonLocalDataSourceImpl implements PokemonLocalDataSource {
  final Box pokemonBox;
  final Box detailBox;
  final Box metadataBox;

  PokemonLocalDataSourceImpl({
    required this.pokemonBox,
    required this.detailBox,
    required this.metadataBox,
  });

  @override
  Future<List<Pokemon>> getCachedPokemonList({
    required int limit,
    required int offset,
  }) async {
    try {
      final allKeys = pokemonBox.keys.toList()
        ..sort((a, b) {
          final aId = int.tryParse(a.toString()) ?? 0;
          final bId = int.tryParse(b.toString()) ?? 0;
          return aId.compareTo(bId);
        });

      final paginatedKeys = allKeys.skip(offset).take(limit).toList();

      final pokemons = paginatedKeys
          .map((key) {
            final jsonString = pokemonBox.get(key) as String?;
            if (jsonString == null) return null;
            final json = jsonDecode(jsonString) as Map<String, dynamic>;
            return Pokemon.fromJson(json);
          })
          .whereType<Pokemon>()
          .toList();

      return pokemons;
    } catch (e) {
      throw CacheException(message: 'Error al leer caché local: $e');
    }
  }

  @override
  Future<void> cachePokemonList(List<Pokemon> pokemons) async {
    try {
      for (final pokemon in pokemons) {
        await pokemonBox.put(
          pokemon.id.toString(),
          jsonEncode(pokemon.toJson()),
        );
      }

      final metadata = CacheMetadata(
        lastUpdated: DateTime.now(),
        version: '1.0.0',
        totalItems: pokemonBox.length,
        itemTimestamps: {},
      );

      await metadataBox.put(
        'pokemon_list',
        jsonEncode(metadata.toJson()),
      );
    } catch (e) {
      throw CacheException(message: 'Error al guardar en caché: $e');
    }
  }

  @override
  Future<PokemonDetail?> getCachedPokemonDetail(int id) async {
    try {
      final jsonString = detailBox.get(id.toString()) as String?;
      if (jsonString == null) return null;

      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return PokemonDetail.fromJson(json);
    } catch (e) {
      throw CacheException(message: 'Error al leer detalle: $e');
    }
  }

  @override
  Future<void> cachePokemonDetail(PokemonDetail detail) async {
    try {
      await detailBox.put(
        detail.id.toString(),
        jsonEncode(detail.toJson()),
      );

      final metadataJson = metadataBox.get('pokemon_details') as String?;
      if (metadataJson != null) {
        final metadata = CacheMetadata.fromJson(
          jsonDecode(metadataJson) as Map<String, dynamic>,
        );
        final updatedTimestamps = Map<String, DateTime>.from(
          metadata.itemTimestamps,
        );
        updatedTimestamps[detail.id.toString()] = DateTime.now();

        final updatedMetadata = CacheMetadata(
          lastUpdated: metadata.lastUpdated,
          version: metadata.version,
          totalItems: detailBox.length,
          itemTimestamps: updatedTimestamps,
        );

        await metadataBox.put(
          'pokemon_details',
          jsonEncode(updatedMetadata.toJson()),
        );
      } else {
        final newMetadata = CacheMetadata(
          lastUpdated: DateTime.now(),
          version: '1.0.0',
          totalItems: detailBox.length,
          itemTimestamps: {detail.id.toString(): DateTime.now()},
        );

        await metadataBox.put(
          'pokemon_details',
          jsonEncode(newMetadata.toJson()),
        );
      }
    } catch (e) {
      throw CacheException(message: 'Error al guardar detalle: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    await pokemonBox.clear();
    await detailBox.clear();
    await metadataBox.clear();
  }

  @override
  Future<bool> hasCachedData() async {
    return pokemonBox.isNotEmpty || detailBox.isNotEmpty;
  }
}

