import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:reddit_clone/models/post_model.dart';
import 'package:reddit_clone/post/controller/post_controller.dart';
import 'package:reddit_clone/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class PostCard extends ConsumerWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  void onDeletePost(BuildContext ctx, WidgetRef ref) {
    ref.read(postControllerProvider.notifier).deletePost(ctx, post);
  }

  void onUpvote(WidgetRef ref) {
    ref.read(postControllerProvider.notifier).upvote(post);
  }

  void onDownvote(WidgetRef ref) {
    ref.read(postControllerProvider.notifier).downvote(post);
  }

  void navigateToUser(BuildContext ctx) {
    Routemaster.of(ctx).push('/user/${post.uid}');
  }

  void navigateToCommunity(BuildContext ctx) {
    Routemaster.of(ctx).push('/community/${post.communityName}');
  }

  void navigateToComments(BuildContext ctx) {
    Routemaster.of(ctx).push('/post/${post.id}/comment');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider);
    final user = ref.watch(userProvider)!;
    final isTypeImage = post.type == 'image';
    final isTypeText = post.type == 'text';
    final isTypeLink = post.type == 'link';
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: currentTheme.drawerTheme.backgroundColor,
          ),
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 10,
                      ).copyWith(right: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => navigateToCommunity(context),
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        post.communityProfilePic,
                                      ),
                                      radius: 16,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          post.communityName,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () => navigateToUser(context),
                                          child: Text(
                                            post.username,
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              if (post.uid == user.uid)
                                IconButton(
                                  onPressed: () => onDeletePost(context, ref),
                                  icon: Icon(
                                    Icons.delete,
                                    color: Pallete.redColor,
                                  ),
                                ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              post.title,
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (isTypeImage)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                              ),
                              child: Image.network(
                                post.link!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          if (isTypeLink)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                              ),
                              child: AnyLinkPreview(
                                displayDirection:
                                    UIDirection.uiDirectionHorizontal,
                                link: post.link!,
                              ),
                            ),
                          if (isTypeText)
                            Container(
                              alignment: Alignment.bottomLeft,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Text(
                                post.description!,
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () => onUpvote(ref),
                                    icon: Icon(
                                      Constants.up,
                                      size: 30,
                                      color: post.upvotes.contains(user.uid)
                                          ? Pallete.redColor
                                          : null,
                                    ),
                                  ),
                                  Text(
                                    '${post.upvotes.length - post.downvotes.length == 0 ? 'Vote' : post.upvotes.length - post.downvotes.length}',
                                    style: const TextStyle(fontSize: 17),
                                  ),
                                  IconButton(
                                    onPressed: () => onDownvote(ref),
                                    icon: Icon(
                                      Constants.down,
                                      size: 30,
                                      color: post.downvotes.contains(user.uid)
                                          ? Pallete.blueColor
                                          : null,
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () =>
                                        navigateToComments(context),
                                    icon: const Icon(
                                      Icons.comment,
                                    ),
                                  ),
                                  Text(
                                    '${post.commentCount == 0 ? 'Comment' : post.commentCount}',
                                    style: const TextStyle(fontSize: 17),
                                  ),
                                ],
                              ),
                              ref
                                  .watch(getCommunityByNameProvider(
                                      post.communityName))
                                  .when(
                                      data: (community) {
                                        if (community.mods.contains(user.uid)) {
                                          return IconButton(
                                            onPressed: () =>
                                                onDeletePost(context, ref),
                                            icon: const Icon(
                                              Icons.admin_panel_settings,
                                            ),
                                          );
                                        }

                                        return const SizedBox();
                                      },
                                      error: (error, stackTrace) =>
                                          ErrorText(error: error.toString()),
                                      loading: () => const Loader())
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
