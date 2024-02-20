class Volume {
  late num id;
  final num volumeNumber;
  final String release;
  final double price;
  final String cover;
  late num mangaId;

  Volume(
      {required this.id,
      required this.volumeNumber,
      required this.release,
      required this.price,
      required this.cover,
      required this.mangaId});

  Volume.base(
      {required this.volumeNumber,
      required this.release,
      required this.price,
      required this.cover,
      required this.mangaId});

  Volume.fromMap(Map<String, dynamic> json)
      : id = json['id'],
        volumeNumber = json['volumeNumber'],
        release = json['release'],
        price = json['price'],
        cover = json['cover'],
        mangaId = json['mangaId'];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'volumeNumber': volumeNumber,
      'release': release,
      'price': price,
      'cover': cover,
      'mangaId': mangaId
    };
  }

  Map<String, Object?> toMapWithoutId() {
    return {
      'volumeNumber': volumeNumber,
      'release': release,
      'price': price,
      'cover': cover,
      'mangaId': mangaId
    };
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
