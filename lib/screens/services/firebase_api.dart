import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title : ${message.notification?.title}');
  print('body : ${message.notification?.body}');
  print('payload : ${message.data}');
}

class firebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  // Créer une référence à la collection tokens
  CollectionReference tokens = FirebaseFirestore.instance.collection('tokens');

// Définir une fonction asynchrone qui renvoie le token correspondant à l'email
  Future<String> getToken(String email) async {
    // Obtenir le document qui a pour ID l'email
    DocumentSnapshot doc = await tokens.doc(email).get();
    // Obtenir la valeur du champ token
    String token = doc.get('token');
    // Retourner le token
    return token;
  }

  Future<void> registerToken() async {
    // Get the current user's name or email
    var token = await _firebaseMessaging.getToken();
    // Get the current user object
    User? user = FirebaseAuth.instance.currentUser;
// Get the email of the current user
    String? email = user?.email;
    FirebaseFirestore.instance
        .collection('tokens')
        .doc(email) //email doit etre l'id du document
        .set({'token': token});
  }

  Future<void> handlemsg(RemoteMessage message) async {
    launchUrl(Uri.parse("https://fox-s.netlify.app"),
        mode: LaunchMode.externalApplication);
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    var FCMToken = await _firebaseMessaging.getToken();

    print('Token : $FCMToken');
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handlemsg);
    await registerToken();
  }

// Créer un message FCM avec le jeton de l'utilisateur et le contenu de la notification
  Future<Map<String, dynamic>> createFCMMessage(
      String token, String title, String body) async {
    Map<String, dynamic> message = {
      'to': token,
      'notification': {
        'title': title,
        'body': body,
      },
      'data': {
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'id': '1',
        'status': 'done',
        'link': 'https://fox-s.netlify.app',
      },
    };
    return message;
  }

  // Envoyer le message FCM à l'aide de l'API HTTP v1 de FCM
  Future<bool> sendFCMMessage(Map<String, dynamic> message) async {
    String serverKey =
        'AAAA8SocC98:APA91bHRGheiHJn0AQMizfX1-EpYMhVMALzYTqe6cyh8NVrNK69Ky_IcfrvT30WrImcPXbM_Z4-PmcaNLIjymca7yZuSGhui4ixSWIYnjijB8KnvIfH7dxFM-yMlcKRvlQJIFkc0MSdh';
    String postUrl =
        'https://fcm.googleapis.com/fcm/send'; // Remplacer par l'ID de votre projet Firebase
    final response = await http.post(
      Uri.parse(postUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $serverKey',
      },
      body: jsonEncode(message),
    );
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> sendVenteNotif() async {
    await firebaseApi().sendFCMMessage(await firebaseApi().createFCMMessage(
        await firebaseApi().getToken("donfackarthur750@gmail.com"),
        "NOUVELLE VENTE CRYPTAFRI",
        "UNE PERSONNE VIENS DE VENDRE SUR CRYPTAFRI"));
    print("le jeton : " +
        await firebaseApi().getToken("donfackarthur750@gmail.com"));
  }

  Future<void> sendAchatNotif() async {
    await firebaseApi().sendFCMMessage(await firebaseApi().createFCMMessage(
        await firebaseApi().getToken("donfackarthur750@gmail.com"),
        "NOUVEL ACHAT SUR CRYPTAFRI",
        "UNE PERSONNE VIENS D'ACHETER SUR CRYPTAFRI"));
    print("le jeton : " +
        await firebaseApi().getToken("donfackarthur750@gmail.com"));
  }
}
