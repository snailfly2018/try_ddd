import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kt_dart/collection.dart';
import 'package:provider/provider.dart';
import 'package:try_ddd/application/notes/note_form/note_form_bloc.dart';
import 'package:try_ddd/presentation/note_form/misc/build_context_x.dart';
import 'package:try_ddd/presentation/note_form/misc/todo_item_presentation_classes.dart';

class AddTodoTile extends StatelessWidget {
  const AddTodoTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NoteFormBloc, NoteFormState>(
      listenWhen: (previous, current) =>
          previous.isEditing != current.isEditing,
      listener: (context, state) {
        //初始化formTodos
        context.formTodos = state.note.todos.value.fold(
            (failure) => listOf<TodoItemPrimitive>(),
            (todoItemList) =>
                todoItemList.map((_) => TodoItemPrimitive.fromDomain(_)));
      },
      buildWhen: (previous, current) =>
          previous.note.todos.isFull != current.note.todos.isFull,
      builder: (context, state) {
        return ListTile(
          enabled: !state.note.todos.isFull,
          title: const Text('Add a Todo'),
          leading: const Padding(
            padding: EdgeInsets.all(12.0),
            child: Icon(Icons.add),
          ),
          onTap: () {
            //formTodos 里保存了todolist的列表，最多三条
            context.formTodos =
                context.formTodos.plusElement(TodoItemPrimitive.empty());
            context.read<NoteFormBloc>().add(
                  NoteFormEvent.todosChanged(context.formTodos),
                );
          },
        );
      },
    );
  }
}
