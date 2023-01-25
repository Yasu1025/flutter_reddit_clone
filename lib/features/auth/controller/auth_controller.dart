import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/auth/repository/auth_repository.dart';
import 'package:reddit_clone/models/user_model.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    ref.watch(authRepositoryProvider),
    ref,
  ),
);

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;
  // super -> state is for loading
  AuthController(this._authRepository, this._ref) : super(false);

  void signInWithGoogle(BuildContext ctx) async {
    state = true;
    final user = await _authRepository.signInWithGoogle();
    state = false;
    // handling error <Either<Failure, UserModel>
    user.fold(
      (l) => showSnackBar(ctx, l.message),
      (userModel) =>
          _ref.read(userProvider.notifier).update((state) => userModel),
    );
  }
}
