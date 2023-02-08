import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reviews_dashboard/state/state.dart';
import 'package:reviews_dashboard/widgets/admin/admin_app.dart';
import 'package:reviews_dashboard/widgets/client/client_app.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAdmin = ref.read(appTypeProvider).isAdmin;

    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: isAdmin ? const AdminApp() : const ClientApp(),
    );
  }
}
