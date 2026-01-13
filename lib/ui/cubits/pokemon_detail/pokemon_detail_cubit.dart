import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/models/pokemon_detail.dart';
import '../../../domain/repositories/pokemon_repository.dart';
import '../../../core/error/failures.dart';

part 'pokemon_detail_state.dart';

class PokemonDetailCubit extends Cubit<PokemonDetailState> {
  final PokemonRepository repository;

  PokemonDetailCubit({required this.repository})
      : super(PokemonDetailInitial());

  Future<void> loadPokemonDetail(int id) async {
    emit(PokemonDetailLoading());

    try {
      final result = await repository.getPokemonDetail(id: id);

      result.fold(
        (failure) => emit(PokemonDetailError(
          message: _mapFailureToMessage(failure),
        )),
        (pokemon) => emit(PokemonDetailLoaded(pokemon: pokemon)),
      );
    } catch (e) {
      emit(PokemonDetailError(
        message: 'Error inesperado: ${e.toString()}',
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
      case NotFoundFailure:
        return 'Pokémon no encontrado.';
      default:
        return 'Error inesperado.';
    }
  }
}

