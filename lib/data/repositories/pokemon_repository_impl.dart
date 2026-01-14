import 'package:dartz/dartz.dart';
import 'package:flutter_pokedex/core/error/exceptions.dart';
import 'package:flutter_pokedex/core/error/failure_mapper.dart';
import 'package:flutter_pokedex/core/error/failures.dart';
import 'package:flutter_pokedex/core/network/network_info.dart';
import 'package:flutter_pokedex/data/datasources/pokemon_local_datasource.dart';
import 'package:flutter_pokedex/data/datasources/pokemon_remote_datasource.dart';
import 'package:flutter_pokedex/domain/models/pokemon.dart';
import 'package:flutter_pokedex/domain/models/pokemon_detail.dart';
import 'package:flutter_pokedex/domain/repositories/pokemon_repository.dart';

class PokemonRepositoryImpl implements PokemonRepository {
  PokemonRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  final PokemonRemoteDataSource remoteDataSource;
  final PokemonLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, List<Pokemon>>> getPokemonList({
    required int limit,
    required int offset,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remotePokemons = await remoteDataSource.getPokemonList(
          limit: limit,
          offset: offset,
        );

        await localDataSource
            .cachePokemonList(remotePokemons)
            .catchError((_) => null);

        return Right(remotePokemons);
      } on ServerException {
        return _getFromCache(limit: limit, offset: offset);
      } catch (e) {
        return Left(FailureMapper.mapExceptionToFailure(e as Exception));
      }
    } else {
      return _getFromCache(limit: limit, offset: offset);
    }
  }

  Future<Either<Failure, List<Pokemon>>> _getFromCache({
    required int limit,
    required int offset,
  }) async {
    try {
      final cachedPokemons = await localDataSource.getCachedPokemonList(
        limit: limit,
        offset: offset,
      );

      if (cachedPokemons.isEmpty) {
        return Left(CacheFailure(message: 'No hay datos en caché'));
      }

      return Right(cachedPokemons);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(
        CacheFailure(message: 'Error al leer caché: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Either<Failure, PokemonDetail>> getPokemonDetail({
    required int id,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteDetail = await remoteDataSource.getPokemonDetail(id: id);

        await localDataSource
            .cachePokemonDetail(remoteDetail)
            .catchError((_) => null);

        return Right(remoteDetail);
      } on ServerException {
        return _getDetailFromCache(id: id);
      } catch (e) {
        return Left(FailureMapper.mapExceptionToFailure(e as Exception));
      }
    } else {
      return _getDetailFromCache(id: id);
    }
  }

  Future<Either<Failure, PokemonDetail>> _getDetailFromCache({
    required int id,
  }) async {
    try {
      final cachedDetail = await localDataSource.getCachedPokemonDetail(id);

      if (cachedDetail == null) {
        return Left(CacheFailure(message: 'Pokémon no encontrado en caché'));
      }

      return Right(cachedDetail);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e) {
      return Left(
        CacheFailure(message: 'Error al leer detalle: ${e.toString()}'),
      );
    }
  }
}
