import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/core/failuer.dart';
import 'package:reddit_clone/core/providers/storage_repository_provider.dart';
import 'package:reddit_clone/core/type_defs.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/community/repository/community_repository.dart';
import 'package:reddit_clone/models/community_model.dart';
import 'package:routemaster/routemaster.dart';

final communityControllerProvider =
    StateNotifierProvider<CommunityController, bool>(
  (ref) => CommunityController(
    ref.watch(communityRepositoryProvider),
    ref.watch(storageRepositoryProvider),
    ref,
  ),
);

final getCommunityByNameProvider = StreamProvider.family((ref, String name) {
  return ref
      .watch(communityControllerProvider.notifier)
      .getCommunityByName(name);
});

final userCommunitiesProvider = StreamProvider((ref) {
  final communityController = ref.watch(communityControllerProvider.notifier);
  return communityController.getCommunitis();
});

final searchCommunityProvider = StreamProvider.family((ref, String query) {
  return ref.watch(communityControllerProvider.notifier).searchCommunity(query);
});

class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;

  CommunityController(
    this._communityRepository,
    this._storageRepository,
    this._ref,
  ) : super(false);

  void createCommunity(String name, BuildContext ctx) async {
    state = true;
    final uid = _ref.read(userProvider)?.uid ?? '';
    Community community = Community(
        id: name,
        name: name,
        banner: Constants.bannerDefault,
        avatar: Constants.avatarDefault,
        members: [uid],
        mods: [uid]);

    final res = await _communityRepository.createCommunity(community);
    state = false;

    res.fold(
        (l) => showSnackBar(
              ctx,
              l.message,
            ), (r) {
      showSnackBar(
        ctx,
        'Community created successfuly',
      );
      Routemaster.of(ctx).pop();
    });
  }

  void editCommunity({
    required File? bannerFile,
    required File? profileFile,
    required BuildContext ctx,
    required Community community,
  }) async {
    state = true;
    if (profileFile != null) {
      final res = await _storageRepository.storeFile(
        path: 'communities/profile',
        id: community.id,
        file: profileFile,
      );

      res.fold(
        (l) => showSnackBar(ctx, l.message),
        (r) => community = community.copyWith(avatar: r),
      );
    }

    if (bannerFile != null) {
      final res = await _storageRepository.storeFile(
        path: 'communities/banner',
        id: community.id,
        file: bannerFile,
      );

      res.fold(
        (l) => showSnackBar(ctx, l.message),
        (r) => community = community.copyWith(banner: r),
      );
    }

    final res = await _communityRepository.editCommunity(community);

    state = false;

    res.fold(
      (l) => showSnackBar(ctx, l.message),
      (_) => Routemaster.of(ctx).pop(),
    );
  }

  Stream<List<Community>> getCommunitis() {
    final uid = _ref.read(userProvider)!.uid;
    return _communityRepository.getCommunities(uid);
  }

  Stream<Community> getCommunityByName(String name) {
    return _communityRepository.getCommunityByName(name);
  }

  Stream<List<Community>> searchCommunity(String query) {
    return _communityRepository.searchCommunity(query);
  }

  void joinCommunity(Community community, BuildContext ctx) async {
    final user = _ref.read(userProvider)!;
    final isAlreadyJoined = community.members.contains(user.uid);

    Either<Failure, void> res;
    if (isAlreadyJoined) {
      res = await _communityRepository.leaveCommunity(community.id, user.uid);
    } else {
      res = await _communityRepository.joinCommunity(community.id, user.uid);
    }

    res.fold((l) => showSnackBar(ctx, l.message), (r) {
      if (isAlreadyJoined) {
        showSnackBar(ctx, 'Community left successfully!!!');
      } else {
        showSnackBar(ctx, 'Community joined successfully!!!');
      }
    });
  }

  void addMods(String communityId, List<String> uids, BuildContext ctx) async {
    final res = await _communityRepository.addMods(communityId, uids);

    res.fold(
      (l) => showSnackBar(ctx, l.message),
      (_) => Routemaster.of(ctx).pop(),
    );
  }
}
