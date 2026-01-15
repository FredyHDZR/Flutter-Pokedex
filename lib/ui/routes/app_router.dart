import 'package:flutter/material.dart';
import 'package:flutter_pokedex/ui/pages/pokemon_detail_page.dart';
import 'package:flutter_pokedex/ui/pages/pokemon_list_page.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'pokemon-list',
      builder: (context, state) => const PokemonListPage(),
    ),
    GoRoute(
      path: '/pokemon/:id',
      name: 'pokemon-detail',
      pageBuilder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return CustomTransitionPage(
          key: state.pageKey,
          child: PokemonDetailPage(pokemonId: id),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
      },
    ),
  ],
);
