import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/models/pokemon.dart';
import '../../../domain/repositories/pokemon_repository.dart';
import '../../../core/error/failures.dart';
import '../../../core/constants/app_constants.dart';

part 'pokemon_list_state.dart';

class PokemonListCubit extends Cubit<PokemonListState> {
  final PokemonRepository repository;

  PokemonListCubit({required this.repository}) : super(PokemonListInitial());

  Future<void> loadPokemons({bool refresh = false}) async {
    if (refresh) {
      emit(PokemonListLoading());
    } else if (state is PokemonListLoaded) {
      final currentState = state as PokemonListLoaded;
      emit(currentState.copyWith(isRefreshing: true));
    } else {
      emit(PokemonListLoading());
    }

    try {
      final result = await repository.getPokemonList(
        limit: AppConstants.defaultPokemonLimit,
        offset: 0,
      );

      result.fold(
        (failure) => emit(PokemonListError(
          message: _mapFailureToMessage(failure),
        )),
        (pokemons) => emit(PokemonListLoaded(
          pokemons: pokemons,
          hasMore: pokemons.length == AppConstants.defaultPokemonLimit,
          currentOffset: pokemons.length,
          limit: AppConstants.defaultPokemonLimit,
        )),
      );
    } catch (e) {
      emit(PokemonListError(
        message: 'Error inesperado: ${e.toString()}',
      ));
    }
  }

  Future<void> loadMorePokemons() async {
    final currentState = state;
    if (currentState is! PokemonListLoaded ||
        currentState.isLoadingMore ||
        !currentState.hasMore) {
      return;
    }

    emit(currentState.copyWith(isLoadingMore: true));

    try {
      final result = await repository.getPokemonList(
        limit: currentState.limit,
        offset: currentState.currentOffset,
      );

      result.fold(
        (failure) => emit(PokemonListError(
          message: _mapFailureToMessage(failure),
        )),
        (newPokemons) {
          final updatedPokemons = [
            ...currentState.pokemons,
            ...newPokemons,
          ];

          emit(currentState.copyWith(
            pokemons: updatedPokemons,
            isLoadingMore: false,
            currentOffset: currentState.currentOffset + newPokemons.length,
            hasMore: newPokemons.length == currentState.limit,
          ));
        },
      );
    } catch (e) {
      emit(PokemonListError(
        message: 'Error al cargar más: ${e.toString()}',
      ));
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Error del servidor. Intenta de nuevo.';
      case NetworkFailure:
        return 'Sin conexión a internet.';
      case CacheFailure:
        return 'Error al cargar datos guardados.';
      default:
        return 'Error inesperado.';
    }
  }
}

