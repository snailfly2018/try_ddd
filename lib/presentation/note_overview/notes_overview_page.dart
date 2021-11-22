import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:try_ddd/application/auth/auth_bloc.dart';

class NotesOverviewPage extends StatelessWidget {
  const NotesOverviewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
          leading: IconButton(
          onPressed: () {
            context.read<AuthBloc>().add(const AuthEvent.signedOut());
          },
          icon: const Icon(Icons.exit_to_app),
        ),
      ),
      body: const Center(child: Text('note body'),),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
