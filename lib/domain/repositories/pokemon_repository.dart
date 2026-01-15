import 'package:dartz/dartz.dart';
import 'package:flutter_pokedex/core/error/failures.dart';
import 'package:flutter_pokedex/domain/models/pokemon.dart';
import 'package:flutter_pokedex/domain/models/pokemon_detail.dart';

abstract class PokemonRepository {
  Future<Either<Failure, List<Pokemon>>> getPokemonList({
    required int limit,
    required int offset,
  });

  Future<Either<Failure, PokemonDetail>> getPokemonDetail({
    required int id,
  });
}
