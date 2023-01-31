import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reviews_dashboard/state/state.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({
    required this.onBuildDashboard,
    super.key,
  });

  final WidgetBuilder onBuildDashboard;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAuthenticated = ref.watch(isUserAuthenticatedProvider);
    return isAuthenticated.map(
      loading: (_) => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error) => Center(
        child: Text(error.toString()),
      ),
      data: (data) {
        if (data.value) {
          return onBuildDashboard(context);
        }

        Future.microtask(() => ref.read(authProvider).login());
        return const SizedBox.shrink();
      },
    );
  }
}
