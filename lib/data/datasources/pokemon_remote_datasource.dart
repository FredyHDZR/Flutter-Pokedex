import 'package:dio/dio.dart';
import 'package:flutter_pokedex/core/constants/api_constants.dart';
import 'package:flutter_pokedex/core/error/exceptions.dart';
import 'package:flutter_pokedex/core/network/dio_client.dart';
import 'package:flutter_pokedex/data/models/pokemon_detail_dto.dart';
import 'package:flutter_pokedex/data/models/pokemon_list_response_dto.dart';
import 'package:flutter_pokedex/domain/models/pokemon.dart';
import 'package:flutter_pokedex/domain/models/pokemon_detail.dart';

abstract class PokemonRemoteDataSource {
  Future<List<Pokemon>> getPokemonList({
    required int limit,
    required int offset,
  });

  Future<PokemonDetail> getPokemonDetail({required int id});
}

class PokemonRemoteDataSourceImpl implements PokemonRemoteDataSource {
  
  PokemonRemoteDataSourceImpl({required this.dioClient});

  final DioClient dioClient;

  @override
  Future<List<Pokemon>> getPokemonList({
    required int limit,
    required int offset,
  }) async {
    try {
      final response = await dioClient.dio.get(
        ApiConstants.pokemonEndpoint,
        queryParameters: {
          'limit': limit,
          'offset': offset,
        },
      );

      if (response.statusCode == 200) {
        final dto = PokemonListResponseDto.fromJson(
          response.data as Map<String, dynamic>,
        );
        return dto.results.map((item) => item.toDomain()).toList();
      } else {
        throw ServerException(message: 'Error al obtener listado');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw NotFoundException(message: 'Recurso no encontrado');
      }
      throw ServerException(
        message: e.error?.toString() ?? 'Error de red',
      );
    }
  }

  @override
  Future<PokemonDetail> getPokemonDetail({required int id}) async {
    try {
      final response = await dioClient.dio.get(
        '${ApiConstants.pokemonEndpoint}/$id',
      );

      if (response.statusCode == 200) {
        final dto = PokemonDetailDto.fromJson(
          response.data as Map<String, dynamic>,
        );
        return dto.toDomain();
      } else if (response.statusCode == 404) {
        throw NotFoundException(message: 'Pokémon no encontrado');
      } else {
        throw ServerException(message: 'Error al obtener detalle');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw NotFoundException(message: 'Pokémon no encontrado');
      }
      throw ServerException(
        message: e.error?.toString() ?? 'Error de red',
      );
    }
  }
}
