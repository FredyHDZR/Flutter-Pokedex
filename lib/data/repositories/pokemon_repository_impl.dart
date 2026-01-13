import 'package:dartz/dartz.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/error/failure_mapper.dart';
import '../../core/network/network_info.dart';
import '../../domain/models/pokemon.dart';
import '../../domain/models/pokemon_detail.dart';
import '../../domain/repositories/pokemon_repository.dart';
import '../datasources/pokemon_remote_datasource.dart';
import '../datasources/pokemon_local_datasource.dart';

class PokemonRepositoryImpl implements PokemonRepository {
  final PokemonRemoteDataSource remoteDataSource;
  final PokemonLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  PokemonRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

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

        localDataSource.cachePokemonList(remotePokemons).catchError((_) {
          // Error al guardar en caché no debe fallar la operación
        });

        return Right(remotePokemons);
      } on ServerException catch (e) {
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
      return Left(CacheFailure(message: 'Error al leer caché: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, PokemonDetail>> getPokemonDetail({
    required int id,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteDetail = await remoteDataSource.getPokemonDetail(id: id);

        localDataSource.cachePokemonDetail(remoteDetail).catchError((_) {
          // Error al guardar en caché no debe fallar la operación
        });

        return Right(remoteDetail);
      } on ServerException catch (e) {
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
      return Left(CacheFailure(message: 'Error al leer detalle: ${e.toString()}'));
    }
  }
}

