// LoggedOut
// LoggedIn

import 'package:flutter/material.dart';
import 'package:reddit_clone/features/auth/screens/login.dart';
import 'package:reddit_clone/features/community/screens/add_mods_screen.dart';
import 'package:reddit_clone/features/community/screens/community_screen.dart';
import 'package:reddit_clone/features/community/screens/create_community_screen.dart';
import 'package:reddit_clone/features/community/screens/edit_community_screen.dart';
import 'package:reddit_clone/features/community/screens/mod_tools_screen.dart';
import 'package:reddit_clone/features/home/screens/home_screen.dart';
import 'package:reddit_clone/features/user_profile/screens/edit_profile_screen.dart';
import 'package:reddit_clone/features/user_profile/screens/user_profile_screen.dart';
import 'package:reddit_clone/features/post/screens/add_post_type_screen.dart';
import 'package:reddit_clone/features/post/screens/comments_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: LoginScreen()),
});

final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: HomeScreen()),
  '/create_community': (_) =>
      const MaterialPage(child: CreateCommunityScreen()),
  '/community/:name': (route) => MaterialPage(
        child: CommunityScreen(
          communityID: route.pathParameters['name']!,
        ),
      ),
  '/mod-tools/:id': (route) => MaterialPage(
        child: ModToolsScreen(
          communityID: route.pathParameters['id']!,
        ),
      ),
  '/edit-community/:id': (route) => MaterialPage(
        child: EditCommunityScreen(
          communityID: route.pathParameters['id']!,
        ),
      ),
  '/add-mods/:id': (route) => MaterialPage(
        child: AddModsScreen(
          communityID: route.pathParameters['id']!,
        ),
      ),
  '/user/:uid': (route) => MaterialPage(
        child: UserProfileScreen(
          uid: route.pathParameters['uid']!,
        ),
      ),
  '/edit-profile/:uid': (route) => MaterialPage(
        child: EditProfileScreen(
          uid: route.pathParameters['uid']!,
        ),
      ),
  '/add-post/:type': (route) => MaterialPage(
        child: AddPostTypeScreen(
          type: route.pathParameters['type']!,
        ),
      ),
  '/post/:postid/comment': (route) => MaterialPage(
        child: CommentsScreen(
          postId: route.pathParameters['postid']!,
        ),
      ),
});
