import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_pokedex/core/database/hive_service.dart';
import 'package:flutter_pokedex/core/network/dio_client.dart';
import 'package:flutter_pokedex/core/network/network_info.dart';
import 'package:flutter_pokedex/data/datasources/pokemon_local_datasource.dart';
import 'package:flutter_pokedex/data/datasources/pokemon_remote_datasource.dart';
import 'package:flutter_pokedex/data/repositories/pokemon_repository_impl.dart';
import 'package:flutter_pokedex/domain/repositories/pokemon_repository.dart';
import 'package:flutter_pokedex/ui/cubits/pokemon_detail/pokemon_detail_cubit.dart';
import 'package:flutter_pokedex/ui/cubits/pokemon_list/pokemon_list_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await HiveService.init();

  sl.registerLazySingleton<DioClient>(DioClient.new);

  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(
      connectivity: Connectivity(),
      dio: sl<DioClient>().dio,
    ),
  );

  sl.registerLazySingleton<Box>(
    () => HiveService.pokemonBox,
    instanceName: 'pokemons',
  );

  sl.registerLazySingleton<Box>(
    () => HiveService.pokemonDetailBox,
    instanceName: 'pokemon_details',
  );

  sl.registerLazySingleton<Box>(
    () => HiveService.metadataBox,
    instanceName: 'metadata',
  );

  sl.registerLazySingleton<PokemonRemoteDataSource>(
    () => PokemonRemoteDataSourceImpl(
      dioClient: sl<DioClient>(),
    ),
  );

  sl.registerLazySingleton<PokemonLocalDataSource>(
    () => PokemonLocalDataSourceImpl(
      pokemonBox: sl<Box>(instanceName: 'pokemons'),
      detailBox: sl<Box>(instanceName: 'pokemon_details'),
      metadataBox: sl<Box>(instanceName: 'metadata'),
    ),
  );

  sl.registerLazySingleton<PokemonRepository>(
    () => PokemonRepositoryImpl(
      remoteDataSource: sl<PokemonRemoteDataSource>(),
      localDataSource: sl<PokemonLocalDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  sl.registerFactory<PokemonListCubit>(
    () => PokemonListCubit(
      repository: sl<PokemonRepository>(),
    ),
  );

  sl.registerFactory<PokemonDetailCubit>(
    () => PokemonDetailCubit(
      repository: sl<PokemonRepository>(),
    ),
  );
}
