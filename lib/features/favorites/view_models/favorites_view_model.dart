import 'package:flutter/material.dart';

import '../../../data/models/pixabay_image.dart';
import '../../../data/repositories/image_repository.dart';

class FavoritesViewModel extends ChangeNotifier {
  final ImageRepository _repository;

  List<PixabayImage> _favoriteImages = [];
  List<PixabayImage> get favoriteImages => _favoriteImages;

  FavoritesViewModel(this._repository) {
    loadFavorites();
  }

  void loadFavorites() {
    _favoriteImages = _repository.getFavoriteImages();
    notifyListeners();
  }

  Future<void> toggleFavorite(PixabayImage image) async {
    await _repository.toggleFavorite(image);
    loadFavorites();
  }

  bool isFavorite(int id) {
    return _repository.isFavorite(id);
  }
}
