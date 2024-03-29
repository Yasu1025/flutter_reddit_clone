import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/enums/enums.dart';
import 'package:reddit_clone/core/providers/storage_repository_provider.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/user_profile/controller/user_profile_controller.dart';
import 'package:reddit_clone/models/comment_model.dart';
import 'package:reddit_clone/models/community_model.dart';
import 'package:reddit_clone/models/post_model.dart';
import 'package:reddit_clone/models/user_model.dart';
import 'package:reddit_clone/features/post/repository/post_repository.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

final postControllerProvider = StateNotifierProvider<PostController, bool>(
  (ref) => PostController(
    ref.watch(postRepositoryProvider),
    ref.watch(storageRepositoryProvider),
    ref,
  ),
);

final userPostsProvider =
    StreamProvider.family((ref, List<Community> communities) {
  return ref.watch(postControllerProvider.notifier).fetchUserPosts(communities);
});

final getPostByIdProvider = StreamProvider.family(
  (ref, String postId) =>
      ref.watch(postControllerProvider.notifier).getPostById(postId),
);

final getPostCommentsProvider = StreamProvider.family(
  (ref, String postId) =>
      ref.watch(postControllerProvider.notifier).fetchCommentsOfPost(postId),
);

class PostController extends StateNotifier<bool> {
  final PostRepository _postRepository;
  final StorageRepository _storageRepository;
  final Ref _ref;

  PostController(this._postRepository, this._storageRepository, this._ref)
      : super(false);

  void shareTextPost({
    required BuildContext ctx,
    required String title,
    required String description,
    required Community selectedCommunity,
  }) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;
    final createdPost = Post(
      id: postId,
      title: title,
      communityName: selectedCommunity.name,
      communityProfilePic: selectedCommunity.avatar,
      upvotes: [],
      downvotes: [],
      commentCount: 0,
      username: user.name,
      uid: user.uid,
      type: 'text',
      createdAt: DateTime.now(),
      awards: [],
      description: description,
    );

    final res = await _postRepository.addPost(createdPost);
    _ref
        .read(userProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.textPost);
    state = false;
    res.fold(
      (l) => showSnackBar(ctx, l.message),
      (r) {
        showSnackBar(
          ctx,
          'Posted successfuly',
        );
        Routemaster.of(ctx).pop();
      },
    );
  }

  void shareLinkPost({
    required BuildContext ctx,
    required String title,
    required String link,
    required Community selectedCommunity,
  }) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;
    final createdPost = Post(
      id: postId,
      title: title,
      communityName: selectedCommunity.name,
      communityProfilePic: selectedCommunity.avatar,
      upvotes: [],
      downvotes: [],
      commentCount: 0,
      username: user.name,
      uid: user.uid,
      type: 'link',
      createdAt: DateTime.now(),
      awards: [],
      link: link,
    );

    final res = await _postRepository.addPost(createdPost);
    _ref
        .read(userProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.linkPost);

    state = false;
    res.fold(
      (l) => showSnackBar(ctx, l.message),
      (r) {
        showSnackBar(
          ctx,
          'Posted successfuly',
        );
        Routemaster.of(ctx).pop();
      },
    );
  }

  void shareImagePost({
    required BuildContext ctx,
    required String title,
    required File? file,
    required Community selectedCommunity,
  }) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;
    final imageRes = await _storageRepository.storeFile(
        path: 'posts/${selectedCommunity.name}', id: postId, file: file);

    imageRes.fold(
      (l) => showSnackBar(ctx, l.message),
      (r) async {
        final createdPost = Post(
            id: postId,
            title: title,
            communityName: selectedCommunity.name,
            communityProfilePic: selectedCommunity.avatar,
            upvotes: [],
            downvotes: [],
            commentCount: 0,
            username: user.name,
            uid: user.uid,
            type: 'image',
            createdAt: DateTime.now(),
            awards: [],
            link: r);

        final res = await _postRepository.addPost(createdPost);
        _ref
            .read(userProfileControllerProvider.notifier)
            .updateUserKarma(UserKarma.imagePost);

        state = false;
        res.fold(
          (l) => showSnackBar(ctx, l.message),
          (r) {
            showSnackBar(
              ctx,
              'Posted successfuly',
            );
            Routemaster.of(ctx).pop();
          },
        );
      },
    );
  }

  Stream<List<Post>> fetchUserPosts(List<Community> communities) {
    if (communities.isEmpty) Stream.value([]);
    return _postRepository.fetchUserPosts(communities);
  }

  void deletePost(BuildContext ctx, Post post) async {
    final res = await _postRepository.deletePost(post);
    _ref
        .read(userProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.deletePost);

    res.fold(
      (l) => showSnackBar(ctx, l.message),
      (r) {
        showSnackBar(
          ctx,
          'Deleted post successfuly',
        );
      },
    );
  }

  void upvote(Post post) {
    final userID = _ref.read(userProvider)!.uid;
    _postRepository.upvote(post, userID);
  }

  void downvote(Post post) {
    final userID = _ref.read(userProvider)!.uid;
    _postRepository.downvote(post, userID);
  }

  Stream<Post> getPostById(String postId) {
    return _postRepository.getPostById(postId);
  }

// Comments from here
  void addComment({
    required BuildContext ctx,
    required String commentText,
    required Post post,
  }) async {
    UserModel user = _ref.read(userProvider)!;
    String commentId = const Uuid().v1();

    Comment comment = Comment(
        id: commentId,
        text: commentText,
        createdAt: DateTime.now(),
        postId: post.id,
        userId: user.uid,
        username: user.name,
        profileImg: user.profileImg);

    final res = await _postRepository.addComment(comment);
    _ref
        .read(userProfileControllerProvider.notifier)
        .updateUserKarma(UserKarma.comment);

    res.fold(
      (l) => showSnackBar(ctx, l.message),
      (r) {
        showSnackBar(
          ctx,
          'Comment posted successfuly',
        );
      },
    );
  }

  Stream<List<Comment>> fetchCommentsOfPost(String postId) {
    return _postRepository.fetchCommentsOfPost(postId);
  }

  void awardPost({
    required Post post,
    required String award,
    required BuildContext ctx,
  }) async {
    final user = _ref.read(userProvider)!;

    final res = await _postRepository.awardPost(post, award, user.uid);

    res.fold(
      (l) => showSnackBar(ctx, l.message),
      (r) {
        _ref
            .read(userProfileControllerProvider.notifier)
            .updateUserKarma(UserKarma.awardPost);
        _ref.read(userProvider.notifier).update((state) {
          state?.awards.remove(award);
          return state;
        });
        Routemaster.of(ctx).pop();
      },
    );
  }
}
