import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class ModToolsScreen extends StatelessWidget {
  final String communityID;
  const ModToolsScreen({
    super.key,
    required this.communityID,
  });

  void navigateToEditCommunity(BuildContext ctx) {
    Routemaster.of(ctx).push('/edit-community/$communityID');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mod Tools'),
      ),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.add_moderator),
            title: const Text('Add moderaters'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit Community'),
            onTap: () => navigateToEditCommunity(context),
          )
        ],
      ),
    );
  }
}
