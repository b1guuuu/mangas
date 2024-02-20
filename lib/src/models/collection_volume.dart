class CollectionVolume {
  final num collectionId;
  final num volumeId;
  final String addedDate;

  CollectionVolume(
      {required this.collectionId,
      required this.volumeId,
      required this.addedDate});

  CollectionVolume.fromMap(Map<String, dynamic> json)
      : collectionId = json['collectionId'],
        volumeId = json['volumeId'],
        addedDate = json['addedDate'];

  Map<String, Object?> toMap() {
    return {
      'collectionId': collectionId,
      'volumeId': volumeId,
      'addedDate': addedDate
    };
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
