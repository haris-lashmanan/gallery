import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../gallery/views/widgets/image_card.dart';
import '../view_models/favorites_view_model.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: Consumer<FavoritesViewModel>(
        builder: (context, viewModel, child) {
          final favorites = viewModel.favoriteImages;

          if (favorites.isEmpty) {
            return const Center(child: Text('No favorites yet.'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final image = favorites[index];

              return ImageCard(
                image: image,
                onTap: () => context.push('/detail', extra: image),
              );
            },
          );
        },
      ),
    );
  }
}
