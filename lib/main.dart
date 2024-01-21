import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cryptafri/screens/Splash_screen_info.dart';
import 'package:cryptafri/screens/Splash_screen_info2.dart';
import 'package:cryptafri/screens/services/firebase_api.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cryptafri/screens/AddProductScreen.dart';
import 'package:cryptafri/screens/ForgotScreen.dart';
import 'package:cryptafri/screens/SellsScreen.dart';
import 'package:cryptafri/screens/HomeScreen.dart';
import 'package:cryptafri/screens/onboarding_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'screens/ProductPage.dart';
import 'screens/Splash_screen.dart';
import 'screens/SearchPage.dart';
import 'screens/profileScreen.dart';
import 'screens/sign-in_screen.dart';
import 'screens/sign-up_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await firebaseApi().initNotifications();
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("contenuuuuuuuuuuuuuu : " + message.data['link']);
    // Ici, vous pouvez appeler la fonction launch avec le lien contenu dans le message
    launchUrl(Uri.parse(message.data['link']),
        mode: LaunchMode.externalApplication);
  });

  // Initialiser le plugin avec les paramètres par défaut pour Android et iOS
  try {
    await AwesomeNotifications().initialize(
        null, // default icon
        [
          NotificationChannel(
              channelKey: 'basic_channel',
              channelName: 'Basic notifications',
              channelDescription: 'Notification channel for basic tests',
              defaultColor: Color(0xFF9D50DD),
              ledColor: Colors.white)
        ]);
  } on Exception catch (e) {
    // TODO
  }
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    showNotification();
  });
  runApp(const MainApp());
}

void showNotification() {
  // Créer le contenu de la notification
  AwesomeNotifications().createNotification(
      content: NotificationContent(
    id: 10,
    channelKey: 'basic_channel',
    title: 'NOUVELLE ACTION SUR CRYPTAFRI',
    body: 'UN CLIENT A EFFECTUE UNE NOUVELLE ACTION SUR CRYPTAFRI',
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CategoryModel(),
      child: MaterialApp(
        title: "Cryptafri",
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow),
          useMaterial3: true,
        ),
        routes: {
          Splash_screen.routeName: (context) => const Splash_screen(),
          Splash_screen_info.routeName: (context) => const Splash_screen_info(),
          Splash_screen_info2.routeName: (context) =>
              const Splash_screen_info2(),
          OnboardingScreen.routeName: (context) => const OnboardingScreen(),
          SignInScreen.routeName: (context) => const SignInScreen(),
          SignUpScreen.routeName: (context) => const SignUpScreen(),
          ProductPage.routeName: (context) => const ProductPage(),
          SellsScreen.routeName: (context) => SellsScreen(),
          AddProductScreen.routeName: (context) => const AddProductScreen(),
          ProfilePage.routeName: (context) => ProfilePage(),
          ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
        },
        initialRoute: Splash_screen.routeName,
      ),
    );
  }
}
