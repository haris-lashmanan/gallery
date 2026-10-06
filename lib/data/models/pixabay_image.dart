class PixabayImage {
  final int id;
  final String previewUrl;
  final String largeImageUrl;

  PixabayImage({
    required this.id,
    required this.previewUrl,
    required this.largeImageUrl,
  });

  factory PixabayImage.fromJson(Map<String, dynamic> json) {
    return PixabayImage(
      id: json['id'] as int,
      previewUrl: json['previewURL'] as String,
      largeImageUrl: json['largeImageURL'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'previewURL': previewUrl, 'largeImageURL': largeImageUrl};
  }
}
