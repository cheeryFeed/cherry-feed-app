class ImageInfo {
  final int? id;
  final String? url;

  ImageInfo({
    required this.id,
    required this.url,
  });

  factory ImageInfo.fromJson(Map<String, dynamic> json) {
    return ImageInfo(
      id: json['id'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['url'] = this.url;
    return data;
  }

  @override
  String toString() {
    return 'ImageInfo{id: $id, url: $url}';
  }
}