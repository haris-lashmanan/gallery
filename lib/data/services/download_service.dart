import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_image_gallery_saver/flutter_image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadService {
  final Dio _dio = Dio();

  Future requestPermissions() async {
    if (Platform.isIOS) {
      return await Permission.photos.request().isGranted;
    } else {
      final photos = await Permission.photos.request();
      final storage = await Permission.storage.request();
      return photos.isGranted || storage.isGranted;
    }
  }

  Future downloadAndSaveImage({
    required String url,
    required String fileName,
    required void Function(int received, int total) onProgress,
  }) async {
    final hasPermission = await requestPermissions();
    if (!hasPermission) {
      throw Exception('Storage/Photo permission denied');
    }

    final tempDir = await getTemporaryDirectory();

    final savePath = '${tempDir.path}/$fileName';

    await _dio.download(url, savePath, onReceiveProgress: onProgress);

    await ImageGallerySaver().saveFile(savePath);

    final file = File(savePath);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
