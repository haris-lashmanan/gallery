import 'package:dio/dio.dart';

import '../../core/network/dio_client.dart';
import '../models/pixabay_image.dart';

class ApiService {
  final DioClient _dioClient;
  ApiService(this._dioClient);

  Future<List<PixabayImage>> fetchImages({
    required int page,
    int perPage = 20,
  }) async {
    try {
      final response = await _dioClient.dio.get(
        '',
        queryParameters: {'page': page, 'per_page': perPage},
      );
      if (response.statusCode == 200) {
        final List<dynamic> hits = response.data['hits'];
        return hits.map((json) => PixabayImage.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load images');
      }
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Unknown network error occurred');
    }
  }
}
