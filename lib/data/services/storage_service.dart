import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/pixabay_image.dart';

class StorageService {
  static const String _favoritesKey = 'favorite_images';
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  List<PixabayImage> getFavorites() {
    final String? favoritesJson = _prefs.getString(_favoritesKey);
    if (favoritesJson == null) return [];

    final List<dynamic> decodedList = json.decode(favoritesJson);
    return decodedList.map((json) => PixabayImage.fromJson(json)).toList();
  }

  Future<void> toggleFavorite(PixabayImage image) async {
    final favorites = getFavorites();
    final index = favorites.indexWhere((fav) => fav.id == image.id);

    if (index >= 0) {
      favorites.removeAt(index);
    } else {
      favorites.add(image);
    }

    final String encodedList = json.encode(
      favorites.map((e) => e.toJson()).toList(),
    );
    await _prefs.setString(_favoritesKey, encodedList);
  }

  bool isFavorite(int id) {
    final favorites = getFavorites();
    return favorites.any((fav) => fav.id == id);
  }
}
