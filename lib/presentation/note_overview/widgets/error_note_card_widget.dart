import 'package:flutter/material.dart';
import 'package:try_ddd/domain/notes/note.dart';

class ErrorNoteCard extends StatelessWidget {
  final Note note;
  const ErrorNoteCard({Key? key, required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).errorColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text(
              'Invalid Note, please contact support',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            const SizedBox(
              height: 2,
            ),
            const Text(
              'Details for nerds: ',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            Text(
              note.failureOption.match((f) => f.toString(),() => ''),
              style: const TextStyle(fontStyle: FontStyle.italic),
            )
          ],
        ),
      ),
    );
  }
}
