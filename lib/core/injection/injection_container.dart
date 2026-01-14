import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../network/dio_client.dart';
import '../network/network_info.dart';
import '../database/hive_service.dart';
import '../../data/datasources/pokemon_remote_datasource.dart';
import '../../data/datasources/pokemon_local_datasource.dart';
import '../../data/repositories/pokemon_repository_impl.dart';
import '../../domain/repositories/pokemon_repository.dart';
import '../../ui/cubits/pokemon_list/pokemon_list_cubit.dart';
import '../../ui/cubits/pokemon_detail/pokemon_detail_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await HiveService.init();

  sl.registerLazySingleton<DioClient>(() => DioClient());

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

