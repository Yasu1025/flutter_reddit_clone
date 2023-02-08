import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/community/repository/community_repository.dart';
import 'package:reddit_clone/models/community_model.dart';
import 'package:routemaster/routemaster.dart';

final communityControllerProvider =
    StateNotifierProvider<CommunityController, bool>(
  (ref) => CommunityController(
    ref.watch(communityRepositoryProvider),
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

class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepository;
  final Ref _ref;

  CommunityController(this._communityRepository, this._ref) : super(false);

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
        (l) => (l) => showSnackBar(
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

  Stream<List<Community>> getCommunitis() {
    final uid = _ref.read(userProvider)!.uid;
    return _communityRepository.getCommunities(uid);
  }

  Stream<Community> getCommunityByName(String name) {
    return _communityRepository.getCommunityByName(name);
  }
}
