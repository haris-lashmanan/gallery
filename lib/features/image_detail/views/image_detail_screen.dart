import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_gallery_saver/flutter_image_gallery_saver.dart' show ImageGallerySaver;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../../data/models/pixabay_image.dart';
import '../../favorites/view_models/favorites_view_model.dart';

class ImageDetailScreen extends StatefulWidget {
  final PixabayImage image;

  const ImageDetailScreen({super.key, required this.image});

  @override
  State<ImageDetailScreen> createState() => _ImageDetailScreenState();
}

class _ImageDetailScreenState extends State<ImageDetailScreen> {
  bool _isDownloading = false;

  /// Returns true if storage permission is granted.
  /// On Android 13+ (API 33+) READ_MEDIA_IMAGES is used; below that
  /// STORAGE is used. iOS always returns true here (handled by the plugin).
  Future<bool> _requestPermission() async {
    final permission = Permission.photos;
    final status = await permission.status;

    if (status.isGranted) return true;

    if (status.isPermanentlyDenied) {
      // Show dialog to send user to app settings
      final goToSettings = await _showSettingsDialog();
      if (goToSettings) await openAppSettings();
      return false;
    }

    final result = await permission.request();

    if (result.isGranted) return true;

    if (result.isPermanentlyDenied) {
      final goToSettings = await _showSettingsDialog();
      if (goToSettings) await openAppSettings();
    }

    return false;
  }

  Future<bool> _showSettingsDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Permission Required'),
        content: const Text(
          'Storage permission is needed to save images to your gallery. '
          'Please enable it in Settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Future<void> _downloadImage() async {
    final granted = await _requestPermission();
    if (!granted) return;

    setState(() => _isDownloading = true);

    try {
      final response = await Dio().get<List<int>>(
        widget.image.largeImageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      final bytes = response.data;
      if (bytes == null || bytes.isEmpty) throw Exception('Empty response');

      await ImageGallerySaver().saveImage(Uint8List.fromList(bytes));

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Image saved to gallery'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Download failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isDownloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _isDownloading
                  ? const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.red,
                        ),
                      ),
                    )
                  : IconButton(
                      icon: const Icon(Icons.download, color: Colors.red),
                      onPressed: _downloadImage,
                    ),
              Consumer<FavoritesViewModel>(
                builder: (context, favModel, child) {
                  final isFav = favModel.isFavorite(widget.image.id);

                  return IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      favModel.toggleFavorite(widget.image);
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),

      body: Hero(
        tag: 'image_${widget.image.id}',
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: CachedNetworkImage(
            imageUrl: widget.image.largeImageUrl,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) {
              return const Center(child: Icon(Icons.error_outline, size: 50));
            },
          ),
        ),
      ),
    );
  }
}
