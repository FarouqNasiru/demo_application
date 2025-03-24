import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'post_edit_dialog.dart';

class PostsScreen extends StatelessWidget {
  const PostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Posts by ${appState.currentUser!['name']}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => appState.logout(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showEditDialog(context, null),
      ),
      body: appState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : appState.error != null
              ? Text('${appState.error}')
              : ListView.builder(
                  itemCount: appState.posts.length,
                  itemBuilder: (context, index) {
                    final post = appState.posts[index];
                    final isCurrentUserPost =
                        post['userId'] == appState.currentUser!['id'];

                    return Card(
                      child: ListTile(
                        title: Text(post['title']),
                        subtitle: Text(post['body']),
                        trailing: isCurrentUserPost
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () =>
                                        _showEditDialog(context, post),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () =>
                                        appState.deletePost(post['id']),
                                  ),
                                ],
                              )
                            : null,
                      ),
                    );
                  },
                ),
    );
  }

  void _showEditDialog(BuildContext context, Map<String, dynamic>? post) {
    showDialog(
      context: context,
      builder: (context) => PostEditDialog(post: post),
    );
  }
}
