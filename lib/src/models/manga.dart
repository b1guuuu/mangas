class Manga {
  late num id;
  final String title;
  final String status;
  final String publisher;
  final String firstVolumeCover;
  final num totalVolumes;

  Manga(
      {required this.id,
      required this.title,
      required this.status,
      required this.publisher,
      required this.firstVolumeCover,
      required this.totalVolumes});

  Manga.base(
      {required this.title,
      required this.status,
      required this.publisher,
      required this.firstVolumeCover,
      required this.totalVolumes});

  Manga.fromMap(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        status = json['status'],
        publisher = json['publisher'],
        firstVolumeCover = json['firstVolumeCover'],
        totalVolumes = json['totalVolumes'];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'status': status,
      'publisher': publisher,
      'firstVolumeCover': firstVolumeCover,
      'totalVolumes': totalVolumes
    };
  }

  Map<String, Object?> toMapWithoutId() {
    return {
      'title': title,
      'status': status,
      'publisher': publisher,
      'firstVolumeCover': firstVolumeCover,
      'totalVolumes': totalVolumes
    };
  }

  @override
  String toString() {
    return toMap().toString();
  }

  bool isDifferent(Manga manga) {
    return (manga.firstVolumeCover != firstVolumeCover) ||
        (manga.publisher != publisher) ||
        (manga.status != status) ||
        (manga.totalVolumes != totalVolumes);
  }
}
