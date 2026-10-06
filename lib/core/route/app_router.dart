import 'package:go_router/go_router.dart';

import '../../data/models/pixabay_image.dart';
import '../../features/favorites/views/favorites_screen.dart';
import '../../features/gallery/views/gallery_screen.dart';
import '../../features/image_detail/views/image_detail_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'gallery',
        builder: (context, state) => const GalleryScreen(),
      ),
      GoRoute(
        path: '/favorites',
        name: 'favorites',
        builder: (context, state) => const FavoritesScreen(),
      ),
      GoRoute(
        path: '/detail',
        name: 'detail',
        builder: (context, state) {
          final image = state.extra as PixabayImage;
          return ImageDetailScreen(image: image);
        },
      ),
    ],
  );
}
