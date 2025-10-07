import 'package:internet_connection_checker/internet_connection_checker.dart';

Future<bool> isNetworkAvailable() => InternetConnectionChecker.instance.hasConnection;