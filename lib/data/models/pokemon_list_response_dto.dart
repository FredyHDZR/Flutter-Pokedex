import '../../domain/models/pokemon.dart';

class PokemonListResponseDto {
  final int count;
  final String? next;
  final String? previous;
  final List<PokemonListItemDto> results;

  PokemonListResponseDto({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory PokemonListResponseDto.fromJson(Map<String, dynamic> json) {
    return PokemonListResponseDto(
      count: json['count'] as int,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: (json['results'] as List<dynamic>)
          .map((item) =>
              PokemonListItemDto.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class PokemonListItemDto {
  final String name;
  final String url;

  PokemonListItemDto({
    required this.name,
    required this.url,
  });

  factory PokemonListItemDto.fromJson(Map<String, dynamic> json) {
    return PokemonListItemDto(
      name: json['name'] as String,
      url: json['url'] as String,
    );
  }

  int extractId() {
    final uri = Uri.parse(url);
    final segments = uri.pathSegments;
    final idString = segments.lastWhere(
      (s) => s.isNotEmpty,
      orElse: () => '0',
    );
    return int.tryParse(idString) ?? 0;
  }

  String buildImageUrl() {
    final id = extractId();
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';
  }

  Pokemon toDomain() {
    return Pokemon(
      id: extractId(),
      name: name,
      imageUrl: buildImageUrl(),
      types: [],
    );
  }
}

