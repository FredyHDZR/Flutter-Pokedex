part of 'pokemon_detail_cubit.dart';

abstract class PokemonDetailState extends Equatable {
  const PokemonDetailState();
}

class PokemonDetailInitial extends PokemonDetailState {
  @override
  List<Object?> get props => [];
}

class PokemonDetailLoading extends PokemonDetailState {
  @override
  List<Object?> get props => [];
}

class PokemonDetailLoaded extends PokemonDetailState {

  const PokemonDetailLoaded({required this.pokemon});
  final PokemonDetail pokemon;

  @override
  List<Object?> get props => [pokemon];
}

class PokemonDetailError extends PokemonDetailState {

  const PokemonDetailError({required this.message});
  final String message;

  @override
  List<Object?> get props => [message];
}
