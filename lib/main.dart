import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/config/env_config.dart';
import 'core/network/dio_client.dart';
import 'core/route/app_router.dart';
import 'data/repositories/image_repository.dart';
import 'data/services/api_service.dart';
import 'data/services/download_service.dart';
import 'data/services/storage_service.dart';
import 'features/favorites/view_models/favorites_view_model.dart';
import 'features/gallery/view_models/gallery_view_model.dart';
import 'features/image_detail/view_models/detail_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  EnvConfig.validate();

  final prefs = await SharedPreferences.getInstance();

  final dioClient = DioClient();
  final apiService = ApiService(dioClient);
  final storageService = StorageService(prefs);
  final imageRepository = ImageRepository(apiService, storageService);

  runApp(
    MultiProvider(
      providers: [
        Provider<ImageRepository>.value(value: imageRepository),

        ChangeNotifierProvider(
          create: (_) => GalleryViewModel(imageRepository),
        ),

        ChangeNotifierProvider(
          create: (_) => FavoritesViewModel(imageRepository),
        ),

        ChangeNotifierProvider(
          create: (_) => DetailViewModel(DownloadService()),
        ),
      ],
      child: const InfiniteGalleryApp(),
    ),
  );
}

class InfiniteGalleryApp extends StatelessWidget {
  const InfiniteGalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Infinite Image Gallery',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
