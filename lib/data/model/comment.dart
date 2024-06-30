class Comment {
  String id;
  String text;
  String productId;
  String userId;
  String userThumnailUrl;
  String username;
  String avatar;
  Comment(
    this.id,
    this.text,
    this.productId,
    this.userId,
    this.userThumnailUrl,
    this.username,
    this.avatar,
  );

  factory Comment.fromJsonObject(Map<String, dynamic> jsonObject) {
    return Comment(
      jsonObject['id'],
      jsonObject['text'],
      jsonObject['product_id'],
      jsonObject['user_id'],
      'https://startflutter.ir/api/files/${jsonObject['expand']['user_id']['collectionName']}/${jsonObject['expand']['user_id']['id']}/${jsonObject['expand']['user_id']['avatar']}',
      jsonObject['expand']['user_id']['name'],
      jsonObject['expand']['user_id']['avatar'],
    );
  }
}
