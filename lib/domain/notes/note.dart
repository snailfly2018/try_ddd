import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kt_dart/collection.dart';
import 'package:try_ddd/domain/core/value_failure.dart';
import 'package:try_ddd/domain/core/value_objects.dart';
import 'package:try_ddd/domain/notes/todoitem.dart';
import 'package:try_ddd/domain/notes/value_objects.dart';

part 'note.freezed.dart';

@freezed
abstract class Note implements _$Note {
  const Note._();
  const factory Note({
    required UniqueId id,
    required NoteBody body,
    required NoteColor color,
    required List3<TodoItem> todos,
  }) = _Note;

  factory Note.empty() => Note(
        id: UniqueId(),
        body: NoteBody(''),
        color: NoteColor(NoteColor.predefinedColors[0]),
        todos: List3(emptyList()),
      );

  Option<ValueFailure<dynamic>> get failureOption {
    var tp = todos
        .getOrCrash()
        // Getting the failureOption from the TodoItem ENTITY - NOT a failureOrUnit from a VALUE OBJECT
        .map((todoItem) => todoItem.failureOption)
        .filter((o) => o.isSome())
        // If we can't get the 0th element, the list is empty. In such a case, it's valid.
        .getOrElse(0, (_) => none());

    return body.failureOrUnit.andThen(() => todos.failureOrUnit).andThen(() {
      var tp = todos
          .getOrCrash()
          // Getting the failureOption from the TodoItem ENTITY - NOT a failureOrUnit from a VALUE OBJECT
          .map((todoItem) => todoItem.failureOption)
          .filter((o) => o.isSome())
          // If we can't get the 0th element, the list is empty. In such a case, it's valid.
          .getOrElse(0, (_) => none());
      return getTodosInfo(tp);
    }).fold((f) => some(f), (_) => none());
  }

  Either<ValueFailure<dynamic>, Unit> getTodosInfo(
      Option<ValueFailure<dynamic>> tp) {
    return tp.match((t) => left(t), () => right(unit));
  }
}
