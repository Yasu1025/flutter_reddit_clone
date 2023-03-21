import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/common/error_text.dart';
import 'package:reddit_clone/core/common/loader.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:reddit_clone/models/community_model.dart';
import 'package:reddit_clone/features/post/controller/post_controller.dart';
import 'package:reddit_clone/theme/pallete.dart';

class AddPostTypeScreen extends ConsumerStatefulWidget {
  final String type;
  const AddPostTypeScreen({
    super.key,
    required this.type,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddPostTypeScreenState();
}

class _AddPostTypeScreenState extends ConsumerState<AddPostTypeScreen> {
  final titleTextController = TextEditingController();
  final descriptionTextController = TextEditingController();
  final linkTextController = TextEditingController();
  File? bannerFile;
  List<Community> communities = [];
  Community? selectedCommunity;

  @override
  void dispose() {
    super.dispose();
    titleTextController.dispose();
    descriptionTextController.dispose();
    linkTextController.dispose();
  }

  void selectBannerImage() async {
    final res = await pickImage();

    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  void sharePost() {
    if (widget.type == 'image' &&
        bannerFile != null &&
        titleTextController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareImagePost(
            ctx: context,
            title: titleTextController.text,
            file: bannerFile,
            selectedCommunity: selectedCommunity ?? communities[0],
          );

      return;
    }

    if (widget.type == 'text' && titleTextController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareTextPost(
            ctx: context,
            title: titleTextController.text,
            description: descriptionTextController.text.trim(),
            selectedCommunity: selectedCommunity ?? communities[0],
          );

      return;
    }

    if (widget.type == 'link' &&
        linkTextController.text.isNotEmpty &&
        titleTextController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareLinkPost(
            ctx: context,
            title: titleTextController.text,
            link: linkTextController.text.trim(),
            selectedCommunity: selectedCommunity ?? communities[0],
          );

      return;
    }

    showSnackBar(context, 'Please Enter all the fields');
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);
    final isTypeImage = widget.type == 'image';
    final isTypeText = widget.type == 'text';
    final isTypeLink = widget.type == 'link';
    final isLoading = ref.watch(postControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Post ${widget.type}'),
        actions: [
          TextButton(
            onPressed: sharePost,
            child: const Text('Share'),
          ),
        ],
      ),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: titleTextController,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: 'Enter Title here',
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(18),
                    ),
                    maxLength: 30,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (isTypeImage)
                    GestureDetector(
                      onTap: selectBannerImage,
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(10),
                        dashPattern: const [10, 4],
                        strokeCap: StrokeCap.round,
                        color: currentTheme.textTheme.bodyText2!.color!,
                        child: Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: bannerFile != null
                              ? Image.file(bannerFile!)
                              : const Center(
                                  child: Icon(
                                    Icons.camera_alt_outlined,
                                    size: 40,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  if (isTypeText)
                    TextField(
                      controller: descriptionTextController,
                      decoration: InputDecoration(
                        filled: true,
                        hintText: 'Enter Description here',
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(18),
                      ),
                      maxLines: 5,
                    ),
                  if (isTypeLink)
                    TextField(
                      controller: linkTextController,
                      decoration: InputDecoration(
                        filled: true,
                        hintText: 'Enter Link here',
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(18),
                      ),
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: Text('Select community'),
                  ),
                  ref.watch(userCommunitiesProvider).when(
                      data: (data) {
                        communities = data;
                        if (data.isEmpty) {
                          return const SizedBox();
                        }

                        return DropdownButton(
                          value: selectedCommunity ?? data[0],
                          items: data
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e.name),
                                ),
                              )
                              .toList(),
                          onChanged: (v) {
                            setState(() {
                              selectedCommunity = v;
                            });
                          },
                        );
                      },
                      error: (error, stackTrace) =>
                          ErrorText(error: error.toString()),
                      loading: () => const Loader())
                ],
              ),
            ),
    );
  }
}
