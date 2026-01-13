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
  final PokemonDetail pokemon;

  const PokemonDetailLoaded({required this.pokemon});

  @override
  List<Object?> get props => [pokemon];
}

class PokemonDetailError extends PokemonDetailState {
  final String message;

  const PokemonDetailError({required this.message});

  @override
  List<Object?> get props => [message];
}

