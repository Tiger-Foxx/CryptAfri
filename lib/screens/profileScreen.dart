import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:cryptafri/screens/SellsScreen.dart';
import 'package:cryptafri/screens/sign-in_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfilePage extends StatelessWidget {
  String? getUserEmail() {
    var _Auth = FirebaseAuth.instance;
    // Obtenir l'objet User avec un null check
    User user = _Auth.currentUser!;
    // Retourner l'email de l'utilisateur
    return user.email.toString();
  }

  static const routeName = 'profile';
  // Le nombre de notifications à afficher
  final int notificationCount = 3;

  // Les options de la page de profil
  final List<Map<String, dynamic>> profileOptions = [
    {
      'icon': "assets/images/what.jpeg",
      'title': 'Nous Contacter',
      'data': "+237678585611",
      'onTap': (context) {
        var message =
            'MESSAGE CRYPTAFRI ! \nASSISTANCE CLIENT\n\n\n\n Bonjour je suis : ';
        var number = '+237678585611';
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
    },
    {
      'icon': "assets/images/OM.png",
      'title': 'Orange Money CriptAfri(GAMGNE CELINE) : 658121197',
      'data': "#150*1*1*658121197#",
      'onTap': (context) {
        var number = Uri.encodeComponent("#150*1*1*658121197#");
        // Encoder le message

        // Construire l'URL
        String url = 'tel:$number';

        // Lancer l'URL
        try {
          launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        } catch (e) {
          print('Could not launch URL: $e');
        }
      }
    },
    {
      'icon': "assets/images/MOMO.png",
      'title': 'MTN MOMO CriptAfri (CESAR LONTSI) : 678585611',
      'data': "#150*1*1*678585611#",
      'onTap': (context) {
        var number = Uri.encodeComponent("#150*1*1*678585611#");

        // Construire l'URL
        String url = 'tel:$number';

        // Lancer l'URL
        try {
          launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        } catch (e) {
          print('Could not launch URL: $e');
        }
      }
    },
    {
      'icon': Icons.payment,
      'title': 'ADRESSE CriptAfri 1 : ERC 20',
      'data': "0x5096ffdf9c2f6f26fec795b85770452e100cad50",
      'onTap': (context) {
        String url = 'https://';

        // Lancer l'URL
        try {
          launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        } catch (e) {
          print('Could not launch url: $e');
        }
      }
    },
    {
      'icon': Icons.payment,
      'title': 'ADRESSE CriptAfri 2 : BEP 20',
      'data': "0x5096ffdf9c2f6f26fec795b85770452e100cad50",
      'onTap': (context) {
        String url = 'https://';

        // Lancer l'URL
        try {
          launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        } catch (e) {
          print('Could not launch url: $e');
        }
      }
    },
    {
      'icon': Icons.payment,
      'title': 'ADRESSE CriptAfri 3 : TRC 20',
      'data': "TWNBb1W76TwQ1HXwFir3SxD5D9sE3d64Lu",
      'onTap': (context) {
        String url = 'https://';

        // Lancer l'URL
        try {
          launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        } catch (e) {
          print('Could not launch url: $e');
        }
      }
    },
    // Ajouter d'autres options ici
    {
      'icon': Icons.logout,
      'title': 'Se Deconnecter',
      'data': '',
      'onTap': (context) {
        // Afficher un message de succès
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Déconnexion'),
            backgroundColor: Colors.red,
          ),
        );
        FirebaseAuth.instance.signOut();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignInScreen()),
        );
      }
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
        actions: [
          // Le bouton des notifications avec le badge
          Padding(
            padding: const EdgeInsets.all(13.0),
            child: badges.Badge(
              badgeContent: Text(
                notificationCount.toString(),
                style: TextStyle(color: Colors.white),
              ),
              child: IconButton(
                icon: Icon(Icons.notifications),
                onPressed: () {
                  // La fonction à appeler lors du tap sur ce bouton
                  // Laisser vide pour l'instant
                },
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Le container avec la photo de profil
            Container(
              height: 120.0,
              child: CircleAvatar(
                radius: 60.0,
                backgroundImage: AssetImage(
                  // L'URL de la photo de profil
                  'assets/images/0.jpg',
                ),
              ),
            ),
            // Le texte avec le nom de l'utilisateur
            Text(
              // Le nom de l'utilisateur
              getUserEmail().toString(),
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              // Le nom de l'utilisateur
              "Informations de Transactions CriptAfri",
              style: TextStyle(
                color: Colors.amber,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Le séparateur
            Divider(),
            // La liste des options
            Expanded(
              child: ListView.builder(
                itemCount: profileOptions.length,
                itemBuilder: (context, index) {
                  // L'option courante
                  final option = profileOptions[index];
                  return Column(
                    children: [
                      ListTile(
                        leading: (index != 0 && index != 1 && index != 2)
                            ? Icon(option['icon'], size: 35)
                            : (Image.asset(
                                option['icon'],
                                width: 32,
                                height: 32,
                              )),
                        title: Text(
                          option['title'],
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        onTap: () => option['onTap'](context),
                      ),
                      CopyableTextButton(option['data']),
                      Divider(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
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

class CopyableTextButton extends StatelessWidget {
  final String text;

  CopyableTextButton(this.text);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        Clipboard.setData(ClipboardData(text: text));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Texte copié'),
          ),
        );
      },
      icon: Icon(Icons.copy),
      label: Text(text, style: TextStyle(fontWeight: FontWeight.w900)),
    );
  }
}