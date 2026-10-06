import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../data/models/pixabay_image.dart';
import '../../favorites/view_models/favorites_view_model.dart';

class ImageDetailScreen extends StatelessWidget {
  final PixabayImage image;

  const ImageDetailScreen({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        actions: [
          Consumer<FavoritesViewModel>(
            builder: (context, favModel, child) {
              final isFav = favModel.isFavorite(image.id);

              return IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                ),
                onPressed: () {
                  favModel.toggleFavorite(image);
                },
              );
            },
          ),
        ],
      ),

      body: Stack(
        children: [
          Hero(
            tag: 'image_${image.id}',
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: CachedNetworkImage(
                imageUrl: image.largeImageUrl,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) {
                  return const Center(
                    child: Icon(Icons.error_outline, size: 50),
                  );
                },
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
