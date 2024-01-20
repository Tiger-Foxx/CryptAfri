import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cryptafri/screens/models/product.model.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductPage extends StatefulWidget {
  static const routeName = 'product';
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  var fav = false;
  void makeFav() {
    setState(() {
      fav = !fav;
    });
  }

// Obtenir l'email de l'utilisateur courant
  Future<String?> getUserEmail() async {
    var _Auth = FirebaseAuth.instance;
    // Obtenir l'objet User avec un null check
    User user = _Auth.currentUser!;
    // Retourner l'email de l'utilisateur
    return user.email;
  }

  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context)!.settings.arguments as ProductModel;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            floating: true,
            stretch: true,
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  icon: Icon(
                    !fav ? Icons.favorite_border : Icons.favorite,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    makeFav();
                  },
                  label: Text("Aimer"),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: product.ID,
                child: Image.network(
                  product.image.toString(),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(188, 0, 0, 0),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      product.name.toString().toUpperCase(),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                        fontSize: 35,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                    child: Container(
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "( " + product.Category.toString() + " )",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 243, 171, 36),
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(width: 40),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.shop),
                          label: Text("Valider l'achat"),
                        ),
                      ),
                      SizedBox(
                        height: 80,
                        width: 80,
                        child: Lottie.asset('assets/lotties/buy.json'),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      "Prix d'achat : " +
                          product.prix_achat.toString() +
                          " |Prix de Vente : " +
                          product.prix_vente.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(178, 255, 255, 255),
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      '1 ' +
                          product.name +
                          ' = ' +
                          product.prix_vente.toString() +
                          ' XAF',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(12.0),
                    child: Text(
                      "Disponible : " + product.quantity.toString(),
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 243, 171, 36),
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(9),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            sendMsg(
                                "message CryptAfri " +
                                    " pour le produit " +
                                    product.name.toString(),
                                product.numero.toString());
                            print(product.name);
                            // Appeler la fonct
                            //sendion addToCart avec l'identifiant du produit
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  backgroundColor:
                                      Color.fromARGB(255, 14, 230, 21),
                                  content: Text(
                                    '${product.name} nous Contacterons le vendeur',
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: Colors.white),
                                  )),
                            );
                          },
                          icon: const Icon(Icons.phone),
                          label: Text("Convertir sa quantite"),
                        ),
                      ),
                      SizedBox(
                        height: 80,
                        width: 80,
                        child: Lottie.asset('assets/lotties/buy.json'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void sendMsg(String message, String number) {
    // Encoder le message
    String encodedMessage = Uri.encodeComponent(message);

    // Construire l'URL
    String url = 'https://wa.me/$number?text=$encodedMessage';

    // Lancer l'URL
    try {
      launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (e) {
      print('Could not launch WhatsApp: $e');
    }
  }
}
