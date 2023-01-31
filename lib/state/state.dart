import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reviews_dashboard/services/auth_service.dart';
import 'package:reviews_dashboard/services/db_service.dart';
import 'package:reviews_dashboard/services/location_service.dart';

enum AppType {
  client,
  admin,
}

extension AppTypeExtensions on AppType {
  bool get isClient => this == AppType.client;

  bool get isAdmin => this == AppType.admin;
}

final appTypeProvider = Provider((_) {
  if ([TargetPlatform.linux, TargetPlatform.macOS, TargetPlatform.windows].contains(defaultTargetPlatform)) {
    return AppType.admin;
  }

  return AppType.client;
});

final authProvider = Provider<IAuthService>(
  (_) => FirebaseAuthService(
    firebaseAuth: FirebaseAuth.instance,
  ),
);

final isUserAuthenticatedProvider = StreamProvider(
  (ref) => ref.read(authProvider).onAuthenticatedChanged(),
);

final dbProvider = Provider<IDbService>(
  (_) => FirestoreDbService(
    firestore: FirebaseFirestore.instance,
  ),
);

final reviewsStreamProvider = StreamProvider(
  (ref) => ref.read(dbProvider).reviewsStream(),
);

final locationProvider = Provider<ILocationService>(
  (_) => RandomLocationService(),
);
