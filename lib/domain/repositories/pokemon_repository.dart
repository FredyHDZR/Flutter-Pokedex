import 'package:dartz/dartz.dart';
import '../models/pokemon.dart';
import '../models/pokemon_detail.dart';
import '../../core/error/failures.dart';

abstract class PokemonRepository {
  Future<Either<Failure, List<Pokemon>>> getPokemonList({
    required int limit,
    required int offset,
  });

  Future<Either<Failure, PokemonDetail>> getPokemonDetail({
    required int id,
  });
}

