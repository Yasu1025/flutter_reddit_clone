import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class AddPostScreen extends ConsumerWidget {
  const AddPostScreen({super.key});

  void navigateToAddType(BuildContext ctx, String type) {
    Routemaster.of(ctx).push('/add-post/$type');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double cardSize = 120;
    double iconSize = 60;
    final currentTheme = ref.watch(themeNotifierProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => navigateToAddType(context, 'image'),
          child: SizedBox(
            width: cardSize,
            height: cardSize,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 16,
              color: currentTheme.backgroundColor,
              child: Center(
                child: Icon(
                  Icons.image_outlined,
                  size: iconSize,
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => navigateToAddType(context, 'text'),
          child: SizedBox(
            width: cardSize,
            height: cardSize,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 16,
              color: currentTheme.backgroundColor,
              child: Center(
                child: Icon(
                  Icons.font_download_outlined,
                  size: iconSize,
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () => navigateToAddType(context, 'link'),
          child: SizedBox(
            width: cardSize,
            height: cardSize,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 16,
              color: currentTheme.backgroundColor,
              child: Center(
                child: Icon(
                  Icons.link_outlined,
                  size: iconSize,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
