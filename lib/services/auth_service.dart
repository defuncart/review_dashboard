import 'package:firebase_auth/firebase_auth.dart';

abstract class IAuthService {
  Stream<bool> onAuthenticatedChanged();
  Future<void> login();
  Future<void> logout();
}

class FirebaseAuthService implements IAuthService {
  const FirebaseAuthService({
    required FirebaseAuth firebaseAuth,
  }) : _firebaseAuth = firebaseAuth;

  final FirebaseAuth _firebaseAuth;

  @override
  Stream<bool> onAuthenticatedChanged() => _firebaseAuth.authStateChanges().map((event) => event != null);

  @override
  Future<void> login() => _firebaseAuth.signInAnonymously();

  @override
  Future<void> logout() => _firebaseAuth.signOut();
}
