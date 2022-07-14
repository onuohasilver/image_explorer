class ResultModel {
  final List segmentation, captions;
  final int imageID;
  final String imageUrl;

  ResultModel(
      {required this.segmentation,
      required this.captions,
      required this.imageID,
      required this.imageUrl});

  @override
  String toString() {
    return 'Captions :$captions , ImageUrl:$imageUrl, Segmentation:$segmentation';
  }
}
