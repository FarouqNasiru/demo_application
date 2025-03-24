import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';

class PostEditDialog extends StatefulWidget {
  final Map<String, dynamic>? post;

  const PostEditDialog({super.key, this.post});

  @override
  State<PostEditDialog> createState() => _PostEditDialogState();
}

class _PostEditDialogState extends State<PostEditDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.post != null) {
      _titleController.text = widget.post!['title'];
      _bodyController.text = widget.post!['body'];
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return AlertDialog(
      title: Text(widget.post == null ? 'Create Post' : 'Edit Post'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (value) => value!.isEmpty ? 'Required' : null,
            ),
            TextFormField(
              controller: _bodyController,
              decoration: const InputDecoration(labelText: 'Body'),
              validator: (value) => value!.isEmpty ? 'Required' : null,
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: appState.isLoading
              ? null
              : () async {
                  if (_formKey.currentState!.validate()) {
                    if (widget.post == null) {
                      await appState.createPost(
                        _titleController.text,
                        _bodyController.text,
                      );
                    } else {
                      await appState.updatePost(
                        widget.post!['id'],
                        _titleController.text,
                        _bodyController.text,
                      );
                    }
                    Navigator.pop(context);
                  }
                },
          child: const Text('Save'),
        ),
      ],
    );
  }
}