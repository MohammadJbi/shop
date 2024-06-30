class Property {
  String? title;
  String? value;

  Property(this.title, this.value);

  factory Property.fromJsonObject(Map<String, dynamic> jsonObject) {
    return Property(
      jsonObject['title'],
      jsonObject['value'],
    );
  }
}
