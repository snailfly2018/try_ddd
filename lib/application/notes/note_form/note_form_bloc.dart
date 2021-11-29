import 'dart:async';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/kt.dart';
import 'package:try_ddd/domain/notes/i_note_repository.dart';
import 'package:try_ddd/domain/notes/note.dart';
import 'package:try_ddd/domain/notes/note_failure.dart';
import 'package:try_ddd/domain/notes/value_objects.dart';
import 'package:try_ddd/presentation/note_form/misc/todo_item_presentation_classes.dart';

part 'note_form_event.dart';
part 'note_form_state.dart';
part 'note_form_bloc.freezed.dart';

@injectable
class NoteFormBloc extends Bloc<NoteFormEvent, NoteFormState> {
  final INoteRepository _noteRepository;

  NoteFormBloc(this._noteRepository) : super(NoteFormState.initial()) {
    on<_BodyChanged>(_onBodyChanged);
    on<_ColorChanged>(_onColorChanged);
    on<_Initialized>(_onInitialized);
    on<_TodosChanged>(_onTodosChanged);
    on<_Saved>(_onSaved);
  }

  // @override
  // Stream<NoteFormState> mapEventToState(
  //   NoteFormEvent event,
  // ) async* {
  //   yield* event.map(
  //     initialized: (e) async* {
  //       yield e.initialNoteOption.fold(
  //         () => state,
  //         (initialNote) => state.copyWith(
  //           note: initialNote,
  //           isEditing: true,
  //         ),
  //       );
  //     },
  //     bodyChanged: (e) async* {
  //       yield state.copyWith(
  //         note: state.note.copyWith(body: NoteBody(e.bodyStr)),
  //         saveFailureOrSuccessOption: none(),
  //       );
  //     },
  //     colorChanged: (e) async* {
  //       yield state.copyWith(
  //         note: state.note.copyWith(color: NoteColor(e.color)),
  //         saveFailureOrSuccessOption: none(),
  //       );
  //     },
  //     todosChanged: (e) async* {
  //       yield state.copyWith(
  //         note: state.note.copyWith(
  //           todos: List3(e.todos.map((primitive) => primitive.toDomain())),
  //         ),
  //         saveFailureOrSuccessOption: none(),
  //       );
  //     },
  //     saved: (e) async* {
  //       Either<NoteFailure, Unit>? failureOrSuccess;

  //       yield state.copyWith(
  //         isSaving: true,
  //         saveFailureOrSuccessOption: none(),
  //       );

  //       if (state.note.failureOption.isNone()) {
  //         failureOrSuccess = state.isEditing
  //             ? await _noteRepository.update(state.note)
  //             : await _noteRepository.create(state.note);
  //       }

  //       yield state.copyWith(
  //         isSaving: false,
  //         showErrorMessages: true,
  //         saveFailureOrSuccessOption: optionOf(failureOrSuccess),
  //       );
  //     },
  //   );
  // }

  FutureOr<void> _onBodyChanged(
      _BodyChanged event, Emitter<NoteFormState> emit) {
    emit(state.copyWith(
      note: state.note.copyWith(body: NoteBody(event.bodyStr)),
      saveFailureOrSuccessOption: none(),
    ));
  }

  FutureOr<void> _onColorChanged(
      _ColorChanged event, Emitter<NoteFormState> emit) {
    emit(state.copyWith(
      note: state.note.copyWith(color: NoteColor(event.color)),
      saveFailureOrSuccessOption: none(),
    ));
  }

  FutureOr<void> _onInitialized(
      _Initialized event, Emitter<NoteFormState> emit) {
    emit(
      event.initialNoteOption.match(
          (initialNote) => state.copyWith(
                note: initialNote,
                isEditing: true,
              ),
          () => state),
    );
  }

  FutureOr<void> _onTodosChanged(
      _TodosChanged event, Emitter<NoteFormState> emit) {
    emit(state.copyWith(
      note: state.note.copyWith(
        todos: List3(event.todos.map((primitive) => primitive.toDomain())),
      ),
      saveFailureOrSuccessOption: none(),
    ));
  }

  FutureOr<void> _onSaved(_Saved event, Emitter<NoteFormState> emit) async {
    Either<NoteFailure, Unit>? failureOrSuccess;

    emit(state.copyWith(
      isSaving: true,
      saveFailureOrSuccessOption: none(),
    ));

    if (state.note.failureOption.isNone()) {
      failureOrSuccess = state.isEditing
          ? await _noteRepository.update(state.note)
          : await _noteRepository.create(state.note);
    }

    emit(state.copyWith(
      isSaving: false,
      showErrorMessages: true,
      saveFailureOrSuccessOption: optionOf(failureOrSuccess),
    ));
  }
}
