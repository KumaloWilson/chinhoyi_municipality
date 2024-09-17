import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// UserProvider with Riverpod
class UserNotifier extends StateNotifier<User?> {
  UserNotifier() : super(null);

  User? get user => state;

  void updateUser(User? user) {
    state = user;
  }
}
