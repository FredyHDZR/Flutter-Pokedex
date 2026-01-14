import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pokedex/core/error/failures.dart';
import 'package:flutter_pokedex/domain/models/pokemon_detail.dart';
import 'package:flutter_pokedex/domain/repositories/pokemon_repository.dart';

part 'pokemon_detail_state.dart';

class PokemonDetailCubit extends Cubit<PokemonDetailState> {
  PokemonDetailCubit({required this.repository})
      : super(PokemonDetailInitial());

  final PokemonRepository repository;

  Future<void> loadPokemonDetail(int id) async {
    emit(PokemonDetailLoading());

    try {
      final result = await repository.getPokemonDetail(id: id);

      result.fold(
        (failure) => emit(
          PokemonDetailError(
            message: _mapFailureToMessage(failure),
          ),
        ),
        (pokemon) => emit(PokemonDetailLoaded(pokemon: pokemon)),
      );
    } catch (e) {
      emit(
        PokemonDetailError(
          message: 'Error inesperado: ${e.toString()}',
        ),
      );
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure _:
        return 'Error del servidor. Intenta de nuevo.';
      case NetworkFailure _:
        return 'Sin conexión a internet.';
      case CacheFailure _:
        return 'Error al cargar datos guardados.';
      case NotFoundFailure _:
        return 'Pokémon no encontrado.';
      default:
        return 'Error inesperado.';
    }
  }
}
