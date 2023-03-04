import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  void navigateToUserProfile(BuildContext ctx, String uid) {
    Routemaster.of(ctx).push('/user/$uid');
  }

  void onLogout(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logout();
  }

  void toggleTheme(WidgetRef ref) {
    ref.watch(themeNotifierProvider.notifier).toggleTheme();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            CircleAvatar(
              backgroundImage: NetworkImage(user.profileImg),
              radius: 70,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              user.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text('My Profile'),
              leading: const Icon(Icons.person),
              onTap: () => navigateToUserProfile(context, user.uid),
            ),
            ListTile(
              title: const Text('Logout'),
              leading: Icon(
                Icons.logout,
                color: Pallete.redColor,
              ),
              onTap: () => onLogout(ref),
            ),
            Switch.adaptive(
              value: ref.watch(themeNotifierProvider.notifier).mode ==
                  ThemeMode.dark,
              onChanged: (_) => toggleTheme(ref),
            )
          ],
        ),
      ),
    );
  }
}
