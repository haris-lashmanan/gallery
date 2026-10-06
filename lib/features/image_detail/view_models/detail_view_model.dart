import 'package:flutter/material.dart';

import '../../../data/models/pixabay_image.dart';
import '../../../data/services/download_service.dart';

class DetailViewModel extends ChangeNotifier {
  final DownloadService _downloadService;

  bool _isDownloading = false;
  bool get isDownloading => _isDownloading;

  double _downloadProgress = 0.0;
  double get downloadProgress => _downloadProgress;

  DetailViewModel(this._downloadService);

  Future<void> downloadImage(PixabayImage image) async {
    _isDownloading = true;
    _downloadProgress = 0.0;
    notifyListeners();

    try {
      await _downloadService.downloadAndSaveImage(
        url: image.largeImageUrl,
        fileName: 'pixabay_${image.id}.jpg',
        onProgress: (received, total) {
          if (total != -1) {
            _downloadProgress = received / total;
            notifyListeners();
          }
        },
      );
    } catch (e) {
      rethrow;
    } finally {
      _isDownloading = false;
      notifyListeners();
    }
  }
}
