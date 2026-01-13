part of 'pokemon_list_cubit.dart';

abstract class PokemonListState extends Equatable {
  const PokemonListState();

  @override
  List<Object?> get props => [];
}

class PokemonListInitial extends PokemonListState {}

class PokemonListLoading extends PokemonListState {}

class PokemonListLoaded extends PokemonListState {
  final List<Pokemon> pokemons;
  final bool hasMore;
  final bool isLoadingMore;
  final bool isRefreshing;
  final int currentOffset;
  final int limit;

  const PokemonListLoaded({
    required this.pokemons,
    required this.hasMore,
    this.isLoadingMore = false,
    this.isRefreshing = false,
    required this.currentOffset,
    required this.limit,
  });

  PokemonListLoaded copyWith({
    List<Pokemon>? pokemons,
    bool? hasMore,
    bool? isLoadingMore,
    bool? isRefreshing,
    int? currentOffset,
    int? limit,
  }) {
    return PokemonListLoaded(
      pokemons: pokemons ?? this.pokemons,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      currentOffset: currentOffset ?? this.currentOffset,
      limit: limit ?? this.limit,
    );
  }

  @override
  List<Object?> get props => [
        pokemons,
        hasMore,
        isLoadingMore,
        isRefreshing,
        currentOffset,
        limit,
      ];
}

class PokemonListError extends PokemonListState {
  final String message;

  const PokemonListError({required this.message});

  @override
  List<Object?> get props => [message];
}

