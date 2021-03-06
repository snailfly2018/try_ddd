import 'package:another_flushbar/flushbar_helper.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:provider/provider.dart';
import 'package:try_ddd/application/notes/note_form/note_form_bloc.dart';
import 'package:try_ddd/domain/notes/note.dart';
import 'package:try_ddd/presentation/note_form/widgets/add_todo_tile_widget.dart';
import 'package:try_ddd/presentation/note_form/widgets/body_field_widget.dart';
import 'package:try_ddd/presentation/note_form/widgets/color_field_widget.dart';
import 'package:try_ddd/presentation/note_form/widgets/todo_list_widget.dart';
import 'package:try_ddd/presentation/router/router.gr.dart';

import '../../injection.dart';
import 'misc/todo_item_presentation_classes.dart';

class NoteFormPage extends StatelessWidget {
  final Note? editedNote;

  const NoteFormPage({Key? key, this.editedNote}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<NoteFormBloc>()
        ..add(NoteFormEvent.initialized(optionOf(editedNote))),
      child: BlocConsumer<NoteFormBloc, NoteFormState>(
        listenWhen: (previous, current) =>
            previous.saveFailureOrSuccessOption !=
            current.saveFailureOrSuccessOption,
        listener: (context, state) {
          state.saveFailureOrSuccessOption.match(
            (either) {
              either.fold(
                (failure) {
                  FlushbarHelper.createError(
                    message: failure.map(
                        unexpected: (_) =>
                            'Um erro inexperado ocorreu, por favor contate o suporte',
                        insufficientPermission: (_) =>
                            'Permissão insuficiente ❌',
                        unableToUpdate: (_) =>
                            "Couldn't update the note. Was it deleted from another"),
                  ).show(context);
                },
                (_) {
                  AutoRouter.of(context).popUntil((route) {
                    return route.settings.name ==
                        const NotesOverviewRoute().routeName;
                  });
                  // AutoRouter.of(context)
                  //     .replaceAll([const NotesOverviewRoute()]);
                },
              );
            },
            () {},
          );
        },
        buildWhen: (previous, current) => previous.isSaving != current.isSaving,
        builder: (context, state) {
          return Stack(
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              const NoteFormPageScaffold(),
              SavingInProgressOverlay(
                isSaving: state.isSaving,
              ),
            ],
          );
        },
      ),
    );
  }
}

class SavingInProgressOverlay extends StatelessWidget {
  final bool isSaving;
  const SavingInProgressOverlay({
    Key? key,
    required this.isSaving,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !isSaving,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        color: isSaving ? Colors.black.withOpacity(0.8) : Colors.transparent,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Visibility(
          visible: isSaving,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(
                height: 8.0,
              ),
              Text('Saving',
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        color: Colors.white,
                        fontSize: 16.0,
                      )),
            ],
          ),
        ),
      ),
    );
  }
}

class NoteFormPageScaffold extends StatelessWidget {
  const NoteFormPageScaffold({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<NoteFormBloc, NoteFormState>(
          buildWhen: (previous, current) =>
              previous.isEditing != current.isEditing,
          builder: (contex, state) {
            return Text(state.isEditing ? 'Edit a Note' : 'Create a Note');
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              // AutoRouter.of(context).pop();
              context.read<NoteFormBloc>().add(const NoteFormEvent.saved());
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: BlocBuilder<NoteFormBloc, NoteFormState>(
        buildWhen: (previous, current) =>
            previous.showErrorMessages != current.showErrorMessages,
        builder: (context, state) {
          //用ChangeNotifierProvider来给下面的add todo tile和todolist提供可变的todolist数据（state）
          //这里可以用bloc来完成吗？
          return ChangeNotifierProvider(
            create: (_) => FormTodos(),
            child: Form(
              autovalidateMode: state.showErrorMessages
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,
              child: SingleChildScrollView(
                child: Column(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const BodyField(),
                    const ColorField(),
                    const TodoList(),
                    const AddTodoTile(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
