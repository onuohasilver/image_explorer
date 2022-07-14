class CategoryModel {
  final String category, id;

  CategoryModel(this.category, this.id);
  factory CategoryModel.fromJson(Map json) {
    return CategoryModel(json['category'], json['id']);
  }
}
