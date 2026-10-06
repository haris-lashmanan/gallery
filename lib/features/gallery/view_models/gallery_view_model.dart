import 'package:flutter/material.dart';

import '../../../data/models/pixabay_image.dart';
import '../../../data/repositories/image_repository.dart';

class GalleryViewModel extends ChangeNotifier {
  final ImageRepository _repository;

  GalleryViewModel(this._repository);

  Future<List<PixabayImage>> fetchImages(int page) async {
    return await _repository.getGalleryImages(page);
  }
}
