import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/landing_page.dart';
import 'screens/login_page.dart';
import 'screens/registration_page.dart';
import 'screens/home_page.dart';
import 'screens/report_page.dart';
import 'screens/request_page.dart';
import 'screens/track_page.dart';
import 'screens/announcements_page.dart';
import 'screens/profile_page.dart';
import 'screens/home_official_page.dart';
import 'screens/reports_official_page.dart';
import 'screens/requests_official_page.dart';
import 'screens/announcements_official_page.dart';
import 'screens/analytics_official_page.dart';
import 'config/app_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TellBarangay',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primaryOrange,
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LandingPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegistrationSelectionPage(),
        '/home': (context) => HomePage(),
        '/reports': (context) => const ReportAnIssuePage(),
        '/request': (context) => const RequestPage(),
        '/track': (context) => const TrackPage(),
        '/announcements': (context) => const AnnouncementsPage(),
        '/profile': (context) => const ProfilePage(),
        '/official-home': (context) => const HomeOfficialPage(),
        '/official-reports': (context) => const ReportsOfficialPage(),
        '/official-requests': (context) => const RequestsOfficialPage(),
        '/official-announcements': (context) => const AnnouncementsOfficialPage(),
        '/official-analytics': (context) => const AnalyticsOfficialPage(),
      },
    );
  }
}
