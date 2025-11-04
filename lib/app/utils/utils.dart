import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:url_launcher/url_launcher.dart';

Future<bool> isNetworkAvailable() => InternetConnectionChecker.instance.hasConnection;

makeCall(String phoneNumber) async {
  final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
  await launchUrl(launchUri);
}

openNavigation(double lat, double lng) async {
  final Uri googleMapsUri = Uri.parse(
    'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng',
  );
  await launchUrl(googleMapsUri, mode: LaunchMode.externalApplication);
}