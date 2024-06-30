class BannerCampain {
  String? collectionId;
  String? id;
  String? thumbnail;
  String? categoryId;

  BannerCampain(this.collectionId, this.id, this.thumbnail, this.categoryId);

  factory BannerCampain.fromJsonObject(Map<String, dynamic> jsonObject) {
    return BannerCampain(
      jsonObject['collectionId'],
      jsonObject['id'],
      'https://startflutter.ir/api/files/${jsonObject['collectionId']}/${jsonObject['id']}/${jsonObject['thumbnail']}',
      jsonObject['categoryId'],
    );
  }
}
