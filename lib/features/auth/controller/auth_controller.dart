import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/auth/repository/auth_repository.dart';

final authControllerProvider = Provider(
  (ref) => AuthController(
    ref.read(authRepositoryProvider),
  ),
);

class AuthController {
  final AuthRepository _authRepository;

  AuthController(this._authRepository);

  void signInWithGoogle(BuildContext ctx) async {
    final user = await _authRepository.signInWithGoogle();
    user.fold(
      (l) => showSnackBar(ctx, l.message),
      (r) => null,
    );
  }
}
