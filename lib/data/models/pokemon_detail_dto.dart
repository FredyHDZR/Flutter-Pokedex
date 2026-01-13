import '../../core/utils/json_validator.dart';
import '../../domain/models/pokemon_detail.dart';
import '../../domain/models/pokemon_type.dart';
import '../../domain/models/pokemon_sprites.dart';
import '../../domain/models/pokemon_stat.dart';
import '../../domain/models/pokemon_ability.dart';

class PokemonDetailDto {
  final int id;
  final String name;
  final int height;
  final int weight;
  final int baseExperience;
  final List<PokemonTypeDto> types;
  final PokemonSpritesDto sprites;
  final List<PokemonStatDto> stats;
  final List<PokemonAbilityDto> abilities;

  PokemonDetailDto({
    required this.id,
    required this.name,
    required this.height,
    required this.weight,
    required this.baseExperience,
    required this.types,
    required this.sprites,
    required this.stats,
    required this.abilities,
  });

  factory PokemonDetailDto.fromJson(Map<String, dynamic> json) {
    return PokemonDetailDto(
      id: JsonValidator.validateInt(json['id'], 'id'),
      name: JsonValidator.validateString(json['name'], 'name'),
      height: JsonValidator.validateInt(json['height'], 'height'),
      weight: JsonValidator.validateInt(json['weight'], 'weight'),
      baseExperience:
          JsonValidator.validateInt(json['base_experience'], 'base_experience'),
      types: JsonValidator.validateList(
        json['types'],
        (item) => PokemonTypeDto.fromJson(item as Map<String, dynamic>),
        'types',
      ),
      sprites: PokemonSpritesDto.fromJson(
        json['sprites'] as Map<String, dynamic>,
      ),
      stats: JsonValidator.validateList(
        json['stats'],
        (item) => PokemonStatDto.fromJson(item as Map<String, dynamic>),
        'stats',
      ),
      abilities: JsonValidator.validateList(
        json['abilities'],
        (item) => PokemonAbilityDto.fromJson(item as Map<String, dynamic>),
        'abilities',
      ),
    );
  }

  PokemonDetail toDomain() {
    return PokemonDetail(
      id: id,
      name: name,
      height: height,
      weight: weight,
      baseExperience: baseExperience,
      types: types.map((t) => t.toDomain()).toList(),
      sprites: sprites.toDomain(),
      stats: stats.map((s) => s.toDomain()).toList(),
      abilities: abilities.map((a) => a.toDomain()).toList(),
    );
  }
}

class PokemonTypeDto {
  final int slot;
  final TypeInfoDto type;

  PokemonTypeDto({
    required this.slot,
    required this.type,
  });

  factory PokemonTypeDto.fromJson(Map<String, dynamic> json) {
    return PokemonTypeDto(
      slot: JsonValidator.validateInt(json['slot'], 'slot'),
      type: TypeInfoDto.fromJson(
        json['type'] as Map<String, dynamic>,
      ),
    );
  }

  PokemonType toDomain() {
    return PokemonType(
      slot: slot,
      type: type.toDomain(),
    );
  }
}

class TypeInfoDto {
  final String name;
  final String url;

  TypeInfoDto({
    required this.name,
    required this.url,
  });

  factory TypeInfoDto.fromJson(Map<String, dynamic> json) {
    return TypeInfoDto(
      name: JsonValidator.validateString(json['name'], 'name'),
      url: JsonValidator.validateString(json['url'], 'url'),
    );
  }

  TypeInfo toDomain() {
    return TypeInfo(
      name: name,
      url: url,
    );
  }
}

class PokemonSpritesDto {
  final String? frontDefault;
  final String? backDefault;
  final String? frontShiny;
  final String? backShiny;
  final String? frontFemale;
  final String? backFemale;
  final String? frontShinyFemale;
  final String? backShinyFemale;
  final PokemonSpritesOtherDto? other;

  PokemonSpritesDto({
    this.frontDefault,
    this.backDefault,
    this.frontShiny,
    this.backShiny,
    this.frontFemale,
    this.backFemale,
    this.frontShinyFemale,
    this.backShinyFemale,
    this.other,
  });

  factory PokemonSpritesDto.fromJson(Map<String, dynamic> json) {
    return PokemonSpritesDto(
      frontDefault: json['front_default'] as String?,
      backDefault: json['back_default'] as String?,
      frontShiny: json['front_shiny'] as String?,
      backShiny: json['back_shiny'] as String?,
      frontFemale: json['front_female'] as String?,
      backFemale: json['back_female'] as String?,
      frontShinyFemale: json['front_shiny_female'] as String?,
      backShinyFemale: json['back_shiny_female'] as String?,
      other: json['other'] != null
          ? PokemonSpritesOtherDto.fromJson(
              json['other'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  PokemonSprites toDomain() {
    return PokemonSprites(
      frontDefault: frontDefault,
      backDefault: backDefault,
      frontShiny: frontShiny,
      backShiny: backShiny,
      frontFemale: frontFemale,
      backFemale: backFemale,
      frontShinyFemale: frontShinyFemale,
      backShinyFemale: backShinyFemale,
      other: other?.toDomain(),
    );
  }
}

class PokemonSpritesOtherDto {
  final PokemonOfficialArtworkDto? officialArtwork;

  PokemonSpritesOtherDto({
    this.officialArtwork,
  });

  factory PokemonSpritesOtherDto.fromJson(Map<String, dynamic> json) {
    return PokemonSpritesOtherDto(
      officialArtwork: json['official-artwork'] != null
          ? PokemonOfficialArtworkDto.fromJson(
              json['official-artwork'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  PokemonSpritesOther toDomain() {
    return PokemonSpritesOther(
      officialArtwork: officialArtwork?.toDomain(),
    );
  }
}

class PokemonOfficialArtworkDto {
  final String? frontDefault;
  final String? frontShiny;

  PokemonOfficialArtworkDto({
    this.frontDefault,
    this.frontShiny,
  });

  factory PokemonOfficialArtworkDto.fromJson(Map<String, dynamic> json) {
    return PokemonOfficialArtworkDto(
      frontDefault: json['front_default'] as String?,
      frontShiny: json['front_shiny'] as String?,
    );
  }

  PokemonOfficialArtwork toDomain() {
    return PokemonOfficialArtwork(
      frontDefault: frontDefault,
      frontShiny: frontShiny,
    );
  }
}

class PokemonStatDto {
  final int baseStat;
  final int effort;
  final StatInfoDto stat;

  PokemonStatDto({
    required this.baseStat,
    required this.effort,
    required this.stat,
  });

  factory PokemonStatDto.fromJson(Map<String, dynamic> json) {
    return PokemonStatDto(
      baseStat: JsonValidator.validateInt(json['base_stat'], 'base_stat'),
      effort: JsonValidator.validateInt(json['effort'], 'effort'),
      stat: StatInfoDto.fromJson(
        json['stat'] as Map<String, dynamic>,
      ),
    );
  }

  PokemonStat toDomain() {
    return PokemonStat(
      baseStat: baseStat,
      effort: effort,
      stat: stat.toDomain(),
    );
  }
}

class StatInfoDto {
  final String name;
  final String url;

  StatInfoDto({
    required this.name,
    required this.url,
  });

  factory StatInfoDto.fromJson(Map<String, dynamic> json) {
    return StatInfoDto(
      name: JsonValidator.validateString(json['name'], 'name'),
      url: JsonValidator.validateString(json['url'], 'url'),
    );
  }

  StatInfo toDomain() {
    return StatInfo(
      name: name,
      url: url,
    );
  }
}

class PokemonAbilityDto {
  final AbilityInfoDto ability;
  final bool isHidden;
  final int slot;

  PokemonAbilityDto({
    required this.ability,
    required this.isHidden,
    required this.slot,
  });

  factory PokemonAbilityDto.fromJson(Map<String, dynamic> json) {
    return PokemonAbilityDto(
      ability: AbilityInfoDto.fromJson(
        json['ability'] as Map<String, dynamic>,
      ),
      isHidden: json['is_hidden'] as bool,
      slot: JsonValidator.validateInt(json['slot'], 'slot'),
    );
  }

  PokemonAbility toDomain() {
    return PokemonAbility(
      ability: ability.toDomain(),
      isHidden: isHidden,
      slot: slot,
    );
  }
}

class AbilityInfoDto {
  final String name;
  final String url;

  AbilityInfoDto({
    required this.name,
    required this.url,
  });

  factory AbilityInfoDto.fromJson(Map<String, dynamic> json) {
    return AbilityInfoDto(
      name: JsonValidator.validateString(json['name'], 'name'),
      url: JsonValidator.validateString(json['url'], 'url'),
    );
  }

  AbilityInfo toDomain() {
    return AbilityInfo(
      name: name,
      url: url,
    );
  }
}

