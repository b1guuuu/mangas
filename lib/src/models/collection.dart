class Collection {
  late num id;
  final String status;
  final num mangaId;
  final String mangaTitle;
  final String firstVolumeCover;

  Collection(
      {required this.id,
      required this.status,
      required this.mangaId,
      required this.mangaTitle,
      required this.firstVolumeCover});

  Collection.base(
      {required this.status,
      required this.mangaId,
      required this.mangaTitle,
      required this.firstVolumeCover});

  Collection.fromMap(Map<String, dynamic> json)
      : id = json['id'],
        status = json['status'],
        mangaId = json['mangaId'],
        mangaTitle = json['mangaTitle'],
        firstVolumeCover = json['firstVolumeCover'];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'status': status,
      'mangaId': mangaId,
      'mangaTitle': mangaTitle,
      'firstVolumeCover': firstVolumeCover
    };
  }

  Map<String, Object?> toMapWithoutId() {
    return {
      'status': status,
      'mangaId': mangaId,
      'mangaTitle': mangaTitle,
      'firstVolumeCover': firstVolumeCover
    };
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
