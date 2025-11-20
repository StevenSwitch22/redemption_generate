import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'services/local/secure_storage.dart';
import 'services/api/api_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = SecureStorageService();
  final token = await storage.getToken();

  ApiClient().initialize(token: token);

  final isAuthenticated = token != null && token.isNotEmpty;

  runApp(
    ProviderScope(
      child: App(isAuthenticated: isAuthenticated),
    ),
  );
}
