import 'package:go_router/go_router.dart';
import '../pages/pokemon_list_page.dart';
import '../pages/pokemon_detail_page.dart';

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
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return PokemonDetailPage(pokemonId: id);
      },
    ),
  ],
);

