import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/enums/enums.dart';
import 'package:reddit_clone/core/providers/storage_repository_provider.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/user_profile/repository/user_profile_repository.dart';
import 'package:reddit_clone/models/post_model.dart';
import 'package:reddit_clone/models/user_model.dart';
import 'package:routemaster/routemaster.dart';

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>(
        (ref) => UserProfileController(
              ref,
              ref.watch(userProfileRepositoryProvider),
              ref.watch(storageRepositoryProvider),
            ));

final getUserPostsProvider = StreamProvider.family((ref, String uid) =>
    ref.read(userProfileControllerProvider.notifier).getUserPosts(uid));

class UserProfileController extends StateNotifier<bool> {
  final Ref _ref;
  final UserProfileRepository _userProfileRepository;
  final StorageRepository _storageRepository;

  UserProfileController(
    this._ref,
    this._userProfileRepository,
    this._storageRepository,
  ) : super(false);

  void editUserProfile({
    required File? bannerFile,
    required File? profileFile,
    required BuildContext ctx,
    required String newName,
  }) async {
    state = true;
    UserModel user = _ref.read(userProvider)!;
    if (profileFile != null) {
      final res = await _storageRepository.storeFile(
        path: 'users/profile',
        id: user.uid,
        file: profileFile,
      );

      res.fold(
        (l) => showSnackBar(ctx, l.message),
        (r) => user = user.copyWith(profileImg: r),
      );
    }

    if (bannerFile != null) {
      final res = await _storageRepository.storeFile(
        path: 'users/banner',
        id: user.uid,
        file: bannerFile,
      );

      res.fold(
        (l) => showSnackBar(ctx, l.message),
        (r) => user = user.copyWith(banner: r),
      );
    }

    user = user.copyWith(name: newName);
    final res = await _userProfileRepository.editUserProfile(user);

    state = false;

    res.fold(
      (l) => showSnackBar(ctx, l.message),
      (_) {
        _ref.read(userProvider.notifier).update((state) => user);
        Routemaster.of(ctx).pop();
      },
    );
  }

  Stream<List<Post>> getUserPosts(String uid) {
    return _userProfileRepository.getUserPosts(uid);
  }

  void updateUserKarma(UserKarma karma) async {
    UserModel user = _ref.read(userProvider)!;
    user = user.copyWith(karma: user.karma + karma.karma);

    final res = await _userProfileRepository.updateUserKarma(user);
    res.fold(
      (l) => null,
      (r) => _ref.read(userProvider.notifier).update((state) => user),
    );
  }
}
