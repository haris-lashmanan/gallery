import '../models/pixabay_image.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class ImageRepository {
  final ApiService _apiService;
  final StorageService _storageService;

  ImageRepository(this._apiService, this._storageService);

  Future<List<PixabayImage>> getGalleryImages(int page) {
    return _apiService.fetchImages(page: page);
  }

  List<PixabayImage> getFavoriteImages() {
    return _storageService.getFavorites();
  }

  Future<void> toggleFavorite(PixabayImage image) {
    return _storageService.toggleFavorite(image);
  }

  bool isFavorite(int id) {
    return _storageService.isFavorite(id);
  }
}
