import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/core/common/post_card.dart';
import 'package:reddit_clone/models/post_model.dart';
import 'package:reddit_clone/features/post/controller/post_controller.dart';
import 'package:reddit_clone/features/post/widgets/comment_card.dart';

class CommentsScreen extends ConsumerStatefulWidget {
  final String postId;
  const CommentsScreen({
    super.key,
    required this.postId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends ConsumerState<CommentsScreen> {
  final commentCtrl = TextEditingController();

  @override
  void dispose() {
    commentCtrl.dispose();
    super.dispose();
  }

  void onAddComment(Post post) {
    ref.watch(postControllerProvider.notifier).addComment(
          ctx: context,
          commentText: commentCtrl.text,
          post: post,
        );

    setState(() {
      commentCtrl.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ref.watch(getPostByIdProvider(widget.postId)).when(
          data: (post) => Column(
                children: [
                  PostCard(
                    post: post,
                  ),
                  TextField(
                    onSubmitted: (_) => onAddComment(post),
                    controller: commentCtrl,
                    decoration: const InputDecoration(
                      hintText: 'What are your thoughts',
                      filled: true,
                      border: InputBorder.none,
                    ),
                  ),
                  ref.watch(getPostCommentsProvider(widget.postId)).when(
                        data: (comments) {
                          return Expanded(
                            child: ListView.builder(
                              itemCount: comments.length,
                              itemBuilder: ((context, index) {
                                final comment = comments[index];
                                return CommentCard(comment: comment);
                              }),
                            ),
                          );
                        },
                        error: (error, stackTrace) =>
                            ErrorText(error: error.toString()),
                        loading: () => const Loader(),
                      )
                ],
              ),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader()),
    );
  }
}
