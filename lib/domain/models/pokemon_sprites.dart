import 'package:freezed_annotation/freezed_annotation.dart';

part 'pokemon_sprites.freezed.dart';
part 'pokemon_sprites.g.dart';

@freezed
class PokemonSprites with _$PokemonSprites {
  const factory PokemonSprites({
    String? frontDefault,
    String? backDefault,
    String? frontShiny,
    String? backShiny,
    String? frontFemale,
    String? backFemale,
    String? frontShinyFemale,
    String? backShinyFemale,
    PokemonSpritesOther? other,
  }) = _PokemonSprites;

  factory PokemonSprites.fromJson(Map<String, dynamic> json) =>
      _$PokemonSpritesFromJson(json);
}

extension PokemonSpritesExtension on PokemonSprites {
  String get bestImage {
    return other?.officialArtwork?.frontDefault ??
        frontDefault ??
        'https://via.placeholder.com/200';
  }
}

@freezed
class PokemonSpritesOther with _$PokemonSpritesOther {
  const factory PokemonSpritesOther({
    @JsonKey(name: 'official-artwork') PokemonOfficialArtwork? officialArtwork,
  }) = _PokemonSpritesOther;

  factory PokemonSpritesOther.fromJson(Map<String, dynamic> json) =>
      _$PokemonSpritesOtherFromJson(json);
}

@freezed
class PokemonOfficialArtwork with _$PokemonOfficialArtwork {
  const factory PokemonOfficialArtwork({
    String? frontDefault,
    String? frontShiny,
  }) = _PokemonOfficialArtwork;

  factory PokemonOfficialArtwork.fromJson(Map<String, dynamic> json) =>
      _$PokemonOfficialArtworkFromJson(json);
}

