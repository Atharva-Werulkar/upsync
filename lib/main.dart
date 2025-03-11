import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:upsync/utils/theme.dart';

import 'package:upsync/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'assets/creds/.env');

  runApp(ProviderScope(child: const UpSyncApp()));
}

class UpSyncApp extends ConsumerWidget {
  const UpSyncApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ShadApp(
      debugShowCheckedModeBanner: false,
      darkTheme: darkThemeData, // Use the new dark theme data
      home: HomeScreen(),
    );
  }
}
