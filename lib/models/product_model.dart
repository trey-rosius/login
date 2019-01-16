class ProductModel {
  String productId;
  String productName;
  String productDetails;
  String productMetaKeywords;
  String productPrice;
  String productCategory;
  String productMainImage;
  List<String> productImages;

  ProductModel(
      {this.productId,
      this.productName,
      this.productDetails,
      this.productMetaKeywords,
      this.productPrice,
      this.productCategory,
      this.productMainImage,
      this.productImages});
}
