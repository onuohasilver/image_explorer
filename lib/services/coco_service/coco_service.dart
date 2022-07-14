abstract class CocoService {
  ///Get the coco categories map from the request endpoint
  ///It is received as a js string file, but using string and list manipulations
  ///I can access the actual values for the category variables
  Future<Map> getCategories();

  Future<List> getImageResults(List categoryIds);

  // Future<Map> getImageCaptions(Ls)
}
