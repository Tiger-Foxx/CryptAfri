class ProductModel {
  var ID;
  var prix_achat;
  var prix_vente;
  var name;
  var image;
  var date;
  var Category;
  var quantity;
  var numero;
  ProductModel({
    required this.Category,
    required this.ID,
    required this.date,
    required this.image,
    required this.prix_achat,
    required this.name,
    required this.quantity,
    required this.numero,
    this.prix_vente,
  });
}
